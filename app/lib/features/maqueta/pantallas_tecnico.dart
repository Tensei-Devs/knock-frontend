import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:app/features/actividad/actividad.dart'
    show solicitudesRealesActivasProvider;
import 'package:app/features/maqueta/asistente_real.dart';
import 'package:app/features/maqueta/detalle_oficio_real.dart';
import 'package:app/features/maqueta/solicitudes_reales.dart'
    show coloniaIdDeLaPersona;
import 'package:app/features/oficios/oficios.dart';
import 'package:app/features/tecnico/tecnico.dart';

import 'dart:async';

import 'package:app/core/sesion/es_tecnico_provider.dart';
import 'package:app/features/cuenta/presentation/perfil_controller.dart';
import 'package:app/features/entrada/presentation/entrada_controller.dart';
import 'package:app/features/maqueta/datos.dart';
import 'package:app/features/maqueta/carga_k.dart';
import 'package:app/features/maqueta/conversaciones_reales.dart';
import 'package:app/features/maqueta/pantalla_segun_sesion.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/oficios_reales.dart';
import 'package:app/features/maqueta/nav.dart';
import 'package:app/features/maqueta/pantallas_actividad.dart';
import 'package:app/features/maqueta/rutas_tecnico.dart';
import 'package:app/features/maqueta/servicios_reales.dart';
import 'package:app/features/maqueta/tecnico_estado.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

export 'package:app/features/maqueta/rutas_tecnico.dart' show RT;

TecEstado get pv => maq.pv;

/// `true` mientras la pantalla «Estamos revisando» está abierta.
bool pendienteAbierta = false;

String _catIcon(String id) => id == 'mec'
    ? 'car'
    : id == 'plo'
    ? 'drop'
    : 'bolt';

void registrarRutasTecnico(GoRouter router) {
  pv.irChat = (cid, rid) => router.push(RT.chat(cid, rid));
  pv.irA = (d) => router.go(d == 'reputacion' ? '/cuenta' : '/trabajo');
  pv.alCambiarVerif = (e) {
    if (pendienteAbierta) {
      switch (e) {
        case 'verificado':
          unawaited(router.pushReplacement(RT.verificado));
        case 'rechazado':
          unawaited(router.pushReplacement(RT.rechazada));
        case 'expirado':
          unawaited(router.pushReplacement(RT.verif));
      }
    } else {
      switch (e) {
        case 'revision':
          maq.toast('Tu verificación pasó a revisión manual');
        case 'rechazado':
          maq.toast(
            'No pudimos verificar tu identidad',
            accion: 'Ver',
            alAccion: () => router.push(RT.rechazada),
          );
        case 'expirado':
          maq.toast(
            'Tus fotos se borraron sin revisarse',
            accion: 'Reenviar',
            alAccion: () => router.push(RT.verif),
          );
        case 'verificado':
          maq.toast(
            '¡Tu identidad fue verificada!',
            accion: 'Continuar',
            alAccion: () => router.go('/trabajo'),
          );
      }
    }
  };
}

// ------------------------------------------------------------ bloques reutilizables

Widget tradesBlock(
  BuildContext c, {
  required Set<String> sel,
  required bool otherOn,
  required TextEditingController other,
  required String? errCats,
  required String? errOther,
  required void Function(String) toggle,
  required VoidCallback toggleOther,
  required VoidCallback onChanged,
}) {
  return stack([
    Row(
      spacing: 6,
      children: [
        labT('¿Qué haces?'),
        T(
          '(puedes elegir varias)',
          size: 15,
          w: FontWeight.w700,
          color: kc(c).mut,
        ),
      ],
    ),
    if (maq.oficiosError && maq.oficios.isEmpty) const AvisoOficios(),
    for (final k in maq.oficios)
      ChoiceK(
        on: sel.contains(k),
        check: true,
        minH: 62,
        onTap: () => toggle(k),
        title: cats[k]!.name,
        leading: Icon(icn(_catIcon(k))),
      ),
    ChoiceK(
      on: otherOn,
      check: true,
      minH: 62,
      onTap: toggleOther,
      title: 'Otro oficio',
      sub: 'Escríbelo tú',
      leading: Icon(icn('wrench')),
    ),
    if (otherOn)
      FieldK(
        label: '¿Cuál es tu oficio?',
        c: other,
        maxLen: 40,
        hint: 'Ej.: Herrería, carpintería, pintura',
        err: errOther,
        help: 'Se muestra en tu perfil. Por ahora Knock recibe solicitudes de mecánica, plomería y electricidad.',
        onChanged: (_) => onChanged(),
      ),
    if (errCats != null)
      Row(
        spacing: 6,
        children: [
          Icon(Icons.close, size: 16, color: kc(c).red),
          Expanded(
            child: T(errCats, size: 14, w: FontWeight.w800, color: kc(c).red),
          ),
        ],
      ),
  ], gap: 8);
}

class Servicio {
  Servicio(String n, String p)
    : n = TextEditingController(text: n),
      p = TextEditingController(text: p);
  final TextEditingController n, p;
  void dispose() {
    n.dispose();
    p.dispose();
  }
}

Widget serviciosEditor(
  BuildContext c,
  List<Servicio> svcs,
  Map<String, String> err,
  VoidCallback onChanged,
  VoidCallback onAdd,
  void Function(int) onDel,
) {
  final k = kc(c);
  return stack([
    for (var i = 0; i < svcs.length; i++)
      Container(
        padding: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: k.line2)),
        ),
        child: stack([
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: FieldK(
                  label: '',
                  c: svcs[i].n,
                  hint: 'Ej.: Cambio de llave',
                  onChanged: (_) => onChanged(),
                ),
              ),
              IconButton(
                onPressed: () => onDel(i),
                icon: Icon(icn('trash'), size: 20),
                tooltip: tr('Quitar servicio'),
              ),
            ],
          ),
          Row(
            spacing: 8,
            children: [
              bT('Desde \$'),
              Expanded(
                child: FieldK(
                  label: '',
                  c: svcs[i].p,
                  hint: '250',
                  keyboard: TextInputType.number,
                  maxLen: 6,
                  onChanged: (_) => onChanged(),
                ),
              ),
            ],
          ),
          if (err['s$i'] != null)
            Row(
              spacing: 6,
              children: [
                Icon(Icons.close, size: 16, color: k.red),
                Expanded(
                  child: T(
                    err['s$i']!,
                    size: 14,
                    w: FontWeight.w800,
                    color: k.red,
                  ),
                ),
              ],
            ),
        ], gap: 8),
      ),
    BtnK('Agregar servicio', onAdd, kind: Bk.ghost, sm: true, icon: 'plus'),
  ], gap: 12);
}

final _nameRx = RegExp(r"^[A-Za-zÁÉÍÓÚÜÑáéíóúüñ' .-]+$");
String clean(String s) => s.trim().replaceAll(RegExp(r'\s+'), ' ');

void advErrors(
  Map<String, String> e,
  String years,
  String about,
  List<Servicio> svcs,
) {
  if (years.isNotEmpty &&
      !(RegExp(r'^\d{1,2}$').hasMatch(years) && int.parse(years) <= 60)) {
    e['years'] = 'Escribe un número de años entre 0 y 60';
  }
  if (about.length > 300) e['about'] = 'Máximo 300 caracteres';
  for (var i = 0; i < svcs.length; i++) {
    final nm = svcs[i].n.text.trim(), pr = svcs[i].p.text.trim();
    if (nm.isEmpty && pr.isEmpty) continue;
    if (nm.isEmpty) {
      e['s$i'] = 'Escribe el nombre del servicio';
    } else if (!RegExp(r'^\$?\s*\d{2,6}$').hasMatch(pr)) {
      e['s$i'] = 'Escribe un precio válido (solo números)';
    }
  }
}

// ------------------------------------------------------------ registro del técnico

class TecRegistroScreen extends ConsumerStatefulWidget {
  const TecRegistroScreen({super.key});
  @override
  ConsumerState<TecRegistroScreen> createState() => _TecRegistroState();
}

class _TecRegistroState extends ConsumerState<TecRegistroScreen> {
  String step = 'form'; // form | code | ok
  bool tried = false, sending = false, failOnce = false;
  String serverErr = '', codeErr = '';
  int tries = 0;
  final name = TextEditingController(),
      phone = TextEditingController(),
      other = TextEditingController(),
      address = TextEditingController();
  final business = TextEditingController(),
      years = TextEditingController(),
      about = TextEditingController(),
      code = TextEditingController();
  final sel = <String>{};
  bool otherOn = false, terms = false;
  String how = 'dom', km = '8 km';
  final svcs = <Servicio>[];

  @override
  void initState() {
    super.initState();
    name.text = maq.user.name;
    phone.text = maq.user.phone;
  }

  @override
  void dispose() {
    for (final c in [
      name,
      phone,
      other,
      address,
      business,
      years,
      about,
      code,
    ]) {
      c.dispose();
    }
    for (final s in svcs) {
      s.dispose();
    }
    super.dispose();
  }

