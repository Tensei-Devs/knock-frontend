import 'dart:async';

import 'package:app/core/preferencias/preferencias_provider.dart';
import 'package:app/core/sesion/almacen_seguro.dart';
import 'package:app/core/sesion/es_tecnico_provider.dart';
import 'package:app/features/cuenta/presentation/perfil_controller.dart';
import 'package:app/features/maqueta/cobertura.dart';
import 'package:app/features/maqueta/datos.dart';
import 'package:app/features/maqueta/casa_y_auto_real.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/nav.dart';
import 'package:app/features/maqueta/pantallas_actividad.dart';
import 'package:app/features/maqueta/pantallas_tecnico.dart';
import 'package:app/features/maqueta/sesiones_reales.dart';
import 'package:app/features/maqueta/tecnico_estado.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

String _longDateMsg(DateTime d) => longDate(d);

// ------------------------------------------------------------ Mi cuenta

class CuentaMaqueta extends ConsumerWidget {
  const CuentaMaqueta({super.key});

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    await hoja<void>(
      context,
      (ctx, _) => stack([
        h2('¿Cerrar sesión?'),
        mutT(
          'Tus trabajos y mensajes se quedan guardados para cuando vuelvas a entrar.',
        ),
        BtnK('Cerrar sesión', () async {
          Navigator.pop(ctx);
          await ref.read(perfilControllerProvider.notifier).cerrarSesion();
          await maq.olvidarTelefono(ref.read(almacenSeguroProvider));
          maq.toast('Cerraste sesión');
        }, kind: Bk.dark),
        BtnK('Cancelar', () => Navigator.pop(ctx), kind: Bk.ghost),
      ]),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfil = perfilCargado(ref.watch(perfilControllerProvider));
    if (perfil != null && maq.user.name.isEmpty) {
      maq.user.name = perfil.nombre;
      maq.user.first = perfil.nombre.split(' ').first;
      if (perfil.colonia != null) maq.user.col = perfil.colonia!;
      if (perfil.codigoPostal != null) maq.user.cp = perfil.codigoPostal!;
    }
    final esTecnico = ref.watch(esTecnicoProvider);
    unawaited(maq.cargarTelefono(ref.read(almacenSeguroProvider)));
    return MaqBuilder((context) {
      final u = maq.user;
      final k = kc(context);
      final nsaved = maq.saved.values.where((v) => v).length;
      return PgTab(
        title: 'Mi cuenta',
        body: stack([
          if (maq.delAt != null)
            CardK(
              outline: k.amber,
              child: stack([
                bT('Tu cuenta se eliminará el ${_longDateMsg(maq.delAt!)}'),
                BtnK('Cancelar la eliminación', () {
                  maq.cancelDelete();
                  maq.toast('Cancelaste la eliminación de tu cuenta');
                }, sm: true),
              ], gap: 10),
            ),
          CardK(
            child: Row(
              spacing: 14,
              children: [
                Av(
                  ini: initials(u.name),
                  color: const Color(0xFF2A5568),
                  size: 64,
                  photo: u.photoPath,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      h3(u.name.isEmpty ? '—' : u.name),
                      if (u.phone.isNotEmpty) sMut('+52 ${u.phone}'),
                      sMut('${u.col}, Tula de Allende'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          GroupK([
            LiK(
              'house',
              'Mi casa y mi auto',
              sub: 'Recordatorios y historial',
              onTap: () => context.push(RM.miCasa),
              extra: maq.remind ? const Pill('1', kind: 'amber') : null,
            ),
            LiK(
              'heart',
              'Mis técnicos de confianza',
              sub: '$nsaved guardados',
              onTap: () => context.push(RM.confianza),
            ),
            LiK(
              'bell',
              'Avisos',
              sub: 'Lo último que pasó',
              onTap: () => context.push(RM.avisos),
            ),
          ]),
          GroupK([
            LiK(
              'user',
              'Mis datos',
              sub: 'Nombre, dirección y foto',
              onTap: () => editarDatos(context),
            ),
            LiK(
              'gear',
              'Configuración',
              sub: 'Avisos, privacidad, cuenta',
              onTap: () => context.push('/cuenta/configuracion'),
            ),
            LiK(
              'help',
              'Centro de ayuda',
              onTap: () => context.push(RM.ayuda()),
            ),
          ]),
          if (!esTecnico)
            GroupK([
              LiK(
                'wrench',
                'Ofrece tus servicios en Knock',
                sub: 'Para talleres y técnicos',
                onTap: () => context.push(RT.registro),
                iconBg: k.amberSoft,
                iconFg: k.amberInk,
              ),
            ])
          else ...[
            const Padding(
              padding: EdgeInsets.only(left: 4),
              child: _Gl('Mi negocio'),
            ),
            GroupK([
              LiK(
                'wrench',
                'Mi trabajo',
                sub: 'Solicitudes, agenda y cotizaciones',
                onTap: () => context.go('/trabajo'),
              ),
              LiK(
                'eye',
                'Mi perfil público',
                sub: 'Lo que ven los clientes',
                onTap: () => context.push(RT.perfil),
              ),
              LiK(
                'award',
                'Mi reputación',
                sub: 'Nivel, opiniones y estadísticas',
                onTap: () => context.push(RT.reputacion),
              ),
              LiK(
                'shield',
                'Verificación de identidad',
                sub: pv.verifLabel(),
                onTap: () => openVerif(context),
              ),
            ]),
          ],
          BtnK(
            'Cerrar sesión',
            () => _logout(context, ref),
            kind: Bk.ghost,
            icon: 'logout',
          ),
          if (ref.watch(interruptorDePruebaProvider)) ...[
            const _Gl('Zona de pruebas'),
            GroupK([
              LiK(
                'user',
                'Cliente con historial de ejemplo',
                sub: 'Carga trabajos, chats y guardados de la maqueta',
                onTap: () {
                  maq.loadDemo();
                  maq.toast('Historial de ejemplo cargado');
                },
              ),
              LiK(
                'user',
                'Ver pasos de registro (nombre, zona, foto)',
                sub: 'No guarda nada',
                onTap: () => context.push('/m/entrada-prueba'),
              ),
              LiK(
                'pin',
                'Simular ubicación fuera de cobertura (Actopan)',
                sub: 'Muestra «¡Pronto estaremos cerca de ti!»',
                onTap: () {
                  maq.ubicacionSimulada = (
                    lat: actopanHidalgo.latitude,
                    lng: actopanHidalgo.longitude,
                  );
                  maq.refresh();
                  maq.toast('Ubicación simulada: Actopan, Hgo.');
                },
              ),
              LiK(
                'pin',
                'Simular ubicación dentro de cobertura',
                sub: 'Col. Centro, Tula de Allende',
                onTap: () {
                  maq.ubicacionSimulada = (
                    lat: zonasKnock.first.lat,
                    lng: zonasKnock.first.lng,
                  );
                  maq.refresh();
                  maq.toast('Ubicación simulada: Tula de Allende');
                },
              ),
              LiK(
                'locate',
                'Usar mi ubicación real',
                onTap: () {
                  maq.ubicacionSimulada = null;
                  maq.refresh();
                  maq.toast('Ubicación real');
                },
              ),
              LiK(
                'wifi',
                'Ver pantalla sin internet',
                onTap: () => context.push(RM.sinConexion),
              ),
              LiK(
                'shield',
                'Simular verificación (sin fotos)',
                sub: 'Resultado por los dos últimos dígitos del celular',
                onTap: () {
                  if (!pv.me.registered) {
                    pv.register(
                      name: u.name.isEmpty ? 'Ricardo Mendoza Pérez' : u.name,
                      business: '',
                      phone: u.phone,
                      cats0: {'plo'},
                      otherOn: false,
                      other: '',
                      how: 'dom',
                      km: '8 km',
                      address: '',
                      about: '',
                      years: '8',
                      svcs: [],
                    );
                    ref
                        .read(esTecnicoProvider.notifier)
                        .cambiar(esTecnico: true);
                  }
                  pv.targetLevel = 'basico';
                  pv.verifSend(u.phone.isNotEmpty ? u.phone : '555 555 0001');
                  unawaited(context.push(RT.pendiente));
                },
              ),
              LiK(
                'trash',
                'Borrar todo y reiniciar',
                onTap: () {
                  maq.resetAll();
                  maq.toast('Todo borrado');
                },
              ),
              LiK(
                'clock',
                'Simular que pasaron los 7 días de gracia',
                onTap: () {
                  maq.delAt = null;
                  maq.refresh();
                  maq.toast(
                    'Pasaron los 7 días: la cuenta se habría eliminado',
                  );
                },
              ),
              LiK(
                'wrench',
                'Modo técnico (prueba)',
                sub: esTecnico ? 'Activo' : 'Apagado',
                onTap: () {
                  if (!esTecnico && !pv.me.registered) {
                    pv.register(
                      name: u.name.isEmpty ? 'Ricardo Mendoza Pérez' : u.name,
                      business: '',
                      phone: u.phone,
                      cats0: {'plo'},
                      otherOn: false,
                      other: '',
                      how: 'dom',
                      km: '8 km',
                      address: '',
                      about: '',
                      years: '8',
                      svcs: [],
                    );
                  }
                  ref
                      .read(esTecnicoProvider.notifier)
                      .cambiar(esTecnico: !esTecnico);
                },
              ),
              LiK(
                'wrench',
                'Técnico con visita y opinión de ejemplo',
                sub: 'Carga una visita, un trabajo terminado y una opinión',
                onTap: () {
                  if (!pv.me.registered) {
                    pv.register(
                      name: u.name.isEmpty ? 'Ricardo Mendoza Pérez' : u.name,
                      business: '',
                      phone: u.phone,
                      cats0: {'plo'},
                      otherOn: false,
                      other: '',
                      how: 'dom',
                      km: '8 km',
                      address: '',
                      about: '',
                      years: '8',
                      svcs: [],
                    );
                  }
                  pv.seedDemo();
                  ref.read(esTecnicoProvider.notifier).cambiar(esTecnico: true);
                  maq.toast('Técnico de ejemplo cargado');
                },
              ),
            ]),
          ],
        ]),
      );
    });
  }
}

class _Gl extends StatelessWidget {
  const _Gl(this.s);
  final String s;
  @override
  Widget build(BuildContext context) =>
      T(s, size: 15, w: FontWeight.w900, color: kc(context).mut);
}

// ------------------------------------------------------------ Mis datos

void editarDatos(BuildContext context) {
  final u = maq.user;
  final name = TextEditingController(text: u.name);
  final addr = TextEditingController(text: u.addr);
  var col = u.col;
  String? photo = u.photoPath;
  var err = false;
  unawaited(
    hoja<void>(context, (ctx, set) {
      final nm = name.text.trim().replaceAll(RegExp(r'\s+'), ' ');
      final okN =
          nm.length >= 2 &&
          RegExp(r"^[A-Za-zÁÉÍÓÚÜÑáéíóúüñ' .-]+$").hasMatch(nm);
      final okA = addr.text.trim().isEmpty || addr.text.trim().length >= 5;
      return stack([
        sheetH(ctx, 'Mis datos', big: true),
        Row(
          spacing: 12,
          children: [
            Av(
              ini: initials(name.text),
              color: const Color(0xFF2A5568),
              size: 64,
              photo: photo,
            ),
            Wrap(
              spacing: 8,
              children: [
                BtnK(
                  photo != null ? 'Cambiar' : 'Agregar foto',
                  () async {
                    final f = await elegirFotos(varias: false);
                    if (f.isNotEmpty) set(() => photo = f.first);
                  },
                  kind: Bk.sec,
                  sm: true,
                  auto: true,
                  icon: 'camera',
                ),
                if (photo != null)
                  BtnK(
                    'Quitar',
                    () => set(() => photo = null),
                    kind: Bk.ghost,
                    sm: true,
                    auto: true,
                  ),
              ],
            ),
          ],
        ),
        FieldK(
          label: 'Nombre',
          c: name,
          err: err && !okN ? 'Escribe tu nombre (solo letras)' : null,
          onChanged: (_) => set(() {}),
        ),
        FieldK(
          label: 'Calle y número',
          opt: true,
          c: addr,
          hint: 'Ej.: Calle Jacarandas 45',
          err: err && !okA ? 'Escribe calle y número' : null,
          help: 'Se pide al pedir un servicio a domicilio. Solo la ve el experto que elijas.',
          onChanged: (_) => set(() {}),
        ),
        stack([
          labT('Colonia'),
          chipsWrap([
            for (final c in colores)
              ChipK(c, on: col == c, onTap: () => set(() => col = c)),
          ]),
        ], gap: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: sMut('Tu celular: +52 ${u.phone}')),
            LinkK('Cambiar mi número', () {
              Navigator.pop(ctx);
              cambiarNumero(context, recuperar: false);
            }),
          ],
        ),
        BtnK('Guardar cambios', () {
          if (!okN || !okA) {
            set(() => err = true);
            return;
          }
          u.name = nm;
          u.first = nm.split(' ').first;
          u.addr = addr.text.trim().replaceAll(RegExp(r'\s+'), ' ');
          u.col = col;
          u.photoPath = photo;
          Navigator.pop(ctx);
          maq.refresh();
          maq.toast('Datos actualizados');
        }),
      ]);
    }).whenComplete(() {
      name.dispose();
      addr.dispose();
    }),
  );
}

// ------------------------------------------------------------ Cambiar número / recuperar acceso

void cambiarNumero(BuildContext context, {required bool recuperar}) {
  var step = recuperar ? 'old' : 'new';
  var old = '', nphone = '', note = '', err = '';
  var selfie = false, failed = false;

  final cOld = TextEditingController();
  final cNew = TextEditingController();
  final cCode = TextEditingController();
  final cNote = TextEditingController();
  unawaited(
    hoja<void>(context, (ctx, set) {
      String? e() => err.isEmpty ? null : err;
      Widget phone(String label, TextEditingController c, String hint) =>
          FieldK(
            label: label,
            c: c,
            hint: hint,
            keyboard: TextInputType.number,
            maxLen: 12,
            prefix: const PhoneCc(),
            err: e(),
            onChanged: (v) => set(() {}),
          );
      switch (step) {
        case 'old':
          return stack([
            sheetH(ctx, 'Recuperar mi cuenta', big: true),
            mutT(
              'Escribe el número con el que creaste tu cuenta. Después te pediremos un número nuevo y una forma de confirmar que eres tú.',
            ),
            phone('Tu número anterior', cOld, '771 234 5678'),
            BtnK(
              'Continuar',
              digits(cOld.text).length == 10
                  ? () {
                      old = cOld.text;
                      if (maq.user.phone.isNotEmpty &&
                          digits(old) != digits(maq.user.phone)) {
                        set(
                          () => err = 'No encontramos una cuenta con ese número en este dispositivo.',
                        );
                        return;
                      }
                      set(() {
                        err = '';
                        step = 'new';
                      });
                    }
                  : null,
            ),
          ]);
        case 'new':
          return stack([
            sheetH(
              ctx,
              recuperar ? 'Tu número nuevo' : 'Cambiar mi número',
              big: true,
            ),
            mutT(
              recuperar ? 'Te mandaremos un código por SMS a tu número nuevo.' : 'Te mandaremos un código por SMS al número nuevo y avisaremos al anterior. Tu cuenta, tus trabajos y tus mensajes se quedan igual.',
            ),
            phone('Número nuevo', cNew, '771 234 5678'),
            BtnK(
              'Enviarme el código',
              digits(cNew.text).length == 10
                  ? () {
                      if (digits(cNew.text) == digits(maq.user.phone)) {
                        set(
                          () => err = 'Escribe un número distinto al actual.',
                        );
                        return;
                      }
                      set(() {
                        err = '';
                        step = 'code';
                        nphone = cNew.text;
                        cCode.clear();
                      });
                    }
                  : null,
            ),
          ]);
        case 'code':
          return stack([
            sheetH(ctx, 'Escribe el código', big: true),
            rich('Lo mandamos por SMS al **+52 $nphone**.', w: FontWeight.w400),
            FieldK(
              label: 'Código de 6 números',
              c: cCode,
              hint: '••••••',
              keyboard: TextInputType.number,
              maxLen: 6,
              center: true,
              err: e(),
              help: 'En esta demostración sirve cualquier código de 6 números. El 000000 simula un código incorrecto.',
              onChanged: (_) => set(() {}),
            ),
            BtnK(
              'Confirmar',
              digits(cCode.text).length == 6
                  ? () {
                      if (digits(cCode.text) == '000000') {
                        set(
                          () => err = 'Código incorrecto. Revisa el SMS e inténtalo de nuevo.',
                        );
                        return;
                      }
                      if (!recuperar) {
                        _aplicarNumero(
                          ctx,
                          nphone,
                          recuperar,
                          set,
                          (s) => step = s,
                        );
                        return;
                      }
                      set(() {
                        err = '';
                        step = pv.verified ? 'selfie' : 'soporte';
                      });
                    }
                  : null,
            ),
            BtnK(
              'Cambiar número',
              () => set(() {
                step = 'new';
                cCode.clear();
                err = '';
              }),
              kind: Bk.ghost,
            ),
          ]);
        case 'selfie':
          return stack([
            sheetH(ctx, 'Confirma que eres tú', big: true),
            mutT(
              'Como ya verificaste tu identidad, tómate una selfie: la comparamos con la que validamos antes. La borramos en cuanto termina la comparación.',
            ),
            Column(
              spacing: 12,
              children: [
                Av(
                  ini: '?',
                  color: selfie ? kc(ctx).navy : const Color(0xFF6B5D52),
                  size: 96,
                ),
                BtnK(
                  selfie ? 'Repetir selfie' : 'Tomar selfie',
                  () async {
                    final f = await elegirFotos(varias: false);
                    if (f.isNotEmpty) {
                      set(() {
                        selfie = true;
                        err = '';
                      });
                    }
                  },
                  kind: Bk.sec,
                  sm: true,
                  auto: true,
                  icon: 'camera',
                ),

                if (err.isNotEmpty)
                  Row(
                    spacing: 6,
                    children: [
                      Icon(Icons.close, size: 16, color: kc(ctx).red),
                      Expanded(
                        child: T(
                          err,
                          size: 14,
                          w: FontWeight.w800,
                          color: kc(ctx).red,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            BtnK(
              'Comparar con mi selfie validada',
              selfie
                  ? () {
                      if (digits(nphone).endsWith('72')) {
                        set(() {
                          err = 'La selfie no coincide con la que validamos. Prueba de nuevo con buena luz o habla con soporte.';
                          failed = true;
                          selfie = false;
                        });
                        return;
                      }
                      _aplicarNumero(
                        ctx,
                        nphone,
                        recuperar,
                        set,
                        (s) => step = s,
                      );
                    }
                  : null,
            ),
            if (failed)
              BtnK(
                'Hablar con soporte',
                () => set(() {
                  step = 'soporte';
                  err = '';
                }),
                kind: Bk.ghost,
              ),
          ]);
        case 'soporte':
          return stack([
            sheetH(ctx, 'Soporte revisará tu caso', big: true),
            rich(
              'Para confirmar que eres tú, cuéntanos del **último servicio** que pediste o tomaste (qué fue, cuándo y con quién).',
              w: FontWeight.w400,
            ),
            FieldK(
              label: 'Datos de tus servicios',
              c: cNote,
              lines: 4,
              maxLen: 400,
              hint: 'Ej.: En septiembre pedí que revisaran mi boiler; me cotizó Ricardo Mendoza.',
              help: '${cNote.text.length}/400',
              onChanged: (v) {
                note = v;
                set(() {});
              },
            ),
            BtnK(
              'Enviar a soporte',
              note.trim().length >= 15
                  ? () {
                      set(() => step = 'wait');
                      Timer(const Duration(seconds: 6), () {
                        if (ctx.mounted) {
                          _aplicarNumero(
                            ctx,
                            nphone,
                            recuperar,
                            set,
                            (s) => step = s,
                          );
                        }
                      });
                    }
                  : null,
            ),
          ]);
        case 'wait':
          return stack([
            sheetH(ctx, 'Estamos revisando tu caso', big: true),
            Center(
              child: Column(
                spacing: 14,
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: kc(ctx).amberSoft,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icn('clock'),
                      size: 52,
                      color: kc(ctx).amberInk,
                    ),
                  ),
                  rich(
                    'Soporte revisa lo que nos contaste y te responde en menos de 24 horas. **En esta demostración tarda unos segundos.**',
                    w: FontWeight.w400,
                    align: TextAlign.center,
                  ),
                ],
              ),
            ),
            BtnK('Cerrar', () => Navigator.pop(ctx), kind: Bk.ghost),
          ]);
        default:
          return stack([
            sheetH(ctx, 'Número actualizado', big: true),
            Center(
              child: Column(
                spacing: 14,
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: kc(ctx).greenSoft,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check, size: 52, color: kc(ctx).green),
                  ),
                  rich(
                    'Tu número ahora es **+52 ${maq.user.phone}**. ${recuperar ? 'Cerramos las sesiones abiertas en otros dispositivos y avisamos al número anterior.' : 'Avisamos al número anterior y cerramos las sesiones abiertas en otros dispositivos.'}',
                    w: FontWeight.w400,
                    align: TextAlign.center,
                  ),
                ],
              ),
            ),
            if (!recuperar)
              BtnK('Listo', () => Navigator.pop(ctx))
            else ...[
              BtnK('Entrar con mi número nuevo', () {
                Navigator.pop(ctx);
                context.go('/entrar');
              }),
              BtnK('Cerrar', () => Navigator.pop(ctx), kind: Bk.ghost),
            ],
          ]);
      }
    }).whenComplete(() {
      cOld.dispose();
      cNew.dispose();
      cCode.dispose();
      cNote.dispose();
    }),
  );
}

void _aplicarNumero(
  BuildContext ctx,
  String nphone,
  bool recuperar,
  StateSetter set,
  void Function(String) setStep,
) {
  final old = maq.user.phone;
  maq.user.phone = fmtPhone(nphone);
  if (!recuperar) {
    maq.notif(
      'bell',
      'Cambiaste tu número',
      'Avisamos al número anterior (+52 $old) y cerramos otras sesiones.',
      'cuenta',
    );
  }
  set(() => setStep('done'));
}

// ------------------------------------------------------------ Mi casa y mi auto

class MiCasaScreen extends StatelessWidget {
  const MiCasaScreen({super.key});

  @override
  Widget build(BuildContext context) => MaqBuilder((context) {
    final k = kc(context);
    return Pg(
      title: 'Mi casa y mi auto',
      body: stack([
        if (maq.remind)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: k.amberSoft,
              borderRadius: BorderRadius.circular(22),
            ),
            child: stack([
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  Icon(icn('car'), color: k.amberInk),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        h3('Ya toca cambio de aceite'),
                        T(
                          'Pasaron 6 meses desde el último (marzo)',
                          size: 14,
                          w: FontWeight.w700,
                          color: k.amberInk,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              BtnK('Pedir cotización', () {
                maq.startReq(cat: 'mec', pid: 'tr', desc: 'Cambio de aceite');
                unawaited(context.push(RM.solicitar));
              }),
              BtnK(
                'Recordarme en 1 mes',
                () {
                  maq.remind = false;
                  maq.refresh();
                  maq.toast('Te lo recordamos en un mes');
                },
                kind: Bk.ghost,
                sm: true,
              ),
            ], gap: 12),
          ),
        // Spec 031: los elementos reales de la persona (backend 041).
        const CasaYAutoReal(),
      ]),
    );
  });
}

// ------------------------------------------------------------ técnicos de confianza

class ConfianzaScreen extends StatelessWidget {
  const ConfianzaScreen({super.key});
  @override
  Widget build(BuildContext context) => MaqBuilder((context) {
    final k = kc(context);
    final ids = maq.saved.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();
    final ctx = <String, String>{};
    for (final id in ids) {
      final js = maq.jobs
          .where((j) => j.pid == id && j.status == 'terminado')
          .toList();
      if (js.isNotEmpty) {
        ctx[id] =
            '${js.length} ${js.length > 1 ? 'trabajos' : 'trabajo'} contigo · último: ${js.first.title.toLowerCase()}';
      }
    }
    return Pg(
      title: 'Mis técnicos de confianza',
      scroll: ids.isNotEmpty,
      body: ids.isEmpty
          ? emptyK(
              'heart',
              'Aún no guardas a nadie',
              'Cuando alguien te funcione, toca «Guardar» en su perfil y aparecerá aquí.',
              BtnK(
                'Buscar un experto',
                () => context.go('/inicio'),
                kind: Bk.sec,
                auto: true,
              ),
            )
          : stack([
              mutT('Las personas que ya te funcionaron, a un toque.'),
              for (final id in ids)
                () {
                  final o = provs[id]!;
                  return CardK(
                    child: stack([
                      InkWell(
                        onTap: () => context.push(RM.experto(id)),
                        child: Row(
                          spacing: 12,
                          children: [
                            Av.prov(o),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  T(o.name, size: 16.5, w: FontWeight.w900),
                                  sMut(ctx[id] ?? cats[o.cat]!.short),
                                  rateW(o),
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right, color: k.mut),
                          ],
                        ),
                      ),
                      BtnK(
                        'Volver a contratar',
                        () {
                          maq.startReq(cat: o.cat, pid: id);
                          unawaited(context.push(RM.solicitar));
                        },
                        kind: Bk.sec,
                        sm: true,
                      ),
                    ], gap: 12),
                  );
                }(),
            ]),
    );
  });
}

// ------------------------------------------------------------ Configuración

class ConfigMaqueta extends ConsumerWidget {
  const ConfigMaqueta({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(preferenciasProvider);
    final n = ref.read(preferenciasProvider.notifier);
    final langL = prefs.idioma.languageCode == 'en' ? 'English' : 'Español';
    final thL = switch (prefs.modoTema) {
      ThemeMode.light => 'Claro',
      ThemeMode.dark => 'Oscuro',
      ThemeMode.system => 'Automático',
    };
    final k = kc(context);
    return Pg(
      title: 'Configuración',
      body: stack([
        const _Gl('Preferencias'),
        GroupK([
          LiK(
            'chat',
            'Idioma',
            sub: langL,
            onTap: () => hoja<void>(
              context,
              (ctx, _) => stack([
                sheetH(ctx, 'Idioma · Language'),
                ChoiceK(
                  on: prefs.idioma.languageCode == 'es',
                  title: 'Español',
                  minH: 64,
                  onTap: () {
                    n.cambiarIdioma(const Locale('es'));
                    Navigator.pop(ctx);
                  },
                ),
                ChoiceK(
                  on: prefs.idioma.languageCode == 'en',
                  title: 'English',
                  minH: 64,
                  onTap: () {
                    n.cambiarIdioma(const Locale('en'));
                    Navigator.pop(ctx);
                  },
                ),
              ], gap: 12),
            ),
          ),
          LiK(
            'eye',
            'Apariencia',
            sub: thL,
            onTap: () => hoja<void>(
              context,
              (ctx, _) => stack([
                sheetH(ctx, 'Apariencia'),
                for (final x in const [
                  (ThemeMode.light, 'Claro', ''),
                  (ThemeMode.dark, 'Oscuro', ''),
                  (ThemeMode.system, 'Automático', 'Como mi teléfono'),
                ])
                  ChoiceK(
                    on: prefs.modoTema == x.$1,
                    title: x.$2,
                    sub: x.$3.isEmpty ? null : x.$3,
                    minH: 64,
                    onTap: () {
                      n.cambiarTema(x.$1);
                      Navigator.pop(ctx);
                    },
                  ),
              ], gap: 12),
            ),
          ),
        ]),
        const _Gl('Avisos'),
        GroupK([
          LiK(
            'bell',
            'Qué avisos recibir',
            onTap: () => context.push(RM.avisosConfig),
          ),
        ]),
        const _Gl('Privacidad y seguridad'),
        GroupK([
          LiK(
            'lock',
            'Privacidad y datos',
            sub: 'Descargar o corregir tus datos',
            onTap: () => context.push(RM.privacidad),
          ),
          LiK(
            'phone',
            'Sesiones y dispositivos',
            sub: 'Dónde está abierta tu cuenta',
            onTap: () => context.push(RM.sesiones),
          ),
        ]),
        const _Gl('Legal'),
        GroupK([
          LiK(
            'doc',
            'Aviso de privacidad',
            onTap: () => context.push(RM.aviso),
          ),
          LiK(
            'doc',
            'Términos y condiciones',
            onTap: () => context.push(RM.terminos),
          ),
        ]),
        const _Gl('Cuenta'),
        GroupK([
          liDanger(
            context,
            'trash',
            'Eliminar mi cuenta',
            () => context.push(RM.eliminar1),
          ),
        ]),
        T(
          'Knock · versión 1.0',
          size: 14,
          w: FontWeight.w700,
          color: k.mut,
          align: TextAlign.center,
        ),
      ]),
    );
  }
}

class AvisosConfigScreen extends StatelessWidget {
  const AvisosConfigScreen({super.key});
  @override
  Widget build(BuildContext context) => MaqBuilder((context) {
    const opt = [
      ('Recordatorios de mantenimiento', 'Aceite, tinaco, boiler y más'),
      ('Opiniones y respuestas', 'Cuando un experto responde tu opinión'),
      ('Promociones y novedades', 'Ofertas de expertos y noticias de Knock'),
    ];
    const fixed = [
      ('Nuevas cotizaciones', 'Cuando un experto responde tu solicitud'),
      ('Mensajes', 'De los expertos con los que hablas'),
      ('Visitas y citas', 'Confirmaciones, cambios y llegada del técnico'),
    ];
    return Pg(
      title: 'Qué avisos recibir',
      body: stack([
        const _Gl('Siempre activos'),
        GroupK([for (final x in fixed) _swRow(x.$1, x.$2, true, null)]),
        sMut(
          'Te avisan de tus servicios en curso. Por tu seguridad no se pueden apagar.',
        ),
        const _Gl('Tú decides'),
        GroupK([
          for (var i = 0; i < opt.length; i++)
            _swRow(opt[i].$1, opt[i].$2, maq.notifPref[i], () {
              maq.notifPref[i] = !maq.notifPref[i];
              maq.refresh();
            }),
        ]),
        sMut('Knock nunca comparte tu número con anunciantes.'),
      ]),
    );
  });
}

Widget _swRow(String t, String s, bool on, VoidCallback? onTap) => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  child: Row(
    spacing: 14,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 2,
          children: [
            T(t, w: FontWeight.w800),
            sMut(s, size: 13.5),
          ],
        ),
      ),
      Sw(on: on, onTap: onTap),
    ],
  ),
);

