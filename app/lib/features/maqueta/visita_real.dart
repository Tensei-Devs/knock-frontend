import 'package:app/core/errores/failure.dart';
import 'package:app/features/actividad/actividad.dart' as act;
import 'package:app/features/maqueta/carga_k.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/solicitudes_reales.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// La visita o cita real de una solicitud con una cotización ya elegida
/// (`GET /visitas/{id}`, spec 016 y backend 022): carga, error con Reintentar y
/// datos. Con los datos, los pasa a la [Job] de la maqueta para que las
/// pantallas de visita y de cita dibujen lo del servidor.
class VisitaRealGate extends ConsumerWidget {
  const VisitaRealGate({
    super.key,
    required this.job,
    required this.titulo,
    required this.cuerpo,
  });

  final Job job;
  final String titulo;

  /// La pantalla de la maqueta, ya con la [Job] actualizada.
  final WidgetBuilder cuerpo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = job.visitaId!;
    return ref
        .watch(act.visitaRealProvider(id))
        .when(
          loading: () => Pg(
            title: titulo,
            body: const Center(
              child: CargaK(tipo: TipoCarga.buscando, size: 150),
            ),
          ),
          error: (e, _) => Pg(
            title: titulo,
            body: CardK(
              child: Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: T(
                      textoDeErrorReal(e),
                      size: 14,
                      w: FontWeight.w800,
                      color: kc(context).red,
                    ),
                  ),
                  if (e is! NoEncontradoFailure)
                    BtnK(
                      'Reintentar',
                      () => ref.invalidate(act.visitaRealProvider(id)),
                      kind: Bk.sec,
                      sm: true,
                      auto: true,
                    ),
                ],
              ),
            ),
          ),
          data: (v) {
            aplicarVisitaAlJob(job, v);
            return cuerpo(context);
          },
        );
  }
}

/// Por qué no se muestra el código de la visita, sin códigos HTTP (CA-12).
String textoDeMotivoDeCodigo(String? motivo) => switch (motivo) {
  'usado' => 'Tu código ya se usó: el técnico confirmó su llegada.',
  'vencido' => 'Tu código venció.',
  'bloqueada' =>
    'La visita se bloqueó por varios intentos fallidos con el código.',
  'no_aplica' => 'Esta visita no usa código: es en el taller.',
  _ => 'Tu código no está disponible por ahora.',
};