  /// Con sesión y API, el perfil de técnico se crea en el servidor: la cuenta
  /// ya está verificada por SMS, así que no hay un segundo código, y no se
  /// piden el celular ni los servicios (esta ruta no los recibe).
  bool get _real => ref.read(solicitudesRealesActivasProvider);

  Map<String, String> _errors() {
    final e = <String, String>{};
    final n = clean(name.text);
    if (n.length < 3) {
      e['name'] = 'Escribe tu nombre completo';
    } else if (!_nameRx.hasMatch(n)) {
      e['name'] = 'Usa solo letras en tu nombre';
    } else if (n.split(' ').length < 2) {
      e['name'] = 'Escribe también tu apellido';
    }
    if (!_real && digits(phone.text).length != 10) {
      e['phone'] = 'Escribe los 10 números de tu celular';
    }
    final ot = otherOn && other.text.trim().length >= 3;
    if (otherOn && !ot) e['other'] = 'Escribe cuál es tu oficio';
    if (sel.isEmpty && (_real || !ot)) {
      // El servidor exige al menos un oficio del catálogo.
      e['cats'] = 'Elige al menos un servicio';
    }
    advErrors(e, years.text.trim(), about.text, svcs);
    if (how == 'taller' && address.text.trim().length < 8) {
      e['address'] = 'Escribe calle, número y colonia';
    }
    if (!terms) {
      e['terms'] =
          'Para continuar, acepta los términos y el aviso de privacidad';
    }
    return e;
  }

  Future<void> _submit() async {
    setState(() {
      tried = true;
      serverErr = '';
    });
    if (_errors().isNotEmpty || sending) return;
    if (_real) {
      await _createReal();
      return;
    }
    final d = digits(phone.text);
    setState(() => sending = true);
    // Errores de demostración de la maqueta (siempre, con o sin sesión).
    if (d == '7710000000' || (d == '7719999999' && !failOnce)) {
      await Future<void>.delayed(const Duration(milliseconds: 900));
      if (!mounted) return;
      setState(() {
        sending = false;
        if (d == '7710000000') {
          serverErr =
              'Este número ya tiene una cuenta de técnico. Usa otro número.';
        } else {
          failOnce = true;
          serverErr = 'No pudimos enviar el código por SMS. Revisa tu conexión e intenta de nuevo.';
        }
      });
      return;
    }
    if (hayCuenta(context)) {
      await Future<void>.delayed(const Duration(milliseconds: 900));
      if (!mounted) return;
      setState(() {
        sending = false;
        step = 'code';
        code.clear();
        codeErr = '';
        tries = 0;
      });
      return;
    }
    final ok = await ref
        .read(entradaControllerProvider.notifier)
        .enviarCodigo(d);
    if (!mounted) return;
    setState(() {
      sending = false;
      if (ok) {
        step = 'code';
        code.clear();
        codeErr = '';
        tries = 0;
      } else {
        serverErr = 'No pudimos enviar el código por SMS. Revisa tu conexión e intenta de nuevo.';
      }
    });
  }

  Future<void> _verify() async {
    final c = digits(code.text);
    if (c.length != 6) return;
    if (tries >= 3) {
      setState(() => codeErr = 'Demasiados intentos. Pide un código nuevo.');
      return;
    }
    if (c == '000000') {
      setState(() {
        tries++;
        codeErr = tries >= 3
            ? 'Demasiados intentos. Pide un código nuevo.'
            : 'Código incorrecto. Te quedan ${3 - tries} intentos.';
      });
      return;
    }
    if (!hayCuenta(context)) {
      final r = await ref.read(entradaControllerProvider.notifier).verificar(c);
      if (!mounted) return;
      if (r == null) {
        setState(() {
          tries++;
          codeErr = 'Código incorrecto. Revisa el SMS e inténtalo de nuevo.';
        });
        return;
      }
    }
    await _create();
  }

  Future<void> _create() async {
    maq.user.phone = fmtPhone(phone.text);
    pv.register(
      name: name.text,
      business: business.text,
      phone: fmtPhone(phone.text),
      cats0: sel,
      otherOn: otherOn,
      other: other.text,
      how: how,
      km: km,
      address: address.text,
      about: about.text,
      years: years.text,
      svcs: [
        for (final s in svcs)
          if (s.n.text.trim().isNotEmpty)
            [s.n.text.trim(), '', '\$${digits(s.p.text)}'],
      ],
    );
    ref.read(esTecnicoProvider.notifier).cambiar(esTecnico: true);
    final err = await ref
        .read(perfilControllerProvider.notifier)
        .guardarNombre(clean(name.text));
    if (err == null) {
      maq.user.name = clean(name.text);
      maq.user.first = maq.user.name.split(' ').first;
    }
    if (!mounted) return;
    setState(() {
      step = 'ok';
    });
  }

  Future<void> _createReal() async {
    final textos = AppLocalizations.of(context);
    setState(() => sending = true);
    try {
      final coloniaId = await coloniaIdDeLaPersona(ref, maq.user);
      final taller = how == 'taller';
      final creado = await ref
          .read(tecnicoRepositoryProvider)
          .registrar(
            AltaTecnico(
              nombre: clean(name.text),
              oficios: [...sel],
              otroOficio: otherOn ? other.text : null,
              atencion: taller ? Atencion.taller : Atencion.domicilio,
              direccionTaller: taller ? address.text : null,
              radioKm: taller ? null : int.parse(km.split(' ').first),
              coloniaId: coloniaId,
              nombreNegocio: business.text,
              descripcion: about.text,
              anios: int.tryParse(years.text.trim()),
              aceptaTerminos: terms,
            ),
          );
      // Es la única vez que la app recibe su id de técnico (spec 037).
      if (mounted) ref.read(miTecnicoIdProvider.notifier).recordar(creado.id);
    } on Failure catch (falla) {
      if (!mounted) return;
      setState(() {
        sending = false;
        serverErr = falla is ConflictoFailure
            ? 'Esta cuenta ya tiene perfil de técnico.'
            : mensajeDeError(textos, falla);
      });
      return;
    }
    if (!mounted) return;
    if (otherOn) {
      unawaited(
        pedirOficioNuevo(
          ref.read(detalleOficioRepositoryProvider),
          textos,
          clean(other.text),
        ),
      );
    }
    setState(() => sending = false);
    await _create();
    // El perfil de la cuenta ya dice que es técnica.
    ref.invalidate(perfilControllerProvider);
  }

  void _enter(String? to) {
    if (to != null) {
      context.go('/trabajo');
      unawaited(context.push(to));
    } else {
      context.go('/trabajo');
    }
  }

