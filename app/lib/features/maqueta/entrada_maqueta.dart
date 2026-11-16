import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/router/destino_de_regreso_provider.dart';
import 'package:app/core/router/rutas.dart';
import 'package:app/core/sesion/almacen_seguro.dart';
import 'package:app/features/cuenta/presentation/perfil_controller.dart';
import 'package:app/features/entrada/entrada.dart';
import 'package:app/features/entrada/presentation/entrada_controller.dart';
import 'package:app/features/entrada/presentation/mensaje_de_error.dart';
import 'package:app/features/inicio/inicio.dart';
import 'package:app/features/inicio/inicio_providers.dart';
import 'package:app/features/maqueta/cobertura.dart';
import 'package:app/features/maqueta/datos.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/inicio_maqueta.dart';
import 'package:app/features/maqueta/nav.dart';
import 'package:app/features/maqueta/pantallas_cuenta.dart';
import 'package:app/features/maqueta/pantallas_tecnico.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Entrada del cliente (filas 07 a 12 de la maqueta): hoja sobre el mapa con
/// celular, código, nombre, zona (ubicación o código postal) y foto. El SMS y
/// la sesión son reales (Firebase + canje); la zona por código postal y la
/// foto son simuladas como en la maqueta.
class EntradaMaqueta extends ConsumerStatefulWidget {
  const EntradaMaqueta({super.key, this.paso = 'phone'});
  final String paso; // phone | name
  @override
  ConsumerState<EntradaMaqueta> createState() => _EntradaState();
}

class _EntradaState extends ConsumerState<EntradaMaqueta> {
  late String step = widget.paso;
  final _phone = TextEditingController();
  final _code = TextEditingController();
  final _name = TextEditingController();
  final _cp = TextEditingController();
  int secs = 42;
  Timer? _t;
  String celular = '';
  bool phoneErr = false, codeErr = false, nameErr = false, saving = false;
  // zona
  ({String col, String cp, bool out, bool approx})? zone;
  bool zbusy = false, cpOpen = false;
  String zerr = '';
  String? photo;
  String? generalErr;

  @override
  void initState() {
    super.initState();
    if (step == 'name') maq.user.first = '';
  }

  @override
  void dispose() {
    _t?.cancel();
    _phone.dispose();
    _code.dispose();
    _name.dispose();
    _cp.dispose();
    super.dispose();
  }

