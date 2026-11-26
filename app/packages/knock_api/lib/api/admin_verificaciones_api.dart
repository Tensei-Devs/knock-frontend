//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class AdminVerificacionesApi {
  AdminVerificacionesApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// VER-03: la cola, de la más antigua a la más reciente, con cursor. Sin fotos ni datos personales.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] tipo:
  ///   identidad (default) or recuperacion.
  ///
  /// * [String] estado:
  ///   en_revision by default.
  ///
  /// * [DateTime] desde:
  ///
  /// * [DateTime] hasta:
  ///
  /// * [String] cursor:
  ///   Opaque cursor returned as nextCursor by the previous page.
  ///
  /// * [int] limite:
  ///   Page size, 1 to 50. Defaults to 20.
  Future<Response> apiVversionAdminVerificacionesGetWithHttpInfo(String version, { String? tipo, String? estado, DateTime? desde, DateTime? hasta, String? cursor, int? limite, Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/admin/verificaciones'
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (tipo != null) {
      queryParams.addAll(_queryParams('', 'tipo', tipo));
    }
    if (estado != null) {
      queryParams.addAll(_queryParams('', 'estado', estado));
    }
    if (desde != null) {
      queryParams.addAll(_queryParams('', 'desde', desde));
    }
    if (hasta != null) {
      queryParams.addAll(_queryParams('', 'hasta', hasta));
    }
    if (cursor != null) {
      queryParams.addAll(_queryParams('', 'cursor', cursor));
    }
    if (limite != null) {
      queryParams.addAll(_queryParams('', 'limite', limite));
    }

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

  /// VER-03: la cola, de la más antigua a la más reciente, con cursor. Sin fotos ni datos personales.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] tipo:
  ///   identidad (default) or recuperacion.
  ///
  /// * [String] estado:
  ///   en_revision by default.
  ///
  /// * [DateTime] desde:
  ///
  /// * [DateTime] hasta:
  ///
  /// * [String] cursor:
  ///   Opaque cursor returned as nextCursor by the previous page.
  ///
  /// * [int] limite:
  ///   Page size, 1 to 50. Defaults to 20.
  Future<VerificationQueuePage?> apiVversionAdminVerificacionesGet(String version, { String? tipo, String? estado, DateTime? desde, DateTime? hasta, String? cursor, int? limite, Future<void>? abortTrigger, }) async {
    final response = await apiVversionAdminVerificacionesGetWithHttpInfo(version, tipo: tipo, estado: estado, desde: desde, hasta: hasta, cursor: cursor, limite: limite, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'VerificationQueuePage',) as VerificationQueuePage;
    
    }
    return null;
  }

  /// VER-05: aprueba o rechaza con motivo; destruye la llave de las fotos (identidad) o cambia el número (recuperación). 404, 409 `verification_already_decided`, 503 `audit_unavailable`.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [VerificationDecisionBody] verificationDecisionBody (required):
  Future<Response> apiVversionAdminVerificacionesIdDecisionPostWithHttpInfo(String id, String version, VerificationDecisionBody verificationDecisionBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/admin/verificaciones/{id}/decision'
      .replaceAll('{id}', id)
      .replaceAll('{version}', version);

    Object? postBody = verificationDecisionBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json', 'text/json', 'application/*+json'];


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

  /// VER-05: aprueba o rechaza con motivo; destruye la llave de las fotos (identidad) o cambia el número (recuperación). 404, 409 `verification_already_decided`, 503 `audit_unavailable`.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [VerificationDecisionBody] verificationDecisionBody (required):
  Future<VerificationDecisionResult?> apiVversionAdminVerificacionesIdDecisionPost(String id, String version, VerificationDecisionBody verificationDecisionBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionAdminVerificacionesIdDecisionPostWithHttpInfo(id, version, verificationDecisionBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'VerificationDecisionResult',) as VerificationDecisionResult;
    
    }
    return null;
  }

  /// VER-04: abre una verificación; entrega enlaces de 5 minutos a las fotos y registra quién los abrió. 404 `verification_not_found`; 410 `photos_destroyed`.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  Future<Response> apiVversionAdminVerificacionesIdGetWithHttpInfo(String id, String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/admin/verificaciones/{id}'
      .replaceAll('{id}', id)
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

  /// VER-04: abre una verificación; entrega enlaces de 5 minutos a las fotos y registra quién los abrió. 404 `verification_not_found`; 410 `photos_destroyed`.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  Future<VerificationDetail?> apiVversionAdminVerificacionesIdGet(String id, String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionAdminVerificacionesIdGetWithHttpInfo(id, version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'VerificationDetail',) as VerificationDetail;
    
    }
    return null;
  }
}