  @override
  Widget build(BuildContext context) {
    final k = kc(context);
    final real = ref.watch(solicitudesRealesActivasProvider);
    final yaEsTecnico = real && ref.watch(esTecnicoProvider);
    if ((pv.me.registered || yaEsTecnico) && step != 'ok') {
      return Pg(
        title: 'Ofrece tus servicios',
        scroll: false,
        body: stateK(
          Icons.check,
          k.greenSoft,
          k.green,
          'Ya tienes cuenta de técnico',
          [
            rich(
              'Entraste como **${pv.me.registered ? pv.me.name : maq.user.name}**.',
              w: FontWeight.w400,
            ),
          ],
        ),
        cta: BtnK('Ir a mi inicio de técnico', () => context.go('/trabajo')),
      );
    }
    if (step == 'code') {
      final ok = digits(code.text).length == 6;
      return Pg(
        title: 'Verifica tu celular',
        back: false,
        body: stack([
          stack([
            h1('Verifica tu celular'),
            rich(
              'Mandamos un código de 6 números por SMS al **+52 ${fmtPhone(phone.text)}**.',
              w: FontWeight.w400,
            ),
          ], gap: 8),
          FieldK(
            label: 'Código de 6 números',
            c: code,
            hint: '••••••',
            keyboard: TextInputType.number,
            maxLen: 6,
            center: true,
            err: codeErr.isEmpty ? null : codeErr,
            help: 'En esta demostración sirve cualquier código de 6 números. El 000000 simula un código incorrecto.',
            onChanged: (_) => setState(() {}),
            onSubmit: (_) => _verify(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LinkK(
                'Cambiar número',
                () => setState(() {
                  step = 'form';
                  serverErr = '';
                }),
              ),
              LinkK('Reenviar código', () {
                code.clear();
                setState(() {
                  codeErr = '';
                  tries = 0;
                });
                maq.toast('Te mandamos un código nuevo');
              }),
            ],
          ),
        ], gap: 18),
        cta: BtnK('Crear mi cuenta', ok ? _verify : null),
      );
    }
    if (step == 'ok') {
      return Pg(
        noHeader: true,
        body: stack([
          Column(
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
              h1('¡Cuenta creada, ${pv.first}!', a: TextAlign.center),
              mutT(
                'Ya puedes ver las solicitudes de tu zona y chatear con los clientes.',
                a: TextAlign.center,
              ),
            ],
          ),
          CardK(
            child: Row(
              spacing: 14,
              children: [
                Av(
                  ini: initials(pv.me.name),
                  color: const Color(0xFF2A5568),
                  size: 56,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      bT(pv.me.name),
                      sMut(pv.summary),
                      sMut('+52 ${pv.me.phone}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (real) const CardK(child: MisServiciosReales()),
          const NoteK(
            'blue',
            'shield',
            '**Verificar tu identidad es opcional.** Con INE y selfie obtienes una insignia verde que da confianza a los clientes. Puedes hacerlo cuando quieras desde tu Perfil; mientras, tu cuenta aparece como «Sin verificar».',
          ),
        ], gap: 18),
        cta: ctaCol([
          BtnK('Ver solicitudes cercanas', () => _enter(null)),
          BtnK('Completar mi perfil', () => _enter(RT.perfil), kind: Bk.ghost),
        ]),
      );
    }
    final E = tried ? _errors() : <String, String>{};
    final taller = how == 'taller';
    return Pg(
      title: 'Ofrece tus servicios',
      body: stack([
        stack([
          h1('Crea tu cuenta de técnico'),
          mutT(
            'Son 2 minutos. No pedimos documentos: verificarte con INE es opcional y se hace después.',
          ),
        ], gap: 8),
        if (serverErr.isNotEmpty) NoteK('red', 'help', '**$serverErr**'),
        FieldK(
          label: 'Tu nombre completo',
          c: name,
          hint: 'Ej.: Ricardo Mendoza Pérez',
          err: E['name'],
          onChanged: (_) => setState(() {}),
        ),
        if (!real)
          FieldK(
            label: 'Tu celular',
            c: phone,
            hint: '771 555 0142',
            keyboard: TextInputType.number,
            maxLen: 12,
            prefix: const PhoneCc(),
            err: E['phone'],
            help: 'Te mandaremos un código por SMS para confirmar que es tuyo.',
            onChanged: (_) => setState(() {}),
            onSubmit: (_) => _submit(),
          ),
        tradesBlock(
          context,
          sel: sel,
          otherOn: otherOn,
          other: other,
          errCats: E['cats'],
          errOther: E['other'],
          toggle: (c) =>
              setState(() => sel.contains(c) ? sel.remove(c) : sel.add(c)),
          toggleOther: () => setState(() => otherOn = !otherOn),
          onChanged: () => setState(() {}),
        ),
        FoldK(
          k: 'reg-adv',
          title: 'Personalizar mi perfil',
          summary: 'Opcional · negocio, descripción y servicios',
          icon: 'edit',
          open0:
              tried &&
              (E.containsKey('years') ||
                  E.containsKey('about') ||
                  E.keys.any((x) => RegExp(r'^s\d').hasMatch(x))),
          child: stack([
            FieldK(
              label: 'Nombre de tu negocio',
              opt: true,
              c: business,
              hint: 'Ej.: Plomería Mendoza',
            ),
            FieldK(
              label: 'Años de experiencia',
              opt: true,
              c: years,
              hint: 'Ej.: 8',
              keyboard: TextInputType.number,
              maxLen: 2,
              err: E['years'],
              onChanged: (_) => setState(() {}),
            ),
            FieldK(
              label: 'Cómo te presentas',
              opt: true,
              c: about,
              lines: 4,
              maxLen: 320,
              hint:
                  'Cuéntales a los clientes qué haces y por qué confiar en ti.',
              err: E['about'],
              help: '${about.text.length}/300',
              onChanged: (_) => setState(() {}),
            ),
            if (!real) ...[
              Row(
                spacing: 6,
                children: [
                  labT('Tus servicios y precio de referencia'),
                  T('(opcional)', size: 15, w: FontWeight.w700, color: k.mut),
                ],
              ),
              serviciosEditor(
                context,
                svcs,
                E,
                () => setState(() {}),
                () => setState(() => svcs.add(Servicio('', ''))),
                (i) => setState(() => svcs.removeAt(i).dispose()),
              ),
            ],
            sMut(
              'Fotos, horarios y más detalles los ajustas después en Perfil > Mi perfil público.',
            ),
          ], gap: 16),
        ),
        stack([
          labT('¿Cómo atiendes?'),
          ChoiceK(
            on: taller,
            onTap: () => setState(() => how = 'taller'),
            title: 'En mi taller o local',
            sub: 'Los clientes van contigo',
            leading: Icon(icn('store')),
          ),
          ChoiceK(
            on: !taller,
            onTap: () => setState(() => how = 'dom'),
            title: 'A domicilio',
            sub: 'Tú vas con el cliente',
            leading: Icon(icn('house')),
          ),
        ], gap: 8),
        if (taller)
          FieldK(
            label: 'Dirección del taller',
            c: address,
            hint: 'Calle, número y colonia',
            err: E['address'],
            help: 'Será pública y aparecerá en el mapa de tu perfil.',
            onChanged: (_) => setState(() {}),
          )
        else
          stack([
            labT('¿Hasta dónde vas?'),
            chipsWrap([
              for (final x in const ['3 km', '5 km', '8 km', '12 km'])
                ChipK(x, on: km == x, onTap: () => setState(() => km = x)),
            ]),
            const NoteK(
              'green',
              'lock',
              'Tu domicilio no se muestra a los clientes. Solo ven hasta dónde llegas.',
            ),
          ], gap: 8),
        stack([
          ChoiceK(
            on: terms,
            check: true,
            onTap: () => setState(() => terms = !terms),
            title: 'Acepto los Términos y el Aviso de privacidad de Knock.',
          ),
          Row(
            spacing: 16,
            children: [
              InkWell(
                onTap: () => context.push(RM.terminos),
                child: T(
                  'Leer los términos',
                  size: 14,
                  w: FontWeight.w800,
                  color: k.navy,
                ),
              ),
              InkWell(
                onTap: () => context.push(RM.aviso),
                child: T(
                  'Aviso de privacidad',
                  size: 14,
                  w: FontWeight.w800,
                  color: k.navy,
                ),
              ),
            ],
          ),
          if (E['terms'] != null)
            Row(
              spacing: 6,
              children: [
                Icon(Icons.close, size: 16, color: k.red),
                Expanded(
                  child: T(
                    E['terms']!,
                    size: 14,
                    w: FontWeight.w800,
                    color: k.red,
                  ),
                ),
              ],
            ),
        ], gap: 8),
      ], gap: 20),
      cta: ctaCol([
        BtnK(
          sending
              ? (real ? 'Creando cuenta…' : 'Enviando código…')
              : 'Continuar',
          sending ? null : _submit,
        ),
        if (tried && E.isNotEmpty) helpT('Revisa los campos marcados en rojo'),
      ]),
    );
  }
}

// ------------------------------------------------------------ verificación (opcional)

void openVerifSheet(BuildContext context, String why, void Function() cont) {
  pv.after = (why: why, cont: cont);
  unawaited(
    hoja<void>(
      context,
      (ctx, _) => stack([
        sheetH(ctx, '¿Quieres verificar tu identidad?', big: true),
        rich(
          'Es **opcional**. Puedes $why sin verificarte. Con la verificación, tu perfil muestra una insignia verde y a los clientes les da más confianza elegirte.',
          w: FontWeight.w400,
        ),
        const NoteK(
          'blue',
          'clock',
          'Tarda unos minutos y puedes hacerlo cuando quieras desde Perfil > Verificación de identidad.',
        ),
        BtnK('Verificarme ahora', () {
          Navigator.pop(ctx);
          unawaited(context.push(RT.verif));
        }, icon: 'shield'),
        BtnK('Seguir sin verificar', () {
          Navigator.pop(ctx);
          pv.verifSkip();
        }, kind: Bk.ghost),
      ]),
    ),
  );
}

/// `true` si ofreció la verificación y la acción debe esperar.
bool needVerif(BuildContext context, String why, void Function() cont) {
  if (pv.verified || pv.status == 'pendiente' || pv.status == 'revision') {
    return false;
  }
  if (pv.skip[why] ?? false) return false;
  openVerifSheet(context, why, cont);
  return true;
}

void openVerif(BuildContext context) {
  // Con servidor el estado lo dice el servidor (spec 018).
  if (ProviderScope.containerOf(
    context,
    listen: false,
  ).read(solicitudesRealesActivasProvider)) {
    unawaited(context.push(RT.verif));
    return;
  }
  switch (pv.status) {
    case 'verificado':
      unawaited(context.push(RT.verificado));
    case 'pendiente' || 'revision':
      unawaited(context.push(RT.pendiente));
    case 'rechazado':
      unawaited(context.push(RT.rechazada));
    default:
      unawaited(context.push(RT.verif));
  }
}

Widget privacyCard(BuildContext c) {
  final k = kc(c);
  const pts = [
    ('check', 'Para qué', 'Solo para confirmar que eres tú. Nada más.'),
    (
      'lock',
      'Cómo guardamos tus fotos',
      'Se guardan cifradas con una llave propia y las borramos en cuanto una persona del equipo termina de revisarlas (máximo 7 días).',
    ),
    (
      'eye',
      'Quién las ve',
      'Solo personal autorizado, y queda registro de quién las vio. Los clientes nunca ven tu INE: solo la insignia verde.',
    ),
    (
      'shield',
      'Lo que queda después',
      'Solo el resultado, la fecha, quién lo decidió y un código (hash) de tu CURP para evitar cuentas duplicadas. Nunca tu CURP ni tus fotos.',
    ),
    (
      'edit',
      'Tú decides',
      'Puedes pedir que borremos tu verificación y tus fotos cuando quieras.',
    ),
  ];
  return CardK(
    child: stack([
      h3('Cómo cuidamos tus datos'),
      for (final x in pts)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: k.greenSoft,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icn(x.$1), size: 18, color: k.green),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [bT(x.$2), sMut(x.$3)],
              ),
            ),
          ],
        ),
      FoldK(
        k: 'pv-aviso',
        title: 'Vista previa del aviso de privacidad',
        summary: 'Lo que dice la parte de verificación',
        icon: 'doc',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            for (final s in const [
              (
                'Datos que se usan',
                'Foto de tu credencial (INE) por ambos lados y una selfie.',
              ),
              (
                'Datos biométricos y consentimiento',
                'La selfie con prueba de vida es un dato biométrico. Solo la tratamos para verificar tu identidad y solo con tu consentimiento expreso, que puedes retirar cuando quieras.',
              ),
              (
                'Conservación y acceso',
                'Las fotos se guardan cifradas y se borran en cuanto se decide tu verificación, o a los 7 días como máximo si nadie las revisó. Solo las ve personal autorizado y cada acceso queda registrado. Después solo queda el resultado, la fecha, quién decidió y un código (hash) de tu CURP.',
              ),
              (
                'Con quién se comparten',
                'Con autoridades cuando la ley lo exija y, en el futuro, con un servicio que valide identidades. Nunca vendemos tus datos.',
              ),
              (
                'Tus derechos ARCO',
                'Puedes acceder, corregir, cancelar u oponerte al uso de tus datos desde Perfil o escribiendo al correo de contacto.',
              ),
            ]) ...[T(s.$1, size: 16, w: FontWeight.w900), T(s.$2, size: 15)],
            LinkK(
              'Leer el aviso de privacidad completo',
              () => c.push(RM.aviso),
            ),
          ],
        ),
      ),
    ], gap: 12),
  );
}

