//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class QuoteComparisonApi {
  QuoteComparisonApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Cotizaciones de una solicitud propia, con el orden pedido. El `sub` del token debe ser el del dueño; cualquier otro recibe 404.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [String] orden:
  ///   Sort order: recomendadas (default), precio, calificacion or pronto.
  Future<Response> apiVversionSolicitudesIdCotizacionesGetWithHttpInfo(String id, String version, { String? orden, Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/solicitudes/{id}/cotizaciones'
      .replaceAll('{id}', id)
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (orden != null) {
      queryParams.addAll(_queryParams('', 'Orden', orden));
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

  /// Cotizaciones de una solicitud propia, con el orden pedido. El `sub` del token debe ser el del dueño; cualquier otro recibe 404.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [String] orden:
  ///   Sort order: recomendadas (default), precio, calificacion or pronto.
  Future<QuoteComparison?> apiVversionSolicitudesIdCotizacionesGet(String id, String version, { String? orden, Future<void>? abortTrigger, }) async {
    final response = await apiVversionSolicitudesIdCotizacionesGetWithHttpInfo(id, version, orden: orden, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'QuoteComparison',) as QuoteComparison;
    
    }
    return null;
  }
}