// ------------------------------------------------------------ avisos

class AvisosScreen extends StatelessWidget {
  const AvisosScreen({super.key});
  @override
  Widget build(BuildContext context) => MaqBuilder((context) {
    final k = kc(context);
    final tec = pv.me.registered ? pv.notifs : <AvisoT>[];
    if (maq.notifs.isEmpty && tec.isEmpty) {
      return Pg(
        title: 'Avisos',
        scroll: false,
        body: emptyK(
          'bell',
          'Sin avisos por ahora',
          'Aquí verás cuando te lleguen cotizaciones, se confirme una visita o publiques una opinión.',
        ),
      );
    }
    return Pg(
      title: 'Avisos',
      right: (maq.cUnread || pv.notifUnread > 0)
          ? LinkK('Marcar leídos', () {
              for (final n in maq.notifs) {
                n.read = true;
              }
              for (final n in pv.notifs) {
                n.read = true;
              }
              maq.refresh();
            })
          : null,
      body: stack([
        if (maq.notifs.isNotEmpty)
          _Gl(tec.isNotEmpty ? 'Como cliente' : 'Recientes'),
        if (maq.notifs.isNotEmpty)
          GroupK([
            for (final n in maq.notifs)
              InkWell(
                onTap: () {
                  n.read = true;
                  maq.refresh();
                  if (n.jobId != null) {
                    switch (n.go) {
                      case 'comparar':
                        unawaited(context.push(RM.comparar(n.jobId!)));
                      case 'visita':
                        unawaited(context.push(RM.visita(n.jobId!)));
                      case 'cita':
                        unawaited(context.push(RM.cita(n.jobId!)));
                      case 'calificar':
                        unawaited(context.push(RM.calificar(n.jobId!)));
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 14,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: n.read ? k.navySoft : k.amberSoft,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          icn(n.icon),
                          color: n.read ? k.navy : k.amberInk,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 2,
                          children: [
                            T(n.title, w: FontWeight.w800),
                            sMut(n.text, size: 13.5),
                            sMut(n.h, size: 13.5),
                          ],
                        ),
                      ),
                      if (!n.read) const Pill('Nuevo', kind: 'amber'),
                    ],
                  ),
                ),
              ),
          ]),
        if (tec.isNotEmpty) const _Gl('Como técnico'),
        if (tec.isNotEmpty)
          GroupK([
            for (final n in tec)
              InkWell(
                onTap: () {
                  n.read = true;
                  maq.refresh();
                  context.go(
                    n.go == 'provReputacion' ? RT.reputacion : '/trabajo',
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 14,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: n.read
                              ? kc(context).navySoft
                              : kc(context).amberSoft,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          icn(n.icon),
                          color: n.read
                              ? kc(context).navy
                              : kc(context).amberInk,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 2,
                          children: [
                            T(n.title, w: FontWeight.w800),
                            sMut(n.text, size: 13.5),
                            sMut(n.h, size: 13.5),
                          ],
                        ),
                      ),
                      if (!n.read) const Pill('Nuevo', kind: 'amber'),
                    ],
                  ),
                ),
              ),
          ]),
      ]),
    );
  });
}