class VerifScreen extends StatefulWidget {
  const VerifScreen({super.key});
  @override
  State<VerifScreen> createState() => _VerifState();
}

class _VerifState extends State<VerifScreen> {
  final img = <String, String>{};
  final err = <String, String>{};
  String? busy;

  Future<void> _cap(String k) async {
    final f = await elegirFotos(varias: false);
    if (f.isEmpty) return;
    setState(() => busy = k);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() {
      busy = null;
      img[k] = f.first;
      err.remove(k);
    });
  }

  Widget _cap0(
    BuildContext c,
    String k,
    int n,
    String title,
    String desc,
    String icon, {
    bool opt = false,
  }) {
    final kk = kc(c);
    final im = img[k];
    final er = err[k];
    return CardK(
      outline: im != null
          ? kk.green
          : er != null
          ? kk.red
          : null,
      child: stack([
        Row(
          spacing: 14,
          children: [
            im != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: 72,
                      height: 52,
                      child: PhotoTile(path: im, size: 72),
                    ),
                  )
                : Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: kk.navySoft,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icn(icon), color: kk.navy),
                  ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 6,
                    children: [
                      bT('$n. $title'),
                      if (opt)
                        T('(recomendado)', w: FontWeight.w700, color: kk.mut),
                    ],
                  ),
                  sMut(
                    busy == k
                        ? 'Revisando la foto…'
                        : im != null
                        ? 'Foto lista'
                        : desc,
                  ),
                ],
              ),
            ),
            if (busy == k)
              const CargaK(tipo: TipoCarga.foto, size: 56)
            else
              BtnK(
                im != null ? 'Repetir' : 'Tomar',
                () => _cap(k),
                kind: Bk.sec,
                sm: true,
                auto: true,
                icon: 'camera',
              ),
          ],
        ),
        if (er != null)
          Row(
            spacing: 6,
            children: [
              Icon(Icons.close, size: 16, color: kk.red),
              Expanded(
                child: T(er, size: 14, w: FontWeight.w800, color: kk.red),
              ),
            ],
          ),
      ], gap: 10),
    );
  }

  @override
  Widget build(BuildContext context) => MaqBuilder((context) {
    final k = kc(context);
    final up = pv.upgrade;
    final need = up ? img['b'] != null : (img['f'] != null && img['s'] != null);
    final ok = need && pv.consent;
    final help = !need
        ? (up
              ? 'Toma el reverso del INE para continuar'
              : 'Toma el frente del INE y la selfie para continuar')
        : !pv.consent
        ? 'Marca la casilla de consentimiento para continuar'
        : '';
    return Pg(
      title: 'Verificación',
      body: stack([
        stack([
          h1(up ? 'Completa tu verificación' : 'Verifica tu identidad'),
          mutT(
            up
                ? 'Agrega el reverso de tu INE para validar tus datos con el INE y subir de nivel.'
                : 'Así los clientes saben que eres quien dices ser y te eligen con más confianza.',
          ),
        ], gap: 8),
        if (pv.vExpired)
          const NoteK(
            'amber',
            'flag',
            '**Tus fotos anteriores se borraron sin revisarse** (pasaron 7 días). Tu estado volvió a «Sin verificar»; puedes volver a enviarlas.',
          ),
        const NoteK(
          'blue',
          'clock',
          'Es opcional y solo se hace una vez. Si prefieres, puedes dejarlo para después.',
        ),
        privacyCard(context),
        if (up)
          _cap0(
            context,
            'b',
            1,
            'INE por atrás',
            'Que se vea el código de barras y el QR',
            'idcard',
          )
        else ...[
          _cap0(
            context,
            'f',
            1,
            'INE por el frente',
            'Con buena luz, sin reflejos y en horizontal',
            'idcard',
          ),
          _cap0(
            context,
            'b',
            2,
            'INE por atrás',
            'Con el QR y el código de barras',
            'idcard',
            opt: true,
          ),
          _cap0(
            context,
            's',
            3,
            'Selfie',
            'De frente, con buena luz y sin lentes ni gorra',
            'selfie',
          ),
          rich(
            'Con **frente y selfie** tu verificación es **básica**. Si agregas el **reverso**, validamos tus datos con el INE y tu verificación es **completa**.',
            size: 14,
            color: k.mut,
          ),
        ],
        ChoiceK(
          on: pv.consent,
          check: true,
          onTap: () {
            pv.consent = !pv.consent;
            maq.refresh();
          },
          title: '',
          body: rich(
            '**Doy mi consentimiento** para que Knock guarde cifradas mi INE y mi selfie hasta que una persona autorizada del equipo las revise (máximo 7 días) y las use solo para verificar mi identidad, como se explica arriba.',
            size: 15,
            w: FontWeight.w700,
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: LinkK(
            'Leer el aviso de privacidad',
            () => context.push(RM.aviso),
          ),
        ),
        sMut(
          'Demostración: según los últimos dos dígitos de tu celular verás distintos resultados (71 INE vencido, 72 la cara no coincide, 73 revisión manual, 74 nadie revisa y vencen las fotos; otros, aprobado).',
        ),
      ], gap: 16),
      cta: ctaCol([
        BtnK(
          'Enviar a revisión',
          ok
              ? () {
                  pv.targetLevel = (img['b'] != null || up)
                      ? 'completo'
                      : 'basico';
                  pv.verifSend(
                    pv.me.phone.isNotEmpty ? pv.me.phone : maq.user.phone,
                  );
                  img.clear();
                  context.pushReplacement(RT.pendiente);
                }
              : null,
        ),
        BtnK('Ahora no', () => context.pop(), kind: Bk.ghost),
        if (help.isNotEmpty) helpT(help),
      ]),
    );
  });
}

class PendienteScreen extends StatefulWidget {
  const PendienteScreen({super.key});
  @override
  State<PendienteScreen> createState() => _PendienteState();
}

class _PendienteState extends State<PendienteScreen> {
  @override
  void initState() {
    super.initState();
    pendienteAbierta = true;
  }

