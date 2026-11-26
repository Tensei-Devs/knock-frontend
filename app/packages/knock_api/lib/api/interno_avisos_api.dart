//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class InternoAvisosApi {
  InternoAvisosApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Recibe el evento de un servicio emisor y responde 202, también si ya lo recibió. 401 con token inválido o vencido; 403 `service_not_allowed` si el emisor no tiene el tipo en `permisos`; 422 con un tipo o cuerpo fuera del catálogo.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [AvisoInterno] avisoInterno (required):
  Future<Response> apiVversionInternoAvisosPostWithHttpInfo(String version, AvisoInterno avisoInterno, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/interno/avisos'
      .replaceAll('{version}', version);

    Object? postBody = avisoInterno;

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

  /// Recibe el evento de un servicio emisor y responde 202, también si ya lo recibió. 401 con token inválido o vencido; 403 `service_not_allowed` si el emisor no tiene el tipo en `permisos`; 422 con un tipo o cuerpo fuera del catálogo.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [AvisoInterno] avisoInterno (required):
  Future<void> apiVversionInternoAvisosPost(String version, AvisoInterno avisoInterno, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionInternoAvisosPostWithHttpInfo(version, avisoInterno, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }
}