// ------------------------------------------------------------ aviso y términos

Widget _bullets(BuildContext c, List<String> t) => stack([
  for (final x in t)
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Icon(icn('check')),
        Expanded(child: T(x, size: 15.5, w: FontWeight.w700)),
      ],
    ),
], gap: 8);

Widget _legal(BuildContext c, List<(String, String)> secs, String upd) {
  final k = kc(c);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: 8,
    children: [
      sMut(upd),
      for (final s in secs) ...[
        if (s.$1.isNotEmpty)
          T(s.$1, size: 16, w: FontWeight.w900, color: k.ink),
        T(s.$2, size: 15, w: FontWeight.w400),
      ],
    ],
  );
}

class AvisoScreen extends StatelessWidget {
  const AvisoScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = hayCuenta(context);
    return Pg(
      title: 'Aviso de privacidad',
      body: stack([
        CardK(
          child: stack([
            h3('En pocas palabras'),
            _bullets(context, const [
              'Usamos tu nombre, celular y colonia para que funcione tu cuenta.',
              'Tu dirección solo la ve el experto que elijas.',
              'Nunca vendemos tus datos.',
              'Puedes descargar, corregir o borrar tus datos cuando quieras.',
            ]),
          ], gap: 10),
        ),
        FoldK(
          k: 'lg-aviso',
          title: 'Leer el aviso completo',
          summary: '7 secciones · actualizado el 15 de sep 2026',
          icon: 'doc',
          child: _legal(context, const [
            (
              '',
              'El responsable de tus datos personales es José Julián Hernández Hernández, con domicilio en Alonso de Borja 92, colonia Aviación, C.P. 42506, Actopan, Hidalgo. Aquí te explicamos en palabras simples qué hacemos con ellos.',
            ),
            (
              '1. Qué datos recopilamos',
              '• Nombre y número de celular.\n• Tu colonia y, en servicios a domicilio, tu dirección.\n• Descripciones, fotos, mensajes y opiniones que publiques.\n• Si eres proveedor: foto de tu INE por ambos lados y una selfie. Se guardan cifradas y se borran en cuanto una persona autorizada las revisa (máximo 7 días); después solo queda el resultado y un código (hash) de tu CURP.',
            ),
            (
              '2. Para qué los usamos',
              'Finalidades necesarias: crear tu cuenta, enviar tus solicitudes, mostrar cotizaciones, confirmar visitas, verificar identidades y atender reportes de seguridad.\n\nFinalidades voluntarias: enviarte promociones, encuestas y recomendaciones. Puedes negarte en cualquier momento desde Privacidad y datos, sin perder el servicio.',
            ),
            (
              '3. Datos biométricos y consentimiento',
              'La selfie y su comparación con tu INE son datos biométricos. Solo los tratamos para verificar la identidad de los proveedores y solo con su consentimiento expreso, que pueden retirar cuando quieran. Las fotos se conservan cifradas hasta que se decide la verificación, con un máximo de 7 días; solo las ve personal autorizado y cada acceso queda registrado.',
            ),
            (
              '4. Con quién se comparten',
              'Con el proveedor cuya cotización aceptes (tu dirección y teléfono), con el servicio que valida identidades y con autoridades cuando la ley lo exija. Nunca vendemos tus datos.',
            ),
            (
              '5. Tus derechos ARCO',
              'Tienes derecho de Acceso, Rectificación, Cancelación y Oposición sobre tus datos, además de revocar tu consentimiento.',
            ),
            (
              '6. Cómo ejercerlos',
              'Desde Configuración › Privacidad y datos, o escribiendo al correo de contacto. Te respondemos en un máximo de 20 días hábiles.',
            ),
            (
              '7. Contacto',
              'Responsable de privacidad: el responsable indicado al inicio de este aviso.',
            ),
          ], 'Última actualización: 15 de septiembre de 2026'),
        ),
      ]),
      cta: auth
          ? BtnK(
              'Gestionar mis datos',
              () => context.push(RM.privacidad),
              kind: Bk.sec,
            )
          : null,
    );
  }
}