  @override
  void dispose() {
    pendienteAbierta = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaqBuilder((context) {
    final k = kc(context);
    final el = DateTime.now().millisecondsSinceEpoch - pv.verifAt;
    final man = pv.status == 'revision';
    final comp = pv.targetLevel == 'completo';
    final steps = [
      ('Fotos recibidas', 0),
      ('Leyendo tu INE', 1200),
      ('Comparando tu rostro con tu INE', 2800),
      if (comp) ('Validando tus datos con el INE', 4400),
    ];
    final rows = [
      for (final s in steps)
        (
          man || el >= s.$2 + 1300
              ? 'done'
              : el >= s.$2
              ? 'now'
              : '',
          s.$1,
        ),
      if (man) ('now', 'Un asesor revisa tu caso'),
    ];
    final af = pv.after;
    return Pg(
      title: 'Verificación',
      back: false,
      body: stack([
        Column(
          spacing: 14,
          children: [
            CargaK(
              tipo: man ? TipoCarga.buscando : TipoCarga.escudo,
              size: 140,
            ),
            if (!man)
              const MensajesRotativos([
                'Revisando tus documentos…',
                'Comparando tu rostro…',
                'Ya casi…',
              ]),
            h1(
              man
                  ? 'Un asesor está revisando tu caso'
                  : 'Estamos revisando tus documentos',
              a: TextAlign.center,
            ),
            mutT(
              man
                  ? 'Pasó a revisión manual para estar seguros. Normalmente tarda hasta 24 horas y te avisamos aquí y por SMS. Si pasan 7 días sin revisarse, borramos tus fotos y podrás volver a enviarlas. Mientras, puedes seguir usando Knock.'
                  : (af != null
                        ? 'Cuando termine, podrás ${af.why}. Te avisamos aquí mismo.'
                        : 'Normalmente tarda menos de 24 horas. Te avisamos por SMS.'),
              a: TextAlign.center,
            ),
          ],
        ),
        CardK(
          child: Column(
            children: [
              for (var i = 0; i < rows.length; i++)
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 14,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: rows[i].$1 == 'done'
                                  ? k.green
                                  : rows[i].$1 == 'now'
                                  ? k.amber
                                  : k.line2,
                              shape: BoxShape.circle,
                            ),
                            child: rows[i].$1 == 'done'
                                ? const Icon(
                                    Icons.check,
                                    size: 18,
                                    color: Colors.white,
                                  )
                                : rows[i].$1 == 'now'
                                ? const Icon(
                                    Icons.schedule,
                                    size: 18,
                                    color: Color(0xFF231A15),
                                  )
                                : null,
                          ),
                          if (i < rows.length - 1)
                            Expanded(
                              child: Container(width: 2, color: k.line2),
                            ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 5,
                            bottom: i < rows.length - 1 ? 18 : 0,
                          ),
                          child: bT(rows[i].$2),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const NoteK(
          'green',
          'lock',
          'Ya borramos las fotos de este dispositivo. Las copias cifradas de nuestros servidores se borran en cuanto una persona del equipo termine de revisarlas (máximo 7 días); después solo queda el resultado.',
        ),
        sMut(
          'En esta demostración la revisión tarda unos segundos.',
          a: TextAlign.center,
        ),
      ], gap: 16),
      cta: ctaCol([
        BtnK(
          'Mientras, arma tu perfil',
          () => context.push(RT.perfil),
          kind: Bk.sec,
        ),
        BtnK(
          'Seguir viendo solicitudes',
          () => context.go('/trabajo'),
          kind: Bk.ghost,
        ),
      ]),
    );
  });
}

class VerificadoScreen extends StatelessWidget {
  const VerificadoScreen({super.key});
  @override
  Widget build(BuildContext context) => MaqBuilder((context) {
    final k = kc(context);
    final comp = pv.level == 'completo';
    final af = pv.after;
    return Pg(
      noHeader: true,
      body: Column(
        spacing: 14,
        children: [
          const SizedBox(height: 24),
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: k.greenSoft,
              shape: BoxShape.circle,
            ),
            child: Icon(icn('shield'), size: 52, color: k.green),
          ),
          h1('¡Listo, ${pv.first}! Ya estás verificado', a: TextAlign.center),
          mutT(
            'La insignia verde ya aparece en tu perfil. Desde hoy te llegan solicitudes de tu zona.',
            a: TextAlign.center,
          ),
          CardK(
            child: Row(
              spacing: 14,
              children: [
                Av(
                  ini: initials(pv.me.name),
                  color: const Color(0xFF2A5568),
                  size: 56,
                  verified: true,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      bT(pv.me.name),
                      sMut(pv.summary),
                      T(
                        comp
                            ? 'Verificación completa · validada con el INE'
                            : 'Verificación básica',
                        size: 14,
                        w: FontWeight.w800,
                        color: k.greenInk,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!comp)
            CardK(
              child: stack([
                bT('¿Quieres subir de nivel?'),
                sMut(
                  'Agrega el reverso de tu INE y validamos tus datos con el INE. Es opcional.',
                ),
                BtnK(
                  'Agregar el reverso del INE',
                  () {
                    pv.upgrade = true;
                    unawaited(context.push(RT.verif));
                  },
                  kind: Bk.sec,
                  sm: true,
                  icon: 'idcard',
                ),
              ], gap: 8),
            ),
        ],
      ),
      cta: BtnK(af != null ? 'Continuar' : 'Empezar', () {
        final a = pv.after;
        pv.after = null;
        if (a != null && a.why == 'empezar a recibir trabajos') pv.avail = true;
        context.go('/trabajo');
        if (a != null) a.cont();
      }),
    );
  });
}

class RechazadaScreen extends StatelessWidget {
  const RechazadaScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final k = kc(context);
    const R = {
      'vencido': (
        'No pudimos verificar tu INE',
        'Tu credencial aparece como vencida. Necesitamos un INE vigente.',
        [
          'Usa un INE vigente (revisa la fecha de vigencia en el frente).',
          'Si ya renovaste tu credencial, usa la nueva.',
        ],
      ),
      'cara': (
        'Tu selfie no coincide con el INE',
        'No pudimos confirmar que la persona de la selfie sea la del INE.',
        [
          'Tómala de frente, con buena luz y sin lentes, gorra ni cubrebocas.',
          'Verifica que el INE sea tuyo y se vea bien la foto.',
        ],
      ),
    };
    final r =
        R[pv.vReason] ??
        (
          'No pudimos verificarte',
          'Algo no salió bien con la revisión.',
          ['Vuelve a tomar las fotos con buena luz.'],
        );
    return Pg(
      title: 'Verificación',
      back: false,
      body: stack([
        Column(
          spacing: 14,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: k.redSoft,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, size: 52, color: k.red),
            ),
            h1(r.$1, a: TextAlign.center),
            mutT(r.$2, a: TextAlign.center),
          ],
        ),
        CardK(
          child: stack([
            bT('Para intentarlo de nuevo'),
            for (final x in r.$3)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  const Text('•'),
                  Expanded(child: sMut(x, color: k.ink)),
                ],
              ),
          ], gap: 8),
        ),
        const NoteK(
          'blue',
          'shield',
          'Puedes seguir usando Knock sin verificarte; tu cuenta aparece como «Sin verificar». Ya borramos tus fotos: se eliminan en cuanto se decide la revisión.',
        ),
      ], gap: 16),
      cta: ctaCol([
        BtnK('Intentar de nuevo', () {
          pv.status = 'nuevo';
          pv.vReason = '';
          maq.refresh();
          context.pushReplacement(RT.verif);
        }),
        BtnK('Seguir sin verificar', () {
          pv.status = 'nuevo';
          pv.vReason = '';
          pv.after = null;
          maq.refresh();
          context.go('/trabajo');
        }, kind: Bk.ghost),
      ]),
    );
  }
}

// ------------------------------------------------------------ Trabajo

Widget _secH(String title, int n, Widget child) => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  spacing: 12,
  children: [h2('$title${n > 0 ? ' ($n)' : ''}'), child],
);

Widget visitCard(BuildContext context, Visita v) {
  final c = cliente(v.cid);
  final k = kc(context);
  return CardK(
    child: stack([
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          SizedBox(
            width: 64,
            child: Column(children: [h2(v.time), sMut(pv.dayLabel(v.d))]),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                T(v.titulo, size: 16.5, w: FontWeight.w800),
                sMut(c.n),
                sMut('${c.addr}, ${c.col}'),
                sMut(v.price),
              ],
            ),
          ),
        ],
      ),
      Row(
        spacing: 10,
        children: [
          Expanded(
            child: BtnK(
              'Cómo llegar',
              () => maq.toast('Abriendo el mapa con la ruta…'),
              kind: Bk.sec,
              sm: true,
              icon: 'pin',
            ),
          ),
          Expanded(
            child: BtnK('Ya llegué', () {
              if (needVerif(
                context,
                'empezar este trabajo',
                () => context.push(RT.iniciar(v.id)),
              )) {
                return;
              }
              unawaited(context.push(RT.iniciar(v.id)));
            }, sm: true),
          ),
        ],
      ),
      if (v.resched != null)
        Row(
          spacing: 4,
          children: [
            Icon(icn('clock'), size: 15, color: k.amberInk),
            Expanded(
              child: T(
                'Esperando que ${c.n.split(' ').first} confirme el cambio a ${v.resched!.txt}',
                size: 14,
                w: FontWeight.w800,
                color: k.amberInk,
              ),
            ),
          ],
        )
      else
        BtnK(
          'Reprogramar la visita',
          () => _reprogT(context, v),
          kind: Bk.ghost,
          sm: true,
          icon: 'cal',
        ),
      Row(
        spacing: 10,
        children: [
          Expanded(
            child: BtnK(
              'Cancelar la visita',
              () => _cancelT(context, v, false),
              kind: Bk.ghost,
              sm: true,
            ),
          ),
          Expanded(
            child: BtnK(
              'El cliente no estaba',
              () => _cancelT(context, v, true),
              kind: Bk.ghost,
              sm: true,
            ),
          ),
        ],
      ),
    ], gap: 12),
  );
}

