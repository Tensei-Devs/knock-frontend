//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class InternalAccountApi {
  InternalAccountApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Cancela las solicitudes abiertas y retira las cotizaciones pendientes de la persona, avisando a la otra parte.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] usuarioId (required):
  ///
  /// * [String] version (required):
  Future<Response> apiVversionInternoCuentasUsuarioIdCancelacionesPostWithHttpInfo(String usuarioId, String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/interno/cuentas/{usuarioId}/cancelaciones'
      .replaceAll('{usuarioId}', usuarioId)
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      abortTrigger: abortTrigger,
    );
  }

  /// Cancela las solicitudes abiertas y retira las cotizaciones pendientes de la persona, avisando a la otra parte.
  ///
  /// Parameters:
  ///
  /// * [String] usuarioId (required):
  ///
  /// * [String] version (required):
  Future<void> apiVversionInternoCuentasUsuarioIdCancelacionesPost(String usuarioId, String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionInternoCuentasUsuarioIdCancelacionesPostWithHttpInfo(usuarioId, version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Consume `CuentaEliminada`: responde 202 cuando Mercado ya cerró y anonimizó lo de la persona (repetirlo no cambia nada).
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] usuarioId (required):
  ///
  /// * [String] version (required):
  Future<Response> apiVversionInternoCuentasUsuarioIdEliminadaPostWithHttpInfo(String usuarioId, String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/interno/cuentas/{usuarioId}/eliminada'
      .replaceAll('{usuarioId}', usuarioId)
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      abortTrigger: abortTrigger,
    );
  }

  /// Consume `CuentaEliminada`: responde 202 cuando Mercado ya cerró y anonimizó lo de la persona (repetirlo no cambia nada).
  ///
  /// Parameters:
  ///
  /// * [String] usuarioId (required):
  ///
  /// * [String] version (required):
  Future<void> apiVversionInternoCuentasUsuarioIdEliminadaPost(String usuarioId, String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionInternoCuentasUsuarioIdEliminadaPostWithHttpInfo(usuarioId, version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Datos de la persona en Mercado para su exportación (un JSON).
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] usuarioId (required):
  ///
  /// * [String] version (required):
  Future<Response> apiVversionInternoCuentasUsuarioIdExportacionGetWithHttpInfo(String usuarioId, String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/interno/cuentas/{usuarioId}/exportacion'
      .replaceAll('{usuarioId}', usuarioId)
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      abortTrigger: abortTrigger,
    );
  }

  /// Datos de la persona en Mercado para su exportación (un JSON).
  ///
  /// Parameters:
  ///
  /// * [String] usuarioId (required):
  ///
  /// * [String] version (required):
  Future<void> apiVversionInternoCuentasUsuarioIdExportacionGet(String usuarioId, String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionInternoCuentasUsuarioIdExportacionGetWithHttpInfo(usuarioId, version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Citas y cotizaciones abiertas de la persona, con conteos e identificadores propios (máximo 50 por grupo).
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] usuarioId (required):
  ///
  /// * [String] version (required):
  Future<Response> apiVversionInternoCuentasUsuarioIdPendientesGetWithHttpInfo(String usuarioId, String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/interno/cuentas/{usuarioId}/pendientes'
      .replaceAll('{usuarioId}', usuarioId)
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      abortTrigger: abortTrigger,
    );
  }

  /// Citas y cotizaciones abiertas de la persona, con conteos e identificadores propios (máximo 50 por grupo).
  ///
  /// Parameters:
  ///
  /// * [String] usuarioId (required):
  ///
  /// * [String] version (required):
  Future<AccountPendingResponse?> apiVversionInternoCuentasUsuarioIdPendientesGet(String usuarioId, String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionInternoCuentasUsuarioIdPendientesGetWithHttpInfo(usuarioId, version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AccountPendingResponse',) as AccountPendingResponse;
    
    }
    return null;
  }
}