class TerminosScreen extends StatelessWidget {
  const TerminosScreen({super.key});
  @override
  Widget build(BuildContext context) => Pg(
    title: 'Términos y condiciones',
    body: stack([
      CardK(
        child: stack([
          h3('En pocas palabras'),
          _bullets(context, const [
            'Knock conecta; el trato lo haces directo con el experto.',
            'No cobramos, no recibimos ni guardamos pagos.',
            'Verificamos la identidad de cada experto (INE, selfie y teléfono). La calidad del trabajo es responsabilidad de quien lo hace.',
            'Solo quien tuvo un servicio puede dejar opinión.',
            'Si reportas un problema, suspendemos la cuenta del proveedor mientras revisamos.',
            'Puedes borrar tu cuenta cuando quieras.',
          ]),
        ], gap: 10),
      ),
      FoldK(
        k: 'lg-term',
        title: 'Leer los términos completos',
        summary: '6 secciones · vigentes desde el 15 de sep 2026',
        icon: 'doc',
        child: _legal(context, const [
          (
            '1. Qué es Knock',
            'Knock es una plataforma que pone en contacto a personas que necesitan un servicio de mecánica automotriz, plomería o electricidad con proveedores independientes. Knock no presta esos servicios ni es parte del acuerdo entre cliente y proveedor.',
          ),
          (
            '2. Tu cuenta',
            'Te registras con tu número de celular. Eres responsable de mantenerlo actualizado y de no compartir tus códigos de acceso.',
          ),
          (
            '3. Cotizaciones y acuerdos',
            'Las cotizaciones son estimaciones del proveedor y pueden cambiar si el trabajo no coincide con la descripción. El pago se acuerda y realiza fuera de Knock.',
          ),
          (
            '4. Opiniones',
            'Solo pueden opinar clientes con un servicio registrado en Knock. Retiramos opiniones con insultos, datos personales o contenido falso.',
          ),
          (
            '5. Conducta y reportes',
            'Podemos suspender o cerrar cuentas que pongan en riesgo a otras personas. Los reportes de seguridad se conservan el tiempo que exige la ley.',
          ),
          (
            '6. Cambios a estos términos',
            'Te avisaremos dentro de la app antes de que un cambio importante entre en vigor.',
          ),
        ], 'Vigentes desde el 15 de septiembre de 2026'),
      ),
    ]),
  );
}