void _reprogT(BuildContext context, Visita v) {
  var d = 1;
  var t = '10:00';
  final first = cliente(v.cid).n.split(' ').first;
  unawaited(
    hoja<void>(context, (ctx, set) {
      final days0 = days;
      final k = kc(ctx);
      return stack([
        sheetH(ctx, 'Reprogramar la visita'),
        sMut(
          'Propón un nuevo día y hora a $first. Tiene que aceptarlo; mientras tanto la visita actual sigue en pie.',
        ),
        stack([
          labT('Día'),
          Row(
            spacing: 6,
            children: [
              for (var i = 0; i < days0.length; i++)
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => set(() => d = i),
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 68),
                      decoration: BoxDecoration(
                        color: d == i ? k.navyBg : k.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: d == i ? k.navyBg : k.line,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 2,
                        children: [
                          T(
                            days0[i].$1,
                            size: 13,
                            w: FontWeight.w800,
                            color: d == i ? const Color(0xFFD5E3E8) : k.mut,
                          ),
                          T(
                            '${days0[i].$2}',
                            size: 20,
                            w: FontWeight.w900,
                            color: d == i ? Colors.white : k.ink,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ], gap: 8),
        stack([
          labT('Hora'),
          chipsWrap([
            for (final x in rsTimes)
              ChipK(x, on: t == x, onTap: () => set(() => t = x)),
          ]),
        ], gap: 8),
        BtnK('Enviar cambio', () {
          Navigator.pop(ctx);
          pv.reprogVisit(v.id, d, t);
        }),
      ]);
    }),
  );
}

void _cancelT(BuildContext context, Visita v, bool absent) {
  var why = '';
  final first = cliente(v.cid).n.split(' ').first;
  unawaited(
    hoja<void>(context, (ctx, set) {
      final late = v.d <= 1;
      final ok = absent || why.isNotEmpty;
      return stack([
        sheetH(ctx, absent ? '¿El cliente no estaba?' : '¿Cancelar la visita?'),
        if (absent)
          NoteK(
            'blue',
            'flag',
            'Avisa solo si llegaste a la hora y esperaste. Registramos la ausencia de **$first** y queda como evidencia si hay un reporte. No se te penaliza.',
          )
        else
          NoteK(
            late ? 'amber' : 'blue',
            late ? 'flag' : 'check',
            late
                ? '**La visita es en menos de 24 h.** Avisamos a $first de inmediato y queda como cancelación tardía en tu historial.'
                : '**Sin costo.** Faltan más de 24 h, así que $first solo recibe el aviso.',
          ),
        if (!absent)
          stack([
            labT('¿Por qué cancelas?'),
            chipsWrap([
              for (final x in const [
                'Tengo una emergencia',
                'No llego a tiempo',
                'Ya no puedo con este trabajo',
                'Otro motivo',
              ])
                ChipK(x, on: why == x, onTap: () => set(() => why = x)),
            ]),
          ], gap: 8),
        BtnK(
          absent ? 'Registrar ausencia' : 'Sí, cancelar',
          ok
              ? () {
                  Navigator.pop(ctx);
                  pv.cancelVisit(v.id, absent: absent);
                }
              : null,
          kind: Bk.danger,
        ),
        BtnK('Volver', () => Navigator.pop(ctx), kind: Bk.ghost),
      ]);
    }),
  );
}

Widget reqCard(BuildContext context, Req r) {
  final k = kc(context);
  final (lbl, kind) = switch (r.k) {
    'nuevas' => ('Nueva', 'amber'),
    'proceso' => ('Cotización enviada', 'navy'),
    'aceptada' => ('Aceptada', 'green'),
    _ => ('Terminada', 'green'),
  };
  return CardK(
    child: stack([
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Pill('$lbl${r.mine ? ' · tu solicitud (demo)' : ''}', kind: kind),
          sMut(r.hace),
        ],
      ),
      h3(r.titulo),
      T(r.desc),
      Row(
        spacing: 4,
        children: [
          Icon(icn('pin'), size: 15, color: k.mut),
          Expanded(child: sMut('${r.zona} · ${r.cuando}')),
        ],
      ),
      if (r.k == 'nuevas')
        Row(
          spacing: 10,
          children: [
            BtnK(
              'Descartar',
              () => pv.reject(r.id),
              kind: Bk.ghost,
              auto: true,
            ),
            Expanded(
              child: BtnK('Chatear y cotizar', () {
                pv.ensureThread(r);
                pv.unread[r.cid] = 0;
                unawaited(context.push(RT.chat(r.cid, r.id)));
              }, sm: true),
            ),
          ],
        )
      else
        T(r.nota, size: 14, w: FontWeight.w700, color: k.navy),
    ], gap: 10),
  );
}

Widget? workFab(BuildContext context) {
  // Con sesión y API manda el globo real de todas las pestañas.
  final real = ProviderScope.containerOf(context)
      .read(solicitudesRealesActivasProvider);
  if (real || pv.th.isEmpty) return null;
  final k = kc(context);
  final u = pv.unreadN;
  return Positioned(
    right: 16,
    bottom: 16,
    child: GestureDetector(
      onTap: () => context.push(RT.mensajes),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: k.navyBg,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x520F1E32),
                  blurRadius: 20,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.chat_bubble_outline,
              color: Colors.white,
              size: 26,
            ),
          ),
          if (u > 0)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                constraints: const BoxConstraints(minWidth: 22),
                height: 22,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: k.red,
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: k.surface, width: 2),
                ),
                child: Text(
                  '$u',
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

class TrabajoMaqueta extends StatelessWidget {
  const TrabajoMaqueta({super.key});
  @override
  Widget build(BuildContext context) => MaqBuilder((context) {
    final k = kc(context);
    final reqs = pv.myReqs;
    final nuevas = reqs.where((r) => r.k == 'nuevas').toList();
    final proc = reqs.where((r) => r.k == 'proceso').toList();
    final fin = reqs.where((r) => r.k == 'fin').toList();
    final visits = pv.visits.where((x) => !x.done).toList()
      ..sort(
        (a, b) => a.d != b.d ? a.d.compareTo(b.d) : a.time.compareTo(b.time),
      );
    final s = pv.stats;
    final lv = repLevel(s.done);
    Widget verifRow(
      String icon,
      String t,
      String sub,
      String pill,
      String pk,
    ) => Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: k.line, width: 1.5),
      ),
      child: GroupK([
        LiK(
          icon,
          t,
          sub: sub,
          onTap: () => openVerif(context),
          extra: Pill(pill, kind: pk),
        ),
      ]),
    );
    final hero = Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: k.dark ? const Color(0xFF1B3340) : k.navyBg,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: stack([
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            T(
              'Hola, ${pv.first}',
              size: 22,
              w: FontWeight.w800,
              color: Colors.white,
            ),
            T(
              pv.summary,
              size: 14,
              w: FontWeight.w700,
              color: const Color(0xFFD5E3E8),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: k.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            spacing: 14,
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: pv.avail ? k.green : const Color(0xFF9AA7B6),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    T(
                      pv.avail
                          ? 'Estás disponible hoy'
                          : 'No estás disponible hoy',
                      size: 17,
                      w: FontWeight.w800,
                    ),
                    sMut(
                      pv.avail
                          ? 'Te llegan solicitudes de tu zona'
                          : 'Actívalo para empezar a recibir trabajos',
                    ),
                  ],
                ),
              ),
              Sw(
                on: pv.avail,
                onTap: () {
                  if (!pv.avail &&
                      needVerif(context, 'empezar a recibir trabajos', () {
                        pv.avail = true;
                        maq.refresh();
                      })) {
                    return;
                  }
                  pv.avail = !pv.avail;
                  pv.syncMe();
                  maq.refresh();
                },
              ),
            ],
          ),
        ),
      ], gap: 14),
    );
    return PgTab(
      title: 'Trabajo',
      fab: workFab(context),
      flush: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 22,
        children: [
          hero,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _trabajoCuerpo(
              context,
              k,
              verifRow,
              visits,
              nuevas,
              proc,
              fin,
              s,
              lv,
            ),
          ),
        ],
      ),
    );
  });

  Widget _trabajoCuerpo(
    BuildContext context,
    KC k,
    Widget Function(String, String, String, String, String) verifRow,
    List<Visita> visits,
    List<Req> nuevas,
    List<Req> proc,
    List<Req> fin,
    ({int sent, int accepted, int done}) s,
    ({int i, String name, String next, int left, int pct}) lv,
  ) {
    return stack([
      if (pv.status == 'nuevo' && !pv.vExpired)
        verifRow(
          'shield',
          'Verifica tu identidad (opcional)',
          'Obtén la insignia verde y más confianza',
          'Sin verificar',
          'gray',
        ),
      if (pv.status == 'nuevo' && pv.vExpired)
        verifRow(
          'shield',
          'Tus fotos se borraron sin revisarse',
          'Vuelve a enviarlas cuando quieras',
          'Reenviar',
          'amber',
        ),
      if (pv.status == 'rechazado')
        verifRow(
          'shield',
          'No pudimos verificar tu identidad',
          'Toca para ver qué pasó e intentar de nuevo',
          'Revisar',
          'amber',
        ),
      if (pv.meCats.isEmpty)
        NoteK(
          'amber',
          'flag',
          'Por ahora Knock solo recibe solicitudes de mecánica, plomería y electricidad. Tu oficio (${pv.me.other.isEmpty ? 'otro' : pv.me.other}) quedó en tu perfil. Si también haces alguno de esos tres, agrégalo en Mi cuenta > Mi perfil público.',
        ),
      if (visits.isNotEmpty)
        _secH(
          'Próximas visitas',
          visits.length,
          stack([for (final v in visits) visitCard(context, v)], gap: 12),
        ),
      if (nuevas.isNotEmpty)
        _secH(
          'Solicitudes nuevas',
          nuevas.length,
          stack([
            if (pv.tip)
              Container(
                padding: const EdgeInsets.fromLTRB(16, 10, 6, 10),
                decoration: BoxDecoration(
                  color: k.navySoft,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  spacing: 12,
                  children: [
                    Icon(icn('clock'), color: k.navy),
                    Expanded(
                      child: T(
                        'Si respondes en menos de 15 minutos, es más probable que te elijan.',
                        size: 15,
                        w: FontWeight.w700,
                        color: k.navy,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        pv.tip = false;
                        maq.refresh();
                      },
                      icon: Icon(Icons.close, size: 18, color: k.navy),
                      tooltip: tr('Cerrar aviso'),
                    ),
                  ],
                ),
              ),
            for (final r in nuevas) reqCard(context, r),
            const NoteK(
              'green',
              'lock',
              'Solo ves la colonia. La dirección exacta aparece cuando el cliente acepta tu cotización.',
            ),
          ], gap: 12),
        ),
      if (proc.isNotEmpty)
        _secH(
          'Cotizaciones enviadas',
          proc.length,
          stack([for (final r in proc) reqCard(context, r)], gap: 12),
        ),
      if (pv.meCats.isNotEmpty &&
          visits.isEmpty &&
          nuevas.isEmpty &&
          proc.isEmpty)
        SizedBox(
          height: 260,
          child: emptyK(
            'list',
            'Todo al día',
            'Cuando te lleguen solicitudes o un cliente acepte tu cotización, aparecerán aquí.',
          ),
        ),
      if (fin.isNotEmpty)
        FoldK(
          k: 'tr-fin',
          title: 'Terminadas',
          summary: '${fin.length} ${fin.length == 1 ? 'trabajo' : 'trabajos'}',
          icon: 'check',
          child: stack([for (final r in fin) reqCard(context, r)], gap: 10),
        ),
      Row(
        spacing: 8,
        children: [
          for (final f in [
            ('${s.sent}', 'cotizaciones enviadas'),
            ('${s.accepted}', 'aceptadas'),
            ('${s.done}', 'trabajos terminados'),
          ])
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 6,
                ),
                decoration: BoxDecoration(
                  color: k.bg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  spacing: 2,
                  children: [
                    T(f.$1, size: 17, w: FontWeight.w900),
                    T(
                      f.$2,
                      size: 12.5,
                      w: FontWeight.w700,
                      color: k.mut,
                      align: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      GroupK([
        LiK(
          'award',
          'Nivel: ${lv.name}',
          sub: lv.next.isNotEmpty
              ? 'Te faltan ${lv.left} trabajo${lv.left == 1 ? '' : 's'} para ${lv.next}'
              : 'Mira tu reputación y responde opiniones',
          onTap: () => context.push(RT.reputacion),
          iconBg: k.amberSoft,
          iconFg: k.amberInk,
        ),
      ]),
    ], gap: 22);
  }
}

/// Visitas y solicitudes nuevas del técnico dentro del panel del mapa
/// («Mi agenda»).
class AgendaEnMapaBloque extends StatelessWidget {
  const AgendaEnMapaBloque({super.key, this.selV});
  final String? selV;
  @override
  Widget build(BuildContext context) {
    final k = kc(context);
    final visits = pv.visits.where((x) => !x.done).toList()
      ..sort(
        (a, b) => a.d != b.d ? a.d.compareTo(b.d) : a.time.compareTo(b.time),
      );
    final nuevas = pv.myReqs.where((r) => r.k == 'nuevas').toList();
    if (selV != null) {
      visits.sort((a, b) => (b.id == selV ? 1 : 0) - (a.id == selV ? 1 : 0));
    }
    return stack([
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          h3('Mi agenda en el mapa'),
          sMut(
            '${visits.length} ${visits.length == 1 ? 'visita' : 'visitas'} · ${nuevas.length} nuevas',
          ),
        ],
      ),
      if (visits.isNotEmpty)
        for (final v in visits)
          CardK(
            outline: v.id == selV ? k.amber : null,
            pad: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: stack([
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  SizedBox(
                    width: 54,
                    child: Column(
                      children: [h3(v.time), sMut(pv.dayLabel(v.d))],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        bT(v.titulo),
                        sMut(cliente(v.cid).n),
                        sMut('${cliente(v.cid).addr}, ${cliente(v.cid).col}'),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: BtnK(
                      'Cómo llegar',
                      () => maq.toast('Abriendo el mapa con la ruta…'),
                      kind: Bk.sec,
                      sm: true,
                      icon: 'pin',
                    ),
                  ),
                  Expanded(
                    child: BtnK(
                      'Ya llegué',
                      () => context.push(RT.iniciar(v.id)),
                      sm: true,
                    ),
                  ),
                ],
              ),
            ], gap: 10),
          )
      else
        sMut(
          'Sin visitas por ahora. Cuando un cliente acepte tu cotización, su dirección aparece aquí y en el mapa.',
        ),
      if (nuevas.isNotEmpty) ...[
        sMut('Solicitudes nuevas cerca (solo ves la colonia):'),
        GroupK([
          for (final r in nuevas)
            LiK(
              _catIcon(r.cat),
              r.titulo,
              sub: '${r.zona} · ${r.hace}',
              onTap: () {
                pv.ensureThread(r);
                unawaited(context.push(RT.chat(r.cid, r.id)));
              },
              extra: const Pill('Chatear', kind: 'amber'),
            ),
        ]),
      ],
    ], gap: 10);
  }
}

