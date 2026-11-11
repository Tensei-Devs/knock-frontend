import 'package:app/core/preferencias/almacen_borrador_solicitud.dart';
import 'package:app/core/preferencias/almacen_preferencias.dart';
import 'package:app/core/preferencias/directorio_fotos_borrador.dart';
import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/features/actividad/data/borrador_repository.dart';
import 'package:app/features/actividad/data/fuente_de_fotos_sistema.dart';
import 'package:app/features/actividad/data/solicitud_repository_de_prueba.dart';
import 'package:app/features/actividad/domain/solicitud_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Raíz de composición de la función Actividad (spec 015): es lo único que
/// junta `data/` con el resto, para que `presentation/` no importe `data/`.

/// Solicitudes. Mientras el contrato no tenga `/solicitudes` ni `/archivos`
/// (backend 020 y spec 013), es la implementación en memoria; el PR de
/// KNOCK-244 sigue en borrador hasta conectar el cliente generado aquí.
final solicitudRepositoryProvider = Provider<SolicitudRepository>(
  (ref) => SolicitudRepositoryDePrueba(),
);

/// Borrador del formulario y copias privadas de sus fotos (R-07).
final borradorSolicitudRepositoryProvider =
    Provider<BorradorSolicitudRepository>((ref) {
      final Object almacen = ref.watch(almacenPreferenciasProvider);
      return BorradorRepository(
        almacen: almacen is AlmacenBorradorSolicitud
            ? almacen
            : AlmacenPreferenciasEnMemoria(),
        directorioFotos: ref.watch(directorioFotosBorradorProvider),
      );
    });

/// Cámara y selector del sistema (D-12).
final fuenteDeFotosProvider = Provider<FuenteDeFotos>(
  (ref) => FuenteDeFotosSistema(),
);

/// «Pedir cotización» solo se ofrece fuera de release mientras la solicitud
/// use datos en memoria: en una versión publicada crearía solicitudes falsas.
final pedirCotizacionDisponibleProvider = Provider<bool>(
  (ref) => !ref.watch(modoReleaseProvider),
);

/// Identificador de colonia ficticio de la versión de prueba.
const coloniaDePrueba = '000000000000000000000001';

/// `coloniaId` de la zona guardada (R-05). La zona la define la spec 017, que
/// aún no está en la app: en release es `null` (la pantalla pide elegir la
/// zona y no envía); fuera de release, una colonia ficticia para la demo.
final coloniaGuardadaProvider = Provider<String?>(
  (ref) => ref.watch(modoReleaseProvider) ? null : coloniaDePrueba,
);

/// Dominios de los que se pintan fotos (CA-21). Vacío hasta que backend 020 y
/// la spec 013 fijen el dominio de los enlaces firmados: sin dominio no se
/// carga ninguna foto remota.
final dominiosDeFotosProvider = Provider<Set<String>>((ref) => const {});

/// Reloj de la pantalla (las pruebas lo fijan).
final relojSolicitudProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);

/// Si ya existe la pantalla de la visita (spec 016, KNOCK-83). Mientras sea
/// falso, «Ver mi visita» no se muestra: no hay botones sin destino.
final visitaDisponibleProvider = Provider<bool>((ref) => false);
