import 'package:app/features/actividad/data/ampliar_solicitud_api.dart';
import 'package:app/core/preferencias/almacen_borrador_solicitud.dart';
import 'package:app/core/preferencias/almacen_preferencias.dart';
import 'package:app/core/preferencias/directorio_fotos_borrador.dart';
import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/core/sesion/almacen_seguro.dart';
import 'package:app/features/actividad/data/aviso_local_repository.dart';
import 'package:app/features/actividad/data/borrador_repository.dart';
import 'package:app/features/actividad/data/fuente_de_fotos_sistema.dart';
import 'package:app/features/actividad/data/solicitud_repository_api.dart';
import 'package:app/features/actividad/data/solicitud_repository_de_prueba.dart';
import 'package:app/features/actividad/data/subida_de_fotos_api.dart';
import 'package:app/features/actividad/data/visita_local_repository.dart';
import 'package:app/features/actividad/data/visita_repository_api.dart';
import 'package:app/features/actividad/domain/aviso.dart';
import 'package:app/features/actividad/domain/solicitud.dart';
import 'package:app/features/actividad/domain/solicitud_repository.dart';
import 'package:app/features/actividad/domain/visita.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

/// Raíz de composición de la función Actividad (spec 015): es lo único que
/// junta `data/` con el resto, para que `presentation/` no importe `data/`.

/// Solicitudes. Mientras el contrato no tenga `/solicitudes` ni `/archivos`
/// (backend 020 y spec 013), es la implementación en memoria; el PR de
/// KNOCK-244 sigue en borrador hasta conectar el cliente generado aquí.
final solicitudRepositoryProvider = Provider<SolicitudRepository>(
  (ref) => ref.watch(_datosDePruebaProvider),
);

/// Transporte hacia el almacenamiento de las fotos (el enlace temporal). Es
/// aparte del de la API: no lleva la sesión, y un 429 del almacenamiento no
/// frena las llamadas a la API.
final transporteDeSubidasProvider = Provider<http.Client>((ref) {
  final cliente = http.Client();
  ref.onDispose(cliente.close);
  return cliente;
});

/// Solicitudes para la maqueta (spec 045, enmienda 1): la API real con
/// `KNOCK_API_URL` válida y, sin ella, el mismo doble en memoria. Es aparte de
/// [solicitudRepositoryProvider] para no cambiar las pantallas anteriores.
final solicitudesRealesRepositoryProvider = Provider<SolicitudRepository>((
  ref,
) {
  if (!usaApiReal(ref)) return ref.watch(_datosDePruebaProvider);
  return SolicitudRepositoryApi(
    transporte: ref.watch(transporteApiProvider),
    url: ref.watch(urlApiProvider),
    fotos: SubidaDeFotosApi(
      transporte: ref.watch(transporteApiProvider),
      url: ref.watch(urlApiProvider),
      almacenamiento: ref.watch(transporteDeSubidasProvider),
    ),
  );
});

/// Una sola instancia en memoria para solicitudes y visitas, para que la
/// visita salga de la cita que se eligió (backend 021 y 022).
final _datosDePruebaProvider = Provider<SolicitudRepositoryDePrueba>(
  (ref) => SolicitudRepositoryDePrueba(),
);

/// Visita y aviso de confianza para la maqueta (spec 045, enmienda 1): la API
/// real con `KNOCK_API_URL` válida y, sin ella, el mismo doble en memoria. Son
/// aparte de [visitaRepositoryProvider] y [avisoRepositoryProvider] para no
/// cambiar las pantallas anteriores.
final visitasRealesRepositoryProvider = Provider<VisitaRepository>((ref) {
  if (!usaApiReal(ref)) return ref.watch(_datosDePruebaProvider);
  return VisitaRepositoryApi(
    transporte: ref.watch(transporteApiProvider),
    url: ref.watch(urlApiProvider),
  );
});

final avisosRealesRepositoryProvider = Provider<AvisoRepository>((ref) {
  if (!usaApiReal(ref)) return ref.watch(_datosDePruebaProvider);
  return AvisoRepositoryApi(
    transporte: ref.watch(transporteApiProvider),
    url: ref.watch(urlApiProvider),
  );
});

/// Texto del aviso de confianza (backend 022 R-12), del mismo doble.
final avisoRepositoryProvider = Provider<AvisoRepository>(
  (ref) => ref.watch(_datosDePruebaProvider),
);

/// Contactos de confianza del teléfono (spec 022, R-01).
final contactosConfianzaRepositoryProvider =
    Provider<ContactosConfianzaRepository>(
      (ref) => ContactosConfianzaSeguros(ref.watch(almacenSeguroProvider)),
    );

/// Copia de los datos del aviso para avisar sin conexión (R-12).
final respaldoAvisoRepositoryProvider = Provider<RespaldoAvisoRepository>(
  (ref) => RespaldoAvisoSeguro(ref.watch(almacenSeguroProvider)),
);

/// Visitas (backend 022). Mientras no haya contrato, las mismas del doble.
final visitaRepositoryProvider = Provider<VisitaRepository>(
  (ref) => ref.watch(_datosDePruebaProvider),
);

/// Copia cifrada de la visita abierta (spec 016, R-03).
final visitaLocalRepositoryProvider = Provider<VisitaLocalRepository>(
  (ref) => VisitaLocalRepositorySeguro(ref.watch(almacenSeguroProvider)),
);

/// Si ya existe la hoja «Avisar a alguien de confianza» (spec 022,
/// KNOCK-84). Con la hoja ya construida, queda en verdadero (R-06).
final avisoDeConfianzaDisponibleProvider = Provider<bool>((ref) => true);

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

/// Cada cuánto se vuelve a pedir una solicitud que aún espera cotizaciones,
/// para que el detalle se actualice solo (sin caché, R-11). `null` apaga el
/// refresco (las pruebas lo apagan y refrescan a mano).
final intervaloRefrescoSolicitudProvider = Provider<Duration?>(
  (ref) => const Duration(seconds: 3),
);

/// Las solicitudes de la persona para la pestaña Actividad (D-03).
final solicitudesActividadProvider =
    FutureProvider.autoDispose<List<Solicitud>>(
      (ref) => ref.watch(solicitudRepositoryProvider).listar(),
    );

/// Reloj de la pantalla (las pruebas lo fijan).
final relojSolicitudProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);

/// Si ya existe la pantalla de la visita (spec 016, KNOCK-83): «Ver mi
/// visita» lleva a `/actividad/visita/:id`.
final visitaDisponibleProvider = Provider<bool>((ref) => true);

/// «Pedir también a otros» (spec 038).
final ampliarSolicitudApiProvider = Provider<AmpliarSolicitudApi>(
  (ref) => AmpliarSolicitudApi(
    transporte: ref.watch(transporteApiProvider),
    url: ref.watch(urlApiProvider),
  ),
);