// ------------------------------------------------------------ mensajes y chat

class TecMensajesScreen extends StatelessWidget {
  const TecMensajesScreen({super.key});
  @override
  Widget build(BuildContext context) => PantallaSegunSesion(
    titulo: 'Mensajes de clientes',
    real: const ConversacionesReales(),
    ejemplo: _ejemplo,
  );

  Widget _ejemplo(BuildContext context) => MaqBuilder((context) {
    final k = kc(context);
    final ids = pv.th.keys.toList();
    return Pg(
      title: 'Mensajes de clientes',
      scroll: false,
      body: ids.isEmpty
          ? emptyK(
              'chat',
              'Aún no tienes conversaciones',
              'Cuando le escribas a un cliente desde una solicitud, la conversación aparece aquí.',
              BtnK(
                'Ver solicitudes',
                () => context.go('/trabajo'),
                kind: Bk.sec,
                auto: true,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: GroupK([
                for (final id in ids)
                  () {
                    final c = cliente(id);
                    final list = pv.th[id]!;
                    final last =
                        list.where((m) => m.s != 'sys').lastOrNull ??
                        Msg('p', '');
                    final r = pv.reqOfClient(id);
                    final u = pv.unread[id] ?? 0;
                    final tag = r == null
                        ? ''
                        : const {
                            'nuevas': 'Solicitud nueva',
                            'proceso': 'Cotización enviada',
                            'aceptada': 'Cotización aceptada',
                            'fin': 'Terminado',
                          }[r.k]!;
                    return InkWell(
                      onTap: r == null
                          ? null
                          : () {
                              pv.unread[id] = 0;
                              unawaited(context.push(RT.chat(id, r.id)));
                            },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 14,
                          children: [
                            Av(ini: c.ini, color: c.c, size: 48),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 2,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      T(c.n, size: 16, w: FontWeight.w900),
                                      sMut(last.h, size: 13.5),
                                    ],
                                  ),
                                  T(
                                    '$tag · ${c.col}',
                                    size: 13.5,
                                    w: FontWeight.w700,
                                    color: k.navy,
                                  ),
                                  Text(
                                    '${last.s == 'me' ? '${tr('Tú')}: ' : ''}${tr(last.t)}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 13.5,
                                      fontWeight: u > 0
                                          ? FontWeight.w900
                                          : FontWeight.w700,
                                      color: u > 0 ? k.ink : k.mut,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (u > 0) Pill('$u', bg: k.red, fg: Colors.white),
                          ],
                        ),
                      ),
                    );
                  }(),
              ]),
            ),
    );
  });
}

class TecChatScreen extends StatefulWidget {
  const TecChatScreen({super.key, required this.cid, required this.rid});
  final String cid, rid;
  @override
  State<TecChatScreen> createState() => _TecChatState();
}

