import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/features/tecnico/data/horarios_repository_api.dart';
import 'package:app/features/tecnico/data/buscar_tecnicos_repository_api.dart';
import 'package:app/features/tecnico/data/perfil_publico_repository_api.dart';
import 'package:app/features/tecnico/data/servicios_repository_api.dart';
import 'package:app/features/tecnico/data/tecnico_repository_api.dart';
import 'package:app/features/tecnico/domain/alta_tecnico.dart';
import 'package:app/features/tecnico/domain/horarios.dart';
import 'package:app/features/tecnico/domain/perfil_publico.dart';
import 'package:app/features/tecnico/domain/servicios.dart';
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

/// Servicios y precios de referencia (spec 037).
final serviciosRepositoryProvider = Provider<ServiciosRepository>(
  (ref) => ServiciosRepositoryApi(
    transporte: ref.watch(transporteApiProvider),
    url: ref.watch(urlApiProvider),
  ),
);

/// Perfil público, servicios, colonia y fotos (specs 036 y 037).
final perfilPublicoRepositoryProvider = Provider<PerfilPublicoRepository>(
  (ref) => PerfilPublicoRepositoryApi(
    transporte: ref.watch(transporteApiProvider),
    url: ref.watch(urlApiProvider),
  ),
);

final buscarTecnicosRepositoryProvider = Provider<BuscarTecnicosRepositoryApi>(
  (ref) => BuscarTecnicosRepositoryApi(
    transporte: ref.watch(transporteApiProvider),
    url: ref.watch(urlApiProvider),
  ),
);