// ------------------------------------------------------------ privacidad y datos

class PrivacidadScreen extends StatelessWidget {
  const PrivacidadScreen({super.key, this.sesiones = false});
  final bool sesiones;
  @override
  Widget build(BuildContext context) => MaqBuilder((context) {
    final k = kc(context);
    const cons = [
      ('Promociones y novedades', 'Ofertas de expertos y noticias de Knock'),
      (
        'Encuestas para mejorar Knock',
        'Preguntas cortas después de un servicio',
      ),
      ('Recomendaciones personalizadas', 'Sugerencias según tu casa y tu auto'),
    ];
    return Pg(
      title: sesiones ? 'Sesiones y datos' : 'Privacidad y datos',
      body: stack([
        const _Gl('Tus datos'),
        GroupK([
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              spacing: 14,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: k.navySoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icn('download'), color: k.navy),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const T('Descargar mis datos', w: FontWeight.w800),
                      sMut('Te mandamos un archivo en 48 horas', size: 13.5),
                    ],
                  ),
                ),
                BtnK(
                  'Pedir',
                  () => maq.toast('Te enviaremos tu archivo en 48 horas'),
                  kind: Bk.sec,
                  sm: true,
                  auto: true,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              spacing: 14,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: k.navySoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icn('edit'), color: k.navy),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const T('Corregir mis datos', w: FontWeight.w800),
                      sMut('Nombre, dirección o foto', size: 13.5),
                    ],
                  ),
                ),
                BtnK(
                  'Editar',
                  () => editarDatos(context),
                  kind: Bk.sec,
                  sm: true,
                  auto: true,
                ),
              ],
            ),
          ),
        ]),
        const _Gl('Tú decides'),
        GroupK([
          for (var i = 0; i < cons.length; i++)
            _swRow(cons[i].$1, cons[i].$2, maq.cons[i], () {
              maq.cons[i] = !maq.cons[i];
              maq.refresh();
            }),
        ]),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            sMut('Lo necesario para darte el servicio no se puede apagar. '),
            InkWell(
              onTap: () => context.push(RM.aviso),
              child: T(
                'Ver aviso de privacidad',
                size: 14,
                w: FontWeight.w800,
                color: k.navy,
              ),
            ),
          ],
        ),
        const _Gl('Dónde está abierta tu cuenta'),
        const SesionesAbiertas(),
      ]),
    );
  });
}