class _TecChatState extends State<TecChatScreen> {
  final _c = TextEditingController();
  final _sc = ScrollController();

  @override
  void initState() {
    super.initState();
    pv.chatAbierto = widget.cid;
    pv.unread[widget.cid] = 0;
    maq.addListener(_l);
  }

  void _l() {
    pv.unread[widget.cid] = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_sc.hasClients) _sc.jumpTo(_sc.position.maxScrollExtent);
    });
  }

  @override
  void dispose() {
    maq.removeListener(_l);
    pv.chatAbierto = null;
    _c.dispose();
    _sc.dispose();
    super.dispose();
  }

  void _send(String t) {
    if (t.trim().isEmpty) return;
    _c.clear();
    pv.workerSay(widget.rid, t.trim());
  }

  Widget _bitCard(BuildContext context, Req r) {
    final b = r.bit!;
    final k = kc(context);
    Widget lst(String title, List<String> l) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        labT(title),
        for (final x in l)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              const Text('•'),
              Expanded(child: sMut(x, color: k.ink)),
            ],
          ),
      ],
    );
    return CardK(
      child: stack([
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Pill('Resumen para ti', kind: 'amber', icon: 'sparkle'),
            sMut('${b.msgs} mensajes'),
          ],
        ),
        lst('Lo que sabes', b.datos),
        if (b.falta.isNotEmpty) lst('Por confirmar', b.falta),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            labT('Qué llevar'),
            sMut(b.tools, color: k.ink),
          ],
        ),
        sMut('La IA puede equivocarse: revísalo antes de guardarlo.'),
        const NotaIaDeEjemplo(),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (!b.saved)
              BtnK(
                'Guardar en bitácora',
                () {
                  b.saved = true;
                  r.bitOpen = false;
                  maq.refresh();
                  maq.toast('Guardado en la bitácora del trabajo');
                },
                sm: true,
                auto: true,
                icon: 'check',
              ),
            BtnK(
              b.saved ? 'Cerrar' : 'No guardar',
              () {
                if (!b.saved) {
                  r.bit = null;
                } else {
                  r.bitOpen = false;
                }
                maq.refresh();
              },
              kind: Bk.ghost,
              sm: true,
              auto: true,
            ),
          ],
        ),
      ], gap: 10),
    );
  }

  @override
  Widget build(BuildContext context) => MaqBuilder((context) {
    final k = kc(context);
    final c = cliente(widget.cid);
    final r = pv.req(widget.rid) ?? pv.reqOfClient(widget.cid)!;
    final th = pv.ensureThread(r);
    final mine = pv.workerMsgs(th);
    final top = Container(
      constraints: const BoxConstraints(minHeight: 60),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: k.surface,
        border: Border(bottom: BorderSide(color: k.line2)),
      ),
      child: Row(
        spacing: 8,
        children: [
          InkWell(
            onTap: () => context.pop(),
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.chevron_left, size: 28, color: k.navy),
            ),
          ),
          Av(ini: c.ini, color: c.c, size: 40),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                T(c.n, size: 18, w: FontWeight.w900, maxLines: 1),
                T(
                  '${r.titulo} · ${c.col}',
                  size: 13,
                  w: FontWeight.w700,
                  color: k.mut,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
    final items = <Widget>[
      for (final m in th)
        if (m.s == 'sys')
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: k.line2,
                borderRadius: BorderRadius.circular(12),
              ),
              child: T(
                m.t,
                size: 13,
                w: FontWeight.w800,
                color: k.mut,
                align: TextAlign.center,
              ),
            ),
          )
        else
          Align(
            alignment: m.s == 'me'
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .8,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: m.s == 'me' ? k.navyBg : k.surface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(m.s == 'me' ? 18 : 6),
                  bottomRight: Radius.circular(m.s == 'me' ? 6 : 18),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      tr(m.t),
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 15.5,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                        color: m.s == 'me' ? Colors.white : k.ink,
                      ),
                    ),
                  ),
                  Text(
                    m.h,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: (m.s == 'me' ? Colors.white : k.ink).withAlpha(
                        165,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      if (pv.typing == widget.cid)
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: k.surface,
              borderRadius: BorderRadius.circular(18),
            ),
            child: sMut('escribiendo…'),
          ),
        ),
      if (r.bit != null && r.bitOpen) _bitCard(context, r),
    ];
    final Widget ai;
    if (r.k == 'nuevas') {
      ai = Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        color: k.surface,
        child: mine > 0
            ? stack([
                BtnK(
                  'Armar cotización con IA',
                  () => context.push(RT.cotizar(r.id)),
                  sm: true,
                  icon: 'sparkle',
                ),
                sMut(
                  'La IA usa esta conversación para proponerte el precio y la nota.',
                ),
                _sumBtn(r),
                const NotaIaDeEjemplo(),
              ], gap: 8)
            : stack([
                const BtnK(
                  'Armar cotización con IA',
                  null,
                  kind: Bk.sec,
                  sm: true,
                  icon: 'sparkle',
                ),
                sMut(
                  'Primero escríbele al cliente para entender el trabajo. Después la IA te arma la cotización.',
                ),
              ], gap: 8),
      );
    } else {
      ai = Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        color: k.surface,
        child: Row(
          spacing: 4,
          children: [
            Icon(icn('check'), size: 15, color: k.navy),
            Expanded(
              child: T(
                '${r.k == 'proceso'
                    ? 'Cotización enviada'
                    : r.k == 'aceptada'
                    ? 'Cotización aceptada'
                    : 'Trabajo terminado'}${r.quote != null ? ' · ${r.quote!.txt}' : ''}',
                size: 14,
                w: FontWeight.w800,
                color: k.navy,
              ),
            ),
          ],
        ),
      );
    }
    const qr = {
      'plo': ['¿Me manda una foto de la etiqueta?', '¿Es de gas?'],
      'mec': ['¿Qué año y modelo es el auto?', '¿Me manda una foto?'],
      'ele': ['¿Hay chispas o huele a quemado?', '¿Me manda una foto?'],
    };
    final quick = [
      ...qr[r.cat]!,
      '¿Cuál es su colonia?',
      '¿Qué día le acomoda?',
      'Llevo los materiales',
    ];
    return Pg(
      noHeader: true,
      top: top,
      scroll: false,
      body: ListView(
        controller: _sc,
        padding: const EdgeInsets.all(16),
        children: [
          for (final w in items)
            Padding(padding: const EdgeInsets.only(bottom: 10), child: w),
        ],
      ),
      foot: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ai,
          if (r.k == 'nuevas')
            Container(
              color: k.surface,
              padding: const EdgeInsets.only(top: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  spacing: 8,
                  children: [
                    for (final t in quick)
                      chipRapido(context, t, () => _send(t)),
                  ],
                ),
              ),
            ),
          _composerT(context, _c, () => _send(_c.text)),
        ],
      ),
    );
  });

  bool _sum = false;

  Widget _sumBtn(Req r) {
    if (_sum) {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          CargaK(tipo: TipoCarga.puntos, size: 40),
          Flexible(
            child: MensajesRotativos([
              'Leyendo la conversación…',
              'Armando el resumen…',
            ]),
          ),
        ],
      );
    }
    if (r.bit != null) {
      return r.bitOpen
          ? const SizedBox()
          : BtnK(
              'Ver resumen guardado',
              () {
                r.bitOpen = true;
                maq.refresh();
              },
              kind: Bk.ghost,
              sm: true,
              icon: 'doc',
            );
    }
    return BtnK(
      'Resumir la conversación (opcional)',
      () {
        setState(() => _sum = true);
        Timer(const Duration(milliseconds: 1400), () {
          if (!mounted) return;
          _sum = false;
          r.bit = pv.summary0(r);
          r.bitOpen = true;
          maq.refresh();
          setState(() {});
        });
      },
      kind: Bk.sec,
      sm: true,
      icon: 'doc',
    );
  }
}

Widget _composerT(
  BuildContext c,
  TextEditingController ctl,
  VoidCallback onSend,
) {
  final k = kc(c);
  return Container(
    padding: EdgeInsets.fromLTRB(
      12,
      10,
      12,
      12 + MediaQuery.of(c).padding.bottom,
    ),
    decoration: BoxDecoration(
      color: k.surface,
      border: Border(top: BorderSide(color: k.line2)),
    ),
    child: Row(
      spacing: 8,
      children: [
        Expanded(
          child: TextField(
            controller: ctl,
            onSubmitted: (_) => onSend(),
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: k.ink,
            ),
            decoration: InputDecoration(
              hintText: tr('Escribe un mensaje'),
              hintStyle: TextStyle(
                fontFamily: 'Nunito',
                color: k.mut.withAlpha(160),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide(color: k.line, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide(color: k.navy, width: 2),
              ),
            ),
          ),
        ),
        Material(
          color: k.amber,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onSend,
            child: const SizedBox(
              width: 48,
              height: 48,
              child: Icon(Icons.send, color: Color(0xFF231A15), size: 22),
            ),
          ),
        ),
      ],
    ),
  );
}
