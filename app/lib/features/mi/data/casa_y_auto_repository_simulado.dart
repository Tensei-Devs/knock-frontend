import 'package:app/core/errores/failure.dart';
import 'package:app/features/mi/domain/casa_y_auto.dart';

/// SIMULADO (spec 031, D-01): mismas reglas que el backend 041, en memoria y
/// solo fuera de `release`. Arranca vacío; no guarda nada en el teléfono.
class CasaYAutoRepositorySimulado implements CasaYAutoRepository {
  CasaYAutoRepositorySimulado({DateTime Function()? reloj})
    : _reloj = reloj ?? DateTime.now;

  final DateTime Function() _reloj;
  final List<ElementoCasa> _elementos = [];
  var _siguienteId = 1;

  @override
  Future<List<ElementoCasa>> listar() async => List.unmodifiable(_elementos);

  @override
  Future<ElementoCasa> agregar({
    required TipoElemento tipo,
    required String nombre,
    int? anio,
  }) async {
    _validar(tipo, nombre, anio);
    if (_elementos.length >= ReglasElemento.maximoElementos) {
      throw const ConflictoFailure();
    }
    final elemento = ElementoCasa(
      id: 'simulado-${_siguienteId++}',
      tipo: tipo,
      nombre: nombre.trim(),
      anio: tipo == TipoElemento.auto ? anio : null,
      creadoEn: _reloj().toUtc(),
    );
    _elementos.insert(0, elemento);
    return elemento;
  }

  @override
  Future<ElementoCasa> editar(
    String id, {
    required TipoElemento tipo,
    required String nombre,
    int? anio,
  }) async {
    _validar(tipo, nombre, anio);
    final i = _elementos.indexWhere((e) => e.id == id);
    if (i < 0) throw const NoEncontradoFailure();
    final editado = ElementoCasa(
      id: id,
      tipo: tipo,
      nombre: nombre.trim(),
      anio: tipo == TipoElemento.auto ? anio : null,
      creadoEn: _elementos[i].creadoEn,
    );
    _elementos[i] = editado;
    return editado;
  }

  @override
  Future<void> quitar(String id) async {
    final antes = _elementos.length;
    _elementos.removeWhere((e) => e.id == id);
    if (_elementos.length == antes) throw const NoEncontradoFailure();
  }

  @override
  Future<PaginaHistorial> historial(String id, {String? cursor}) async {
    if (_elementos.every((e) => e.id != id)) throw const NoEncontradoFailure();
    return const PaginaHistorial(trabajos: []);
  }

  void _validar(TipoElemento tipo, String nombre, int? anio) {
    final campo = ReglasElemento.validar(
      tipo: tipo,
      nombre: nombre,
      anio: anio,
      hoy: _reloj(),
    );
    if (campo != null) throw const DatosRechazadosFailure();
  }
}
