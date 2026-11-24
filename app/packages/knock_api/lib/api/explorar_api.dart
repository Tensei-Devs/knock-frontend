//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class ExplorarApi {
  ExplorarApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Bloques de Explorar (máximo 10 elementos cada uno). Sin sesión, solo los públicos; con sesión suma trabajos reales y cerca de ti.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] filtro:
  ///
  /// * [String] colonia:
  Future<Response> apiVversionExplorarGetWithHttpInfo(String version, { String? filtro, String? colonia, Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/explorar'
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (filtro != null) {
      queryParams.addAll(_queryParams('', 'filtro', filtro));
    }
    if (colonia != null) {
      queryParams.addAll(_queryParams('', 'colonia', colonia));
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

  /// Bloques de Explorar (máximo 10 elementos cada uno). Sin sesión, solo los públicos; con sesión suma trabajos reales y cerca de ti.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] filtro:
  ///
  /// * [String] colonia:
  Future<ExploreResponse?> apiVversionExplorarGet(String version, { String? filtro, String? colonia, Future<void>? abortTrigger, }) async {
    final response = await apiVversionExplorarGetWithHttpInfo(version, filtro: filtro, colonia: colonia, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ExploreResponse',) as ExploreResponse;
    
    }
    return null;
  }
}
