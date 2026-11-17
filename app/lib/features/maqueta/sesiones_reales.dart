import 'package:app/core/errores/failure.dart';
import 'package:app/features/cuenta/presentation/sesiones_controller.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// «Dónde está abierta tu cuenta»: las sesiones reales de la cuenta
/// (`GET /me/sesiones`, `DELETE /me/sesiones/{id}`; specs 026 y 029). Con
/// carga, error con Reintentar y cierre de las demás sesiones; la de este
/// teléfono no se puede cerrar desde aquí.
class SesionesAbiertas extends ConsumerWidget {
  const SesionesAbiertas({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final k = kc(context);
    final estado = ref.watch(sesionesControllerProvider);
    final controlador = ref.read(sesionesControllerProvider.notifier);
    return GroupK([
      ...estado.when(
        loading: () => [_aviso(sMut('Cargando tus sesiones…'))],
        error: (_, _) => [
          _aviso(
            Row(
              spacing: 12,
              children: [
                Expanded(
                  child: T(
                    'No pudimos cargar tus sesiones.',
                    size: 14,
                    w: FontWeight.w800,
                    color: k.red,
                  ),
                ),
                BtnK(
                  'Reintentar',
                  controlador.reintentar,
                  kind: Bk.sec,
                  sm: true,
                  auto: true,
                ),
              ],
            ),
          ),
        ],
        data: (sesiones) => [
          if (sesiones.isEmpty)
            _aviso(sMut('No encontramos sesiones abiertas.')),
          for (final s in sesiones)
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
                    child: Icon(icn(s.actual ? 'phone' : 'doc'), color: k.navy),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        T(s.dispositivo, w: FontWeight.w800),
                        sMut(
                          s.actual
                              ? 'Este celular · ${haceTiempo(s.ultimaActividad)}'
                              : haceTiempo(s.ultimaActividad),
                          size: 13.5,
                        ),
                      ],
                    ),
                  ),
                  if (s.actual)
                    const Pill('Aquí', kind: 'green')
                  else
                    BtnK(
                      'Cerrar',
                      () async {
                        final fallo = await controlador.cerrar(s.id);
                        maq.toast(
                          fallo == null
                              ? 'Cerramos esa sesión'
                              : _textoDeError(fallo),
                        );
                      },
                      kind: Bk.sec,
                      sm: true,
                      auto: true,
                    ),
                ],
              ),
            ),
        ],
      ),
    ]);
  }

  Widget _aviso(Widget hijo) =>
      Padding(padding: const EdgeInsets.all(16), child: hijo);

  /// Sin códigos HTTP ni URL (spec 026, R-11).
  static String _textoDeError(Failure f) => switch (f) {
    ConflictoFailure() =>
      'Esa es la sesión de este celular. Para salir usa «Cerrar sesión».',
    NoAutorizadoFailure() => 'Tu sesión venció. Entra de nuevo.',
    _ => 'No pudimos cerrar la sesión. Inténtalo de nuevo.',
  };
}

/// «hace 3 días», «hace 2 horas»… a partir de la última actividad.
String haceTiempo(DateTime momento, {DateTime? ahora}) {
  final d = (ahora ?? DateTime.now()).difference(momento);
  if (d.inMinutes < 2) return 'hace un momento';
  if (d.inMinutes < 60) return 'hace ${d.inMinutes} minutos';
  if (d.inHours < 24) {
    return d.inHours == 1 ? 'hace 1 hora' : 'hace ${d.inHours} horas';
  }
  return d.inDays == 1 ? 'hace 1 día' : 'hace ${d.inDays} días';
}