// ------------------------------------------------------------ eliminar cuenta

class Eliminar1Screen extends StatefulWidget {
  const Eliminar1Screen({super.key});
  @override
  State<Eliminar1Screen> createState() => _Eliminar1State();
}

class _Eliminar1State extends State<Eliminar1Screen> {
  int? o;
  @override
  Widget build(BuildContext context) {
    final k = kc(context);
    const ops = [
      'Ya no lo necesito',
      'No encontré expertos en mi zona',
      'Tuve un mal servicio',
      'Me preocupa mi privacidad',
      'Otro motivo',
    ];
    final pend = maq.pendingItems();
    return Pg(
      title: 'Eliminar cuenta',
      body: stack([
        const Prog(1, 2),
        h1('Antes de irte, esto es lo que pasa'),
        if (pend.isNotEmpty)
          CardK(
            outline: k.amber,
            child: stack([
              h3('Lo que tienes pendiente'),
              for (final t in pend)
                Row(
                  spacing: 12,
                  children: [
                    Icon(icn('clock')),
                    Expanded(child: T(t, size: 15.5, w: FontWeight.w700)),
                  ],
                ),
              rich(
                'Al eliminar, **cancelamos lo pendiente** y avisamos a las personas involucradas.',
                size: 14,
                color: k.mut,
              ),
            ], gap: 8),
          ),
        CardK(
          child: stack([
            T(
              'Se borra para siempre',
              size: 17,
              w: FontWeight.w900,
              color: k.red,
            ),
            for (final t in const [
              'Tu perfil y tu foto',
              'Tu historial de trabajos',
              'Tus mensajes',
              'Mi casa y mi auto, y tus técnicos de confianza',
            ])
              Row(
                spacing: 12,
                children: [
                  Icon(icn('x')),
                  Expanded(child: T(t, size: 15.5, w: FontWeight.w700)),
                ],
              ),
          ], gap: 8),
        ),
        const NoteK(
          'blue',
          'star',
          'Tus opiniones se conservan, pero **sin tu nombre** (aparecen como «Usuario eliminado»).',
        ),
        const NoteK(
          'blue',
          'clock',
          'Tienes **7 días para arrepentirte**: la eliminación se completa al terminar ese plazo. Los reportes de seguridad se conservan solo el tiempo que obliga la ley.',
        ),
        stack([
          Row(
            spacing: 6,
            children: [
              labT('¿Por qué te vas?'),
              T('(opcional)', size: 15, w: FontWeight.w700, color: k.mut),
            ],
          ),
          for (var i = 0; i < ops.length; i++)
            ChoiceK(
              on: o == i,
              minH: 56,
              title: ops[i],
              onTap: () => setState(() => o = i),
            ),
        ], gap: 8),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const T('¿Solo quieres menos avisos? '),
            InkWell(
              onTap: () => context.push(RM.avisosConfig),
              child: T('Ajusta tus avisos', w: FontWeight.w800, color: k.navy),
            ),
          ],
        ),
      ]),
      cta: ctaCol([
        BtnK('Continuar', () => context.push(RM.eliminar2), kind: Bk.dark),
        BtnK('Mejor no', () => context.pop(), kind: Bk.ghost),
      ]),
    );
  }
}

