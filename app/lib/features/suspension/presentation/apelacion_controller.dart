import 'package:app/core/errores/failure.dart';
import 'package:app/core/sesion/sesion_provider.dart';
import 'package:app/core/sesion/verificador_celular.dart';
import 'package:app/features/suspension/suspension_providers.dart';
import 'package:app/features/suspension/domain/apelacion_suspension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PasoDeApelacion {
  celular,
  codigo,

  /// Ya hay `idToken`, pero la consulta falló: se puede repetir.
  consulta,

  /// La consulta respondió 404: puede que aún no haya apelado.
  formulario,
  estado,

  /// El envío respondió 404 (CA-E03).
  noDisponible,

  /// El envío respondió 409 `appeal_not_allowed`.
  noPermitida,
}

@immutable
class ApelacionUiState {
  const ApelacionUiState({
    this.paso = PasoDeApelacion.celular,
    this.cargando = false,
    this.falla,
    this.apelacion,
  });

  final PasoDeApelacion paso;
  final bool cargando;
  final Failure? falla;
  final ApelacionDeSuspension? apelacion;
}

/// Verifica el número por SMS y usa ese `idToken` para las dos rutas. El token
/// solo vive en memoria mientras la pantalla está abierta; no abre sesión.
class ApelacionController extends Notifier<ApelacionUiState> {
  SolicitudCodigo? _solicitud;
  String? _idToken;

  @override
  ApelacionUiState build() => const ApelacionUiState();

  VerificadorCelular get _verificador => ref.read(verificadorCelularProvider);

  Future<void> enviarCodigo(String celular) => _intentar(() async {
    _solicitud = await _verificador.enviarCodigo(celular);
    return const ApelacionUiState(paso: PasoDeApelacion.codigo);
  });

  Future<void> verificar(String codigo) => _intentar(() async {
    final solicitud = _solicitud;
    if (solicitud == null) throw const CodigoVencidoFailure();
    _idToken = await _verificador.tokenDeId(solicitud, codigo);
    try {
      await _verificador.cerrarSesion();
    } on Exception {
      // Sin registro: podría llevar datos.
    }
    state = const ApelacionUiState(
      paso: PasoDeApelacion.consulta,
      cargando: true,
    );
    return _consultar();
  });

  Future<void> reintentarConsulta() => _intentar(_consultar);

  Future<ApelacionUiState> _consultar() async {
    try {
      final apelacion = await ref
          .read(apelacionSuspensionRepositoryProvider)
          .consultar(_idToken!);
      return ApelacionUiState(
        paso: PasoDeApelacion.estado,
        apelacion: apelacion,
      );
    } on NoEncontradoFailure {
      return const ApelacionUiState(paso: PasoDeApelacion.formulario);
    }
  }

  Future<void> presentar(String texto) => _intentar(() async {
    try {
      final apelacion = await ref
          .read(apelacionSuspensionRepositoryProvider)
          .presentar(_idToken!, texto.trim());
      return ApelacionUiState(
        paso: PasoDeApelacion.estado,
        apelacion: apelacion,
      );
    } on NoEncontradoFailure {
      return const ApelacionUiState(paso: PasoDeApelacion.noDisponible);
    } on ApelacionNoPermitidaFailure {
      return const ApelacionUiState(paso: PasoDeApelacion.noPermitida);
    }
  });

  /// Una petición a la vez. Un 401 pide verificar el número otra vez (CA-E02).
  Future<void> _intentar(Future<ApelacionUiState> Function() accion) async {
    if (state.cargando) return;
    state = ApelacionUiState(paso: state.paso, cargando: true);
    // Sin cierre automático mientras la respuesta está en camino.
    final viva = ref.keepAlive();
    try {
      state = await accion();
    } on NoAutorizadoFailure catch (falla) {
      _idToken = null;
      _solicitud = null;
      state = ApelacionUiState(falla: falla);
    } on Failure catch (falla) {
      state = ApelacionUiState(paso: state.paso, falla: falla);
    } finally {
      viva.close();
    }
  }
}

final apelacionControllerProvider =
    NotifierProvider.autoDispose<ApelacionController, ApelacionUiState>(
      ApelacionController.new,
    );
