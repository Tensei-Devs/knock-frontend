import 'package:app/core/errores/failure.dart';
import 'package:app/core/sesion/servicio_entrada.dart';
import 'package:app/core/sesion/sesion_provider.dart';
import 'package:app/core/sesion/verificador_celular.dart';
import 'package:app/features/entrada/domain/validacion_entrada.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Estado de la entrada con celular (KNOCK-228).
@immutable
class EntradaUiState {
  const EntradaUiState({this.cargando = false, this.error, this.solicitud});

  /// Se está pidiendo o verificando el código.
  final bool cargando;

  /// Último error, para mostrar su mensaje del ARB.
  final Failure? error;

  /// Código pedido; sin él no se puede verificar ni reenviar.
  final SolicitudCodigo? solicitud;

  EntradaUiState copyWith({
    bool? cargando,
    Failure? error,
    bool limpiarError = false,
    SolicitudCodigo? solicitud,
  }) => EntradaUiState(
    cargando: cargando ?? this.cargando,
    error: limpiarError ? null : (error ?? this.error),
    solicitud: solicitud ?? this.solicitud,
  );
}

/// Pide el SMS, lo verifica y canjea la sesión con la API.
///
/// El celular y el código solo pasan por memoria; no se guardan ni se
/// registran. Los tokens los guarda el servicio en almacenamiento seguro.
class EntradaController extends Notifier<EntradaUiState> {
  @override
  EntradaUiState build() => const EntradaUiState();

  ServicioEntrada get _servicio => ref.read(servicioEntradaProvider);

  /// Devuelve `true` si el SMS salió y se puede pasar a escribir el código.
  Future<bool> enviarCodigo(String celular) async {
    if (state.cargando) return false;
    if (!esCelularValido(celular)) {
      state = state.copyWith(error: const CelularRechazadoFailure());
      return false;
    }
    state = const EntradaUiState(cargando: true);
    try {
      final solicitud = await _servicio.enviarCodigo(celular);
      state = EntradaUiState(solicitud: solicitud);
      return true;
    } on Failure catch (error) {
      state = EntradaUiState(error: error);
      return false;
    }
  }

  /// Pide otro SMS para el mismo celular.
  Future<bool> reenviar() async {
    final anterior = state.solicitud;
    if (state.cargando || anterior == null) return false;
    state = state.copyWith(cargando: true, limpiarError: true);
    try {
      final solicitud = await _servicio.enviarCodigo(
        anterior.celular,
        anterior: anterior,
      );
      state = EntradaUiState(solicitud: solicitud);
      return true;
    } on Failure catch (error) {
      state = state.copyWith(cargando: false, error: error);
      return false;
    }
  }

  /// Verifica el código y, si la API emite la sesión, la marca iniciada.
  Future<ResultadoEntrada?> verificar(String codigo) async {
    final solicitud = state.solicitud;
    if (state.cargando) return null;
    if (solicitud == null) {
      state = state.copyWith(error: const CodigoVencidoFailure());
      return null;
    }
    if (!esCodigoValido(codigo)) {
      state = state.copyWith(error: const CodigoIncorrectoFailure());
      return null;
    }
    state = state.copyWith(cargando: true, limpiarError: true);
    try {
      final resultado = await _servicio.verificarCodigo(solicitud, codigo);
      state = const EntradaUiState();
      ref.read(sesionIniciadaProvider.notifier).iniciar();
      return resultado;
    } on Failure catch (error) {
      state = state.copyWith(cargando: false, error: error);
      return null;
    }
  }

  /// Quita el error mostrado (la persona volvió a escribir).
  void limpiarError() {
    if (state.error != null) state = state.copyWith(limpiarError: true);
  }
}

final entradaControllerProvider =
    NotifierProvider<EntradaController, EntradaUiState>(EntradaController.new);
