import 'package:app/features/actividad/actividad_providers.dart';
import 'package:app/features/actividad/domain/aviso.dart';
import 'package:app/features/actividad/domain/visita.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// La visita del cliente (`GET /visitas/{id}`): su código, el técnico con su
/// contacto, el lugar y el día. Se pide al abrir la pantalla y se descarta al
/// salir; sin caché y sin reintento automático (la persona decide con
/// Reintentar). El código nunca se guarda en el teléfono desde aquí.
final visitaRealProvider = FutureProvider.autoDispose.family<Visita, String>(
  (ref, id) => ref.watch(visitasRealesRepositoryProvider).obtenerVisita(id),
  retry: (_, _) => null,
);

/// El texto para avisar a alguien de confianza (`POST /visitas/{id}/aviso`):
/// lo escribe el servidor y nunca lleva el código ni la dirección (spec 022).
/// Se pide una vez al abrir la hoja y se descarta al cerrarla.
final avisoRealProvider = FutureProvider.autoDispose
    .family<MensajeAviso, String>(
      (ref, visitaId) =>
          ref.watch(avisosRealesRepositoryProvider).pedirAviso(visitaId),
      retry: (_, _) => null,
    );
