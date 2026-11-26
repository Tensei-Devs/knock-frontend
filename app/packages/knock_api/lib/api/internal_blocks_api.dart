//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class InternalBlocksApi {
  InternalBlocksApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Performs an HTTP 'POST /api/v{version}/interno/bloqueos' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [BlockEventBody] blockEventBody (required):
  Future<Response> apiVversionInternoBloqueosPostWithHttpInfo(String version, BlockEventBody blockEventBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/interno/bloqueos'
      .replaceAll('{version}', version);

    Object? postBody = blockEventBody;

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

  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [BlockEventBody] blockEventBody (required):
  Future<void> apiVversionInternoBloqueosPost(String version, BlockEventBody blockEventBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionInternoBloqueosPostWithHttpInfo(version, blockEventBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }
}
