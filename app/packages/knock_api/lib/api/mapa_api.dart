//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class MapaApi {
  MapaApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Técnicos de la zona visible, agrupados por celda según el zoom (hasta 200 grupos). Ninguna coordenada de la petición se guarda ni se registra.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] norte:
  ///
  /// * [String] sur:
  ///
  /// * [String] este:
  ///
  /// * [String] oeste:
  ///
  /// * [String] oficio:
  ///
  /// * [String] zoom:
  Future<Response> apiVversionMapaTecnicosGetWithHttpInfo(String version, { String? norte, String? sur, String? este, String? oeste, String? oficio, String? zoom, Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/mapa/tecnicos'
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (norte != null) {
      queryParams.addAll(_queryParams('', 'norte', norte));
    }
    if (sur != null) {
      queryParams.addAll(_queryParams('', 'sur', sur));
    }
    if (este != null) {
      queryParams.addAll(_queryParams('', 'este', este));
    }
    if (oeste != null) {
      queryParams.addAll(_queryParams('', 'oeste', oeste));
    }
    if (oficio != null) {
      queryParams.addAll(_queryParams('', 'oficio', oficio));
    }
    if (zoom != null) {
      queryParams.addAll(_queryParams('', 'zoom', zoom));
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

  /// Técnicos de la zona visible, agrupados por celda según el zoom (hasta 200 grupos). Ninguna coordenada de la petición se guarda ni se registra.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] norte:
  ///
  /// * [String] sur:
  ///
  /// * [String] este:
  ///
  /// * [String] oeste:
  ///
  /// * [String] oficio:
  ///
  /// * [String] zoom:
  Future<MapResponse?> apiVversionMapaTecnicosGet(String version, { String? norte, String? sur, String? este, String? oeste, String? oficio, String? zoom, Future<void>? abortTrigger, }) async {
    final response = await apiVversionMapaTecnicosGetWithHttpInfo(version, norte: norte, sur: sur, este: este, oeste: oeste, oficio: oficio, zoom: zoom, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'MapResponse',) as MapResponse;
    
    }
    return null;
  }
}
