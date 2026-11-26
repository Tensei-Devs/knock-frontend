import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/features/tecnico/data/horarios_repository_api.dart';
import 'package:app/features/tecnico/data/tecnico_repository_api.dart';
import 'package:app/features/tecnico/domain/alta_tecnico.dart';
import 'package:app/features/tecnico/domain/horarios.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Repositorio del alta de técnico (spec 036). La pantalla solo lo usa con
/// sesión y `KNOCK_API_URL` válida; sin ellas la maqueta sigue con su flujo de
/// ejemplo.
final tecnicoRepositoryProvider = Provider<TecnicoRepository>(
  (ref) => TecnicoRepositoryApi(
    transporte: ref.watch(transporteApiProvider),
    url: ref.watch(urlApiProvider),
  ),
);

/// Horarios y «Disponible hoy» (spec 036).
final horariosRepositoryProvider = Provider<HorariosRepository>(
  (ref) => HorariosRepositoryApi(
    transporte: ref.watch(transporteApiProvider),
    url: ref.watch(urlApiProvider),
  ),
);