class Eliminar2Screen extends ConsumerStatefulWidget {
  const Eliminar2Screen({super.key});
  @override
  ConsumerState<Eliminar2Screen> createState() => _Eliminar2State();
}

class _Eliminar2State extends ConsumerState<Eliminar2Screen> {
  final _c = TextEditingController();
  bool sent = false;
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ok = sent && digits(_c.text).length == 6;
    final pend = maq.pendingItems().isNotEmpty;
    return Pg(
      title: 'Eliminar cuenta',
      body: stack([
        const Prog(2, 2),
        h1('¿Seguro que quieres eliminar tu cuenta?'),
        rich(
          'Tu cuenta quedará programada para eliminarse en **7 días** y puedes cancelarlo antes.',
          w: FontWeight.w400,
        ),
        if (sent)
          FieldK(
            label: 'Escribe el código que te enviamos por SMS',
            c: _c,
            hint: '••••••',
            keyboard: TextInputType.number,
            maxLen: 6,
            center: true,
            help:
                'Lo mandamos al +52 ${maq.user.phone}. En esta demostración sirve cualquier código de 6 números.',
            onChanged: (_) => setState(() {}),
          )
        else ...[
          rich(
            'Por seguridad, confirma con un código por SMS al **+52 ${maq.user.phone}**.',
            w: FontWeight.w400,
          ),
          BtnK(
            'Enviarme el código',
            () => setState(() => sent = true),
            kind: Bk.sec,
          ),
        ],
      ]),
      cta: ctaCol([
        BtnK(
          pend ? 'Cancelar lo pendiente y eliminar' : 'Eliminar mi cuenta',
          ok
              ? () {
                  maq.scheduleDelete();
                  context.go(RM.eliminado);
                }
              : null,
          kind: Bk.danger,
        ),
        BtnK('Mejor no', () => context.go('/cuenta'), kind: Bk.ghost),
      ]),
    );
  }
}

