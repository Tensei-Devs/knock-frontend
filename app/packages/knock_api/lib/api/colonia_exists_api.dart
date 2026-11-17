//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class ColoniaExistsApi {
  ColoniaExistsApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// 200 en ambos casos; el nombre se compara sin mayúsculas ni acentos y no se registra. El 422 lo da `ValidationFilter` antes de esta acción.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] nombre (required):
  ///   Name of the colonia. Letters, digits, spaces and . , ' ’ ( ) / # - ; up to 80 characters. Exactly one value. Case and accents are ignored.
  ///
  /// * [String] version (required):
  Future<Response> apiVversionColoniasExisteGetWithHttpInfo(String nombre, String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/colonias/existe'
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'nombre', nombre));

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

  /// 200 en ambos casos; el nombre se compara sin mayúsculas ni acentos y no se registra. El 422 lo da `ValidationFilter` antes de esta acción.
  ///
  /// Parameters:
  ///
  /// * [String] nombre (required):
  ///   Name of the colonia. Letters, digits, spaces and . , ' ’ ( ) / # - ; up to 80 characters. Exactly one value. Case and accents are ignored.
  ///
  /// * [String] version (required):
  Future<NeighborhoodExistsResponse?> apiVversionColoniasExisteGet(String nombre, String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionColoniasExisteGetWithHttpInfo(nombre, version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'NeighborhoodExistsResponse',) as NeighborhoodExistsResponse;
    
    }
    return null;
  }
}
