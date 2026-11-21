//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class AccessRecoveryApi {
  AccessRecoveryApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// USR-05. Inicia la recuperación con el número nuevo verificado por Firebase; si existe la cuenta, crea un caso para la cola del panel. Siempre responde 202 sin revelar si la cuenta existe.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [AccessRecoveryRequest] accessRecoveryRequest (required):
  Future<Response> apiVversionRecuperacionAccesoPostWithHttpInfo(String version, AccessRecoveryRequest accessRecoveryRequest, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/recuperacion-acceso'
      .replaceAll('{version}', version);

    Object? postBody = accessRecoveryRequest;

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

  /// USR-05. Inicia la recuperación con el número nuevo verificado por Firebase; si existe la cuenta, crea un caso para la cola del panel. Siempre responde 202 sin revelar si la cuenta existe.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [AccessRecoveryRequest] accessRecoveryRequest (required):
  Future<void> apiVversionRecuperacionAccesoPost(String version, AccessRecoveryRequest accessRecoveryRequest, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionRecuperacionAccesoPostWithHttpInfo(version, accessRecoveryRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }
}
