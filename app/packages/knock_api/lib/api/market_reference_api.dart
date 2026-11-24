//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class MarketReferenceApi {
  MarketReferenceApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Performs an HTTP 'GET /api/v{version}/cotizaciones/referencia-mercado' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] oficio:
  ///
  /// * [String] tipoTrabajo:
  Future<Response> apiVversionCotizacionesReferenciaMercadoGetWithHttpInfo(String version, { String? oficio, String? tipoTrabajo, Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/cotizaciones/referencia-mercado'
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (oficio != null) {
      queryParams.addAll(_queryParams('', 'Oficio', oficio));
    }
    if (tipoTrabajo != null) {
      queryParams.addAll(_queryParams('', 'TipoTrabajo', tipoTrabajo));
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

  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] oficio:
  ///
  /// * [String] tipoTrabajo:
  Future<MarketReference?> apiVversionCotizacionesReferenciaMercadoGet(String version, { String? oficio, String? tipoTrabajo, Future<void>? abortTrigger, }) async {
    final response = await apiVversionCotizacionesReferenciaMercadoGetWithHttpInfo(version, oficio: oficio, tipoTrabajo: tipoTrabajo, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'MarketReference',) as MarketReference;
    
    }
    return null;
  }
}
