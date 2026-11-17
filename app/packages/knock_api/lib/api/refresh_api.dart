//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class RefreshApi {
  RefreshApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Cambia un token de renovación por un par nuevo (spec 016). Cualquier rechazo responde el mismo 401 sin motivo.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [RefreshRequest] refreshRequest (required):
  Future<Response> apiVversionAuthRefreshPostWithHttpInfo(String version, RefreshRequest refreshRequest, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/auth/refresh'
      .replaceAll('{version}', version);

    Object? postBody = refreshRequest;

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

  /// Cambia un token de renovación por un par nuevo (spec 016). Cualquier rechazo responde el mismo 401 sin motivo.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [RefreshRequest] refreshRequest (required):
  Future<RefreshResponse?> apiVversionAuthRefreshPost(String version, RefreshRequest refreshRequest, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionAuthRefreshPostWithHttpInfo(version, refreshRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'RefreshResponse',) as RefreshResponse;
    
    }
    return null;
  }
}
