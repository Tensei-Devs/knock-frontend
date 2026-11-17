//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class OficiosApi {
  OficiosApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Oficios activos como arreglo sin paginar: excepción documentada a la constitución §11 (catálogo acotado, D9). `[AllowAnonymous]` explícito para que siga público aunque se agregue una política de autorización global (D3). Responde con `ETag` débil, `Cache-Control: public, max-age=0, must-revalidate` y `Vary: Accept-Encoding` (la respuesta comprimida es otra variante); con `If-None-Match` vigente responde 304 sin cuerpo.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] ifNoneMatch:
  Future<Response> apiVversionOficiosGetWithHttpInfo(String version, { String? ifNoneMatch, Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/oficios'
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (ifNoneMatch != null) {
      headerParams[r'If-None-Match'] = parameterToString(ifNoneMatch);
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

  /// Oficios activos como arreglo sin paginar: excepción documentada a la constitución §11 (catálogo acotado, D9). `[AllowAnonymous]` explícito para que siga público aunque se agregue una política de autorización global (D3). Responde con `ETag` débil, `Cache-Control: public, max-age=0, must-revalidate` y `Vary: Accept-Encoding` (la respuesta comprimida es otra variante); con `If-None-Match` vigente responde 304 sin cuerpo.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] ifNoneMatch:
  Future<List<OficioResponse>?> apiVversionOficiosGet(String version, { String? ifNoneMatch, Future<void>? abortTrigger, }) async {
    final response = await apiVversionOficiosGetWithHttpInfo(version, ifNoneMatch: ifNoneMatch, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<OficioResponse>') as List)
        .cast<OficioResponse>()
        .toList(growable: false);

    }
    return null;
  }
}
