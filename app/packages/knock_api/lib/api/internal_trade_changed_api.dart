//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class InternalTradeChangedApi {
  InternalTradeChangedApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Performs an HTTP 'POST /api/v{version}/interno/cambios-de-oficio' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [TradeChangedEventBody] tradeChangedEventBody (required):
  Future<Response> apiVversionInternoCambiosDeOficioPostWithHttpInfo(String version, TradeChangedEventBody tradeChangedEventBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/interno/cambios-de-oficio'
      .replaceAll('{version}', version);

    Object? postBody = tradeChangedEventBody;

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
  /// * [TradeChangedEventBody] tradeChangedEventBody (required):
  Future<void> apiVversionInternoCambiosDeOficioPost(String version, TradeChangedEventBody tradeChangedEventBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionInternoCambiosDeOficioPostWithHttpInfo(version, tradeChangedEventBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }
}
