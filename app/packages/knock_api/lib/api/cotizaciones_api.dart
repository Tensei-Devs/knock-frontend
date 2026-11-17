//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class CotizacionesApi {
  CotizacionesApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Performs an HTTP 'POST /api/v{version}/solicitudes/{id}/cotizaciones' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [QuoteRequest] quoteRequest (required):
  Future<Response> apiVversionSolicitudesIdCotizacionesPostWithHttpInfo(String id, String version, QuoteRequest quoteRequest, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/solicitudes/{id}/cotizaciones'
      .replaceAll('{id}', id)
      .replaceAll('{version}', version);

    Object? postBody = quoteRequest;

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
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [QuoteRequest] quoteRequest (required):
  Future<QuoteResponse?> apiVversionSolicitudesIdCotizacionesPost(String id, String version, QuoteRequest quoteRequest, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionSolicitudesIdCotizacionesPostWithHttpInfo(id, version, quoteRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'QuoteResponse',) as QuoteResponse;
    
    }
    return null;
  }
}
