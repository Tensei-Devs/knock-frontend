import 'package:app/core/errores/failure.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/features/tecnico/domain/servicios.dart';
import 'package:app/features/tecnico/tecnico_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Los servicios de un técnico; [copiaDel] dice de cuándo es la copia que se
/// muestra sin conexión (`null` si viene del servidor).
typedef ServiciosVistos = ({List<ServicioTecnico> items, DateTime? copiaDel});

/// La última respuesta buena de cada técnico, solo en memoria. Se vacía al
/// abrir o cerrar una sesión.
final copiaDeServiciosProvider =
    Provider<Map<String, ({List<ServicioTecnico> items, DateTime fecha})>>((
      ref,
    ) {
      ref.watch(sesionProvider.select((tokens) => tokens != null));
      return {};
    });

/// Lo que ve un cliente en el perfil de un técnico (SRV-01).
final serviciosDeTecnicoProvider = FutureProvider.autoDispose
    .family<ServiciosVistos, String>((ref, id) async {
      ref.watch(sesionProvider.select((tokens) => tokens != null));
      final copias = ref.watch(copiaDeServiciosProvider);
      try {
        final items = await ref
            .watch(serviciosRepositoryProvider)
            .deTecnico(id);
        copias[id] = (items: items, fecha: DateTime.now());
        return (items: items, copiaDel: null);
      } on ServicioNoDisponibleFailure {
        final copia = copias[id];
        if (copia == null) rethrow;
        return (items: copia.items, copiaDel: copia.fecha);
      } on NoEncontradoFailure {
        copias.remove(id);
        rethrow;
      }
    }, retry: (_, _) => null);

/// El id de técnico de la cuenta, si la app ya lo conoce. El contrato no tiene
/// una ruta para pedirlo: solo llega al crear el perfil. Se olvida al abrir o
/// cerrar una sesión.
class MiTecnicoId extends Notifier<String?> {
  @override
  String? build() {
    ref.watch(sesionProvider.select((tokens) => tokens != null));
    return null;
  }

  void recordar(String id) => state = id;
}

final miTecnicoIdProvider = NotifierProvider<MiTecnicoId, String?>(
  MiTecnicoId.new,
);

/// Los servicios propios. [listaCompleta] es falso cuando la app no conoce el
/// id de técnico: entonces solo están los cambios hechos desde que se abrió.
typedef MisServicios = ({List<ServicioTecnico> items, bool listaCompleta});

class MisServiciosController extends AsyncNotifier<MisServicios> {
  @override
  Future<MisServicios> build() async {
    ref.watch(sesionProvider.select((tokens) => tokens != null));
    final id = ref.watch(miTecnicoIdProvider);
    if (id == null) {
      return (items: const <ServicioTecnico>[], listaCompleta: false);
    }
    final items = await ref.watch(serviciosRepositoryProvider).deTecnico(id);
    return (items: items, listaCompleta: true);
  }

  void reintentar() => ref.invalidateSelf();

  /// Agrega o, con [id], edita. Los errores que no son un rechazo conocido
  /// llegan como `Failure`.
  Future<RechazoDeServicio?> guardar(
    DatosDeServicio datos, {
    String? id,
  }) async {
    final repo = ref.read(serviciosRepositoryProvider);
    final r = id == null
        ? await repo.agregar(datos)
        : await repo.editar(id, datos);
    final guardado = r.servicio;
    if (guardado != null) {
      _cambiar(
        (items) => id == null
            ? [...items, guardado]
            : [for (final s in items) s.id == id ? guardado : s],
      );
    } else if (r.rechazo == RechazoDeServicio.noExiste && id != null) {
      _sacar(id);
    }
    return r.rechazo;
  }

  Future<RechazoDeServicio?> quitar(String id) async {
    final rechazo = await ref.read(serviciosRepositoryProvider).quitar(id);
    if (rechazo != RechazoDeServicio.sinPerfilDeTecnico) _sacar(id);
    return rechazo;
  }

  void _sacar(String id) => _cambiar(
    (items) => [
      for (final s in items)
        if (s.id != id) s,
    ],
  );

  void _cambiar(
    List<ServicioTecnico> Function(List<ServicioTecnico>) transformar,
  ) {
    final actual = state.value;
    if (actual == null) return;
    state = AsyncData((
      items: transformar(actual.items),
      listaCompleta: actual.listaCompleta,
    ));
  }
}

/// Sin reintento automático: la persona decide con Reintentar.
final misServiciosControllerProvider =
    AsyncNotifierProvider<MisServiciosController, MisServicios>(
      MisServiciosController.new,
      retry: (_, _) => null,
    );
