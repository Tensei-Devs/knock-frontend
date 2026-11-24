//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class InternalOpinionModeratedApi {
  InternalOpinionModeratedApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Performs an HTTP 'POST /api/v{version}/interno/opiniones-moderadas' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [OpinionModeratedEventBody] opinionModeratedEventBody (required):
  Future<Response> apiVversionInternoOpinionesModeradasPostWithHttpInfo(String version, OpinionModeratedEventBody opinionModeratedEventBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/interno/opiniones-moderadas'
      .replaceAll('{version}', version);

    Object? postBody = opinionModeratedEventBody;

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
  /// * [OpinionModeratedEventBody] opinionModeratedEventBody (required):
  Future<void> apiVversionInternoOpinionesModeradasPost(String version, OpinionModeratedEventBody opinionModeratedEventBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionInternoOpinionesModeradasPostWithHttpInfo(version, opinionModeratedEventBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }
}
