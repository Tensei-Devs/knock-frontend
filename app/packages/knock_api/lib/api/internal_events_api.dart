//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class InternalEventsApi {
  InternalEventsApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Performs an HTTP 'POST /api/v{version}/interno/eventos' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [AccountEventBody] accountEventBody (required):
  Future<Response> apiVversionInternoEventosPostWithHttpInfo(String version, AccountEventBody accountEventBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/interno/eventos'
      .replaceAll('{version}', version);

    Object? postBody = accountEventBody;

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
  /// * [AccountEventBody] accountEventBody (required):
  Future<void> apiVversionInternoEventosPost(String version, AccountEventBody accountEventBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionInternoEventosPostWithHttpInfo(version, accountEventBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }
}