class EliminadoScreen extends ConsumerWidget {
  const EliminadoScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => MaqBuilder((context) {
    final k = kc(context);
    final pending = maq.delAt != null;
    return Pg(
      noHeader: true,
      scroll: false,
      body: stateK(
        pending ? Icons.schedule : Icons.check,
        pending ? k.amberSoft : k.navySoft,
        pending ? k.amberInk : k.navy,
        pending
            ? 'Tu cuenta se eliminará el ${longDate(maq.delAt!)}'
            : 'Tu cuenta fue eliminada',
        [
          if (pending) ...[
            rich(
              'Cancelamos lo pendiente y avisamos a las personas involucradas. Tienes **7 días para arrepentirte**: si entras antes de esa fecha, puedes cancelar la eliminación.',
              w: FontWeight.w400,
              align: TextAlign.center,
              color: k.mut,
            ),
            mutT(
              'Al terminar el plazo borramos tu perfil, tu historial y tus mensajes. Tus opiniones se conservan sin tu nombre.',
              a: TextAlign.center,
            ),
          ] else ...[
            mutT(
              'Borramos tu perfil, tu historial y tus mensajes. Tus opiniones quedaron sin tu nombre y los reportes de seguridad se conservan solo el tiempo que exige la ley.',
              a: TextAlign.center,
            ),
            mutT(
              'Si algún día necesitas a alguien de confianza, aquí estaremos.',
              a: TextAlign.center,
            ),
          ],
        ],
      ),
      cta: ctaCol([
        if (pending)
          BtnK('Cancelar la eliminación', () {
            maq.cancelDelete();
            context.go('/cuenta');
            maq.toast('Cancelaste la eliminación de tu cuenta');
          }),
        BtnK('Salir', () async {
          await ref.read(perfilControllerProvider.notifier).cerrarSesion();
          await maq.olvidarTelefono(ref.read(almacenSeguroProvider));
          if (!pending) maq.resetAll();
        }, kind: pending ? Bk.ghost : Bk.sec),
      ]),
    );
  });
}

// ------------------------------------------------------------ ayuda

class AyudaScreen extends StatefulWidget {
  const AyudaScreen({super.key, this.tema = 1});
  final int tema;
  @override
  State<AyudaScreen> createState() => _AyudaState();
}

class _AyudaState extends State<AyudaScreen> {
  late int t = widget.tema;
  int open = 0;
  @override
  Widget build(BuildContext context) {
    final k = kc(context);
    final f = faq[t];
    return Pg(
      title: 'Centro de ayuda',
      body: stack([
        h2('¿Sobre qué tienes dudas?'),
        chipsWrap([
          for (var i = 0; i < faq.length; i++)
            ChipK(
              faq[i].$1,
              icon: null,
              on: t == i,
              onTap: () => setState(() {
                t = i;
                open = 0;
              }),
            ),
        ]),
        GroupK([
          for (var i = 0; i < f.$3.length; i++)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                  onTap: () => setState(() => open = open == i ? -1 : i),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Row(
                      spacing: 10,
                      children: [
                        Expanded(child: T(f.$3[i].$1, w: FontWeight.w800)),
                        Icon(open == i ? Icons.expand_less : Icons.expand_more),
                      ],
                    ),
                  ),
                ),
                if (open == i)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: T(
                      f.$3[i].$2,
                      size: 15.5,
                      w: FontWeight.w600,
                      color: k.ink2,
                    ),
                  ),
              ],
            ),
        ]),
        sMut('¿No encontraste tu respuesta?', a: TextAlign.center),
      ]),
      cta: ctaCol([
        BtnK(
          'Hablar con soporte',
          () => maq.toast('Abriendo el chat de soporte…'),
          kind: Bk.sec,
          icon: 'chat',
        ),
        helpT('Lunes a sábado de 8:00 a 20:00'),
      ]),
    );
  }
}

class SinConexionScreen extends StatefulWidget {
  const SinConexionScreen({super.key});
  @override
  State<SinConexionScreen> createState() => _SinConexionState();
}

class _SinConexionState extends State<SinConexionScreen> {
  bool trying = false;
  @override
  Widget build(BuildContext context) {
    final k = kc(context);
    return Pg(
      noHeader: true,
      scroll: false,
      body: stateK(Icons.wifi_off, k.surface2, k.mut, 'No hay internet', [
        mutT(
          'Revisa tus datos o tu wifi. Lo que escribiste está guardado y se enviará cuando vuelva la señal.',
          a: TextAlign.center,
        ),
      ]),
      cta: BtnK(
        trying ? 'Intentando…' : 'Volver a intentar',
        trying
            ? null
            : () {
                setState(() => trying = true);
                Timer(const Duration(milliseconds: 1500), () {
                  if (!mounted) return;
                  setState(() => trying = false);
                  maq.toast('Ya hay conexión');
                  context.pop();
                });
              },
        kind: Bk.sec,
      ),
    );
  }
}