  void _startTimer() {
    _t?.cancel();
    secs = 42;
    _t = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (secs > 0) setState(() => secs--);
    });
  }

  Future<void> _send() async {
    final d = digits(_phone.text);
    if (!esCelularValido(d)) {
      setState(() => phoneErr = true);
      return;
    }
    FocusScope.of(context).unfocus();
    final ok = await ref
        .read(entradaControllerProvider.notifier)
        .enviarCodigo(d);
    if (ok && mounted) {
      setState(() {
        celular = d;
        step = 'code';
        _code.clear();
        phoneErr = false;
      });
      unawaited(
        maq.guardarTelefono(fmtPhone(d), ref.read(almacenSeguroProvider)),
      );
      _startTimer();
    }
  }

  Future<void> _verify() async {
    final code = _code.text;
    final valido = esCodigoValido(code);
    setState(() => codeErr = !valido);
    if (valido) {
      FocusScope.of(context).unfocus();
      await ref.read(entradaControllerProvider.notifier).verificar(code);
    }
  }

  Future<void> _resend() async {
    final ok = await ref.read(entradaControllerProvider.notifier).reenviar();
    if (ok && mounted) {
      _startTimer();
      maq.toast('Te mandamos un código nuevo');
    }
  }

  void _close() => context.go(Rutas.previa);

  // zona ---------------------------------------------------------------
  void _cpGo() {
    final cp = digits(_cp.text);
    if (cp.length != 5) return;
    if (!cp.startsWith('428')) {
      setState(
        () => zerr = 'Por ahora Knock solo atiende Tula de Allende y alrededores (códigos postales que empiezan con 428).',
      );
      return;
    }
    setState(() {
      zerr = '';
      zone = (
        col: cpCol[cp] ?? 'Col. Centro',
        cp: cp,
        out: false,
        approx: !cpCol.containsKey(cp),
      );
    });
  }

  Future<void> _geo() async {
    setState(() {
      zerr = '';
      zbusy = true;
    });
    double? lat, lng;
    final sim = maq.ubicacionSimulada;
    if (sim != null) {
      lat = sim.lat;
      lng = sim.lng;
    } else {
      final r = await ref.read(ubicacionRepositoryProvider).obtenerUnaVez();
      if (r is Concedida) {
        lat = r.latitud;
        lng = r.longitud;
      }
    }
    if (!mounted) return;
    setState(() {
      zbusy = false;
      if (lat == null || lng == null) {
        zerr = 'No pudimos obtener tu ubicación. Escribe tu código postal.';
        return;
      }
      // Solo se usa la colonia; las coordenadas se descartan.
      final c = evaluarCobertura(lat, lng);
      if (c.dentro) {
        zone = (col: c.zona.colonia, cp: c.zona.cp, out: false, approx: false);
      } else {
        step = 'fuera';
      }
    });
  }

  Future<void> _finish() async {
    setState(() {
      saving = true;
      generalErr = null;
    });
    final nm = _name.text.trim().replaceAll(RegExp(r'\s+'), ' ');
    final err = await ref
        .read(perfilControllerProvider.notifier)
        .guardarNombre(nm);
    if (!mounted) return;
    if (err != null) {
      setState(() {
        saving = false;
        generalErr = err is Failure
            ? mensajeDeErrorDeEntrada(AppLocalizations.of(context), err)
            : 'No pudimos guardar tu nombre. Inténtalo de nuevo.';
      });
      return;
    }
    maq.user.name = nm;
    maq.user.first = nm.split(' ').first;
    maq.user.photoPath = photo;
    maq.refresh();
    setState(() {
      saving = false;
      step = 'done';
    });
  }

  void _go() {
    final destino = destinoDeRegreso(
      ref.read(destinoDeRegresoProvider),
      maqueta: true,
    );
    ref.read(destinoDeRegresoProvider.notifier).olvidar();
    context.go(destino);
  }

  @override
  Widget build(BuildContext context) {
    final k = kc(context);
    final entrada = ref.watch(entradaControllerProvider);
    final textos = AppLocalizations.of(context);
    final remoteErr = entrada.error == null
        ? null
        : mensajeDeErrorDeEntrada(textos, entrada.error!);
    final busy = entrada.cargando;

    Widget head(String title, {bool opt = false, bool close = true}) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: tr(title)),
                if (opt)
                  TextSpan(
                    text: ' ${tr('(opcional)')}',
                    style: TextStyle(fontWeight: FontWeight.w700, color: k.mut),
                  ),
              ],
            ),
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 26,
              fontWeight: FontWeight.w900,
              height: 1.15,
              color: k.ink,
            ),
          ),
        ),
        if (close)
          InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: _close,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: k.surface2,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, color: k.ink),
            ),
          ),
      ],
    );

    final List<Widget> body;
    if (step == 'phone') {
      body = [
        head('Entra con tu celular'),
        mutT(
          'Si es tu primera vez, se crea tu cuenta. Tu número no se muestra a nadie.',
        ),
        FieldK(
          label: 'Tu número de celular',
          c: _phone,
          hint: '771 234 5678',
          keyboard: TextInputType.number,
          maxLen: 12,
          prefix: const PhoneCc(),
          help: 'Te mandaremos un código por mensaje (SMS).',
          err: phoneErr ? 'Escribe los 10 números de tu celular' : remoteErr,
          onChanged: (_) {
            setState(() => phoneErr = false);
            ref.read(entradaControllerProvider.notifier).limpiarError();
          },
          onSubmit: (_) => _send(),
        ),
        BtnK(
          busy ? 'Enviando…' : 'Enviarme el código',
          digits(_phone.text).length == 10 && !busy ? _send : null,
          busy: busy,
        ),
        BtnK('Ahora no, seguir viendo', _close, kind: Bk.ghost),
        Center(
          child: LinkK(
            '¿Ya no tienes ese número?',
            () => cambiarNumero(context, recuperar: true),
          ),
        ),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            sMut('Al continuar aceptas los ', size: 14),
            InkWell(
              onTap: () => context.push(RM.terminos),
              child: T('Términos', size: 14, w: FontWeight.w800, color: k.navy),
            ),
            sMut(' y el ', size: 14),
            InkWell(
              onTap: () => context.push(RM.aviso),
              child: T(
                'Aviso de privacidad',
                size: 14,
                w: FontWeight.w800,
                color: k.navy,
              ),
            ),
            sMut('.', size: 14),
          ],
        ),
        Divider(color: k.line2, height: 1),
        InkWell(
          onTap: () => context.push(RT.registro),
          child: Row(
            spacing: 14,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: k.amberSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icn('wrench'), color: k.amberInk),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const T('¿Ofreces servicios?', w: FontWeight.w800),
                    sMut('Regístrate como proveedor', size: 13.5),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: k.mut),
            ],
          ),
        ),
      ];
    } else if (step == 'code') {
      body = [
        head('Escribe el código'),
        rich(
          'Lo mandamos por SMS al **+52 ${fmtPhone(celular)}**.',
          w: FontWeight.w400,
        ),
        FieldK(
          label: 'Código de 6 números',
          c: _code,
          hint: '••••••',
          keyboard: TextInputType.number,
          maxLen: 6,
          center: true,
          autofocus: true,
          err: codeErr ? 'Escribe los 6 números del código' : remoteErr,
          help: 'En esta demostración funciona cualquier código de 6 números.',
          onChanged: (_) {
            setState(() => codeErr = false);
            ref.read(entradaControllerProvider.notifier).limpiarError();
          },
          onSubmit: (_) => _verify(),
        ),
        BtnK(
          busy ? 'Entrando…' : 'Entrar',
          digits(_code.text).length == 6 && !busy ? _verify : null,
          busy: busy,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LinkK(
              'Cambiar número',
              () => setState(() {
                step = 'phone';
                _t?.cancel();
              }),
            ),
            if (secs > 0)
              T(
                'Reenviar en 0:${secs.toString().padLeft(2, '0')}',
                size: 14,
                w: FontWeight.w800,
                color: k.mut,
              )
            else
              LinkK('Reenviar código', _resend),
          ],
        ),
      ];
    } else if (step == 'name') {
      final nm = _name.text.trim().replaceAll(RegExp(r'\s+'), ' ');
      final ok =
          nm.length >= 2 &&
          RegExp(r"^[A-Za-zÁÉÍÓÚÜÑáéíóúüñ' .-]+$").hasMatch(nm);
      body = [
        head('¿Cómo te llamas?'),
        mutT('Así te saludamos y los técnicos saben con quién hablan.'),
        FieldK(
          label: 'Tu nombre',
          c: _name,
          hint: 'Ej.: Mariana López',
          err: nameErr && !ok ? 'Escribe tu nombre (solo letras)' : null,
          onChanged: (_) => setState(() => nameErr = false),
          onSubmit: (_) {
            if (ok) {
              setState(() {
                step = 'zone';
              });
            } else {
              setState(() => nameErr = true);
            }
          },
        ),
        BtnK('Continuar', () {
          if (ok) {
            setState(() => step = 'zone');
          } else {
            setState(() => nameErr = true);
          }
        }),
      ];
    } else if (step == 'zone') {
      final cpOk = RegExp(r'^\d{5}$').hasMatch(digits(_cp.text));
      final z = zone;
      body = [head('¿Dónde buscas expertos?')];
      if (z != null) {
        body.addAll([
          CardK(
            child: stack([
              sMut('Te ubicamos en'),
              Row(
                spacing: 6,
                children: [
                  Icon(icn('pin'), size: 18),
                  Expanded(
                    child: h3(
                      '${z.col}, Tula de Allende${z.cp.isNotEmpty ? ' · CP ${z.cp}' : ''}',
                    ),
                  ),
                ],
              ),
              if (z.out)
                T(
                  'Estás fuera de Tula de Allende. Por ahora la maqueta te muestra expertos de ejemplo de esta ciudad.',
                  size: 14,
                  w: FontWeight.w800,
                  color: k.amberInk,
                )
              else if (z.approx)
                sMut('Zona aproximada por tu código postal. Puedes ajustarla.'),
            ], gap: 6),
          ),
          stack([
            labT('¿No es tu colonia? Cámbiala'),
            chipsWrap([
              for (final c in colores)
                ChipK(
                  c,
                  on: z.col == c,
                  onTap: () => setState(
                    () =>
                        zone = (col: c, cp: z.cp, out: z.out, approx: z.approx),
                  ),
                ),
            ]),
          ], gap: 8),
          sMut(
            'Solo guardamos tu colonia${z.cp.isNotEmpty ? ' y tu código postal' : ''}, nunca tu ubicación exacta.',
          ),
          BtnK('Continuar', () {
            maq.user.col = z.col;
            maq.user.cp = z.cp;
            setState(() => step = 'photo');
          }),
          BtnK(
            'Usar otra opción',
            () => setState(() {
              zone = null;
              zerr = '';
            }),
            kind: Bk.ghost,
          ),
        ]);
      } else {
        body.addAll([
          rich(
            'Para mostrarte los expertos que atienden cerca de ti. Solo guardamos tu **colonia**, no tu ubicación exacta.',
            w: FontWeight.w400,
          ),
          BtnK(
            zbusy ? 'Buscando tu ubicación…' : 'Usar mi ubicación',
            zbusy ? null : _geo,
            icon: 'locate',
          ),
          Divider(color: k.line2, height: 1),
          if (cpOpen || zerr.isNotEmpty || _cp.text.isNotEmpty) ...[
            FieldK(
              label: 'Tu código postal',
              c: _cp,
              hint: 'Ej.: 42800',
              keyboard: TextInputType.number,
              maxLen: 5,
              err: zerr.isEmpty ? null : zerr,
              onChanged: (_) => setState(() => zerr = ''),
              onSubmit: (_) => _cpGo(),
            ),
            BtnK(
              'Continuar con mi código postal',
              cpOk ? _cpGo : null,
              kind: Bk.sec,
            ),
          ] else
            BtnK(
              'O escribir mi código postal',
              () => setState(() => cpOpen = true),
              kind: Bk.ghost,
            ),
          if (zerr.isNotEmpty && !(cpOpen || _cp.text.isNotEmpty))
            Row(
              spacing: 6,
              children: [
                Icon(Icons.close, size: 16, color: k.red),
                Expanded(
                  child: T(zerr, size: 14, w: FontWeight.w800, color: k.red),
                ),
              ],
            ),
          BtnK(
            'Ahora no',
            () => setState(() => step = 'photo'),
            kind: Bk.ghost,
          ),
        ]);
      }
    } else if (step == 'fuera') {
      body = [
        PantallaFueraDeCobertura(
          enHoja: false,
          alCerrar: () => setState(() => step = 'zone'),
          alExplorar: () async {
            final z = await elegirZonaDisponible(context);
            if (z != null && mounted) {
              setState(() {
                zone = (col: z.colonia, cp: z.cp, out: false, approx: false);
                step = 'zone';
              });
            }
          },
        ),
      ];
    } else if (step == 'photo') {
      body = [
        head('Tu foto', opt: true),
        mutT(
          'Ayuda a que el técnico sepa con quién habla. Si no pones una, usamos tus iniciales.',
        ),
        Center(
          child: Column(
            spacing: 12,
            children: [
              Av(
                ini: initials(_name.text),
                color: const Color(0xFF2A5568),
                size: 96,
                photo: photo,
              ),
              BtnK(
                photo != null ? 'Cambiar foto' : 'Elegir una foto',
                () async {
                  final f = await elegirFotos(varias: false);
                  if (f.isNotEmpty) setState(() => photo = f.first);
                },
                kind: Bk.sec,
                sm: true,
                auto: true,
                icon: 'camera',
              ),
            ],
          ),
        ),
        if (generalErr != null)
          Row(
            spacing: 6,
            children: [
              Icon(Icons.close, size: 16, color: k.red),
              Expanded(
                child: T(
                  generalErr!,
                  size: 14,
                  w: FontWeight.w800,
                  color: k.red,
                ),
              ),
            ],
          ),
        BtnK(
          saving
              ? 'Guardando…'
              : (photo != null ? 'Continuar' : 'Usar mis iniciales'),
          saving ? null : _finish,
          kind: photo != null ? Bk.pri : Bk.sec,
        ),
      ];
    } else {
      body = [
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            spacing: 14,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: k.greenSoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, size: 52, color: k.green),
              ),
              h1('¡Listo, ya entraste!', a: TextAlign.center),
              mutT(
                'Hola, ${maq.user.first}. Seguimos justo donde te quedaste.',
                a: TextAlign.center,
              ),
            ],
          ),
        ),
        BtnK(
          ref.read(destinoDeRegresoProvider) != null
              ? 'Continuar'
              : 'Ir a mi inicio',
          _go,
        ),
      ];
    }

    return Scaffold(
      backgroundColor: k.bg,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const Positioned.fill(
            child: IgnorePointer(child: InicioMaqueta(conCuenta: false)),
          ),
          const Positioned.fill(child: ColoredBox(color: Color(0x7315202F))),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 150),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * .92,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: k.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(26),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    10,
                    20,
                    22 + MediaQuery.of(context).padding.bottom,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 16,
                    children: [
                      Center(
                        child: Container(
                          width: 44,
                          height: 5,
                          decoration: BoxDecoration(
                            color: k.line,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                      ...body,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
