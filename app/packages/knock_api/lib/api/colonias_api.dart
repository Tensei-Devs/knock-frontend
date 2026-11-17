//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class ColoniasApi {
  ColoniasApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Colonia del punto o «fuera de cobertura» (200 en ambos casos). Las coordenadas se convierten en colonia y se descartan: no se guardan, no se registran, no se cachean y no vuelven en la respuesta. El 422 lo da `ValidationFilter` antes de esta acción.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] lat (required):
  ///   Latitude in decimal degrees, from -90 to 90, dot as decimal separator, up to 10 decimals. Exactly one value.
  ///
  /// * [String] lon (required):
  ///   Longitude in decimal degrees, from -180 to 180, dot as decimal separator, up to 10 decimals. Exactly one value.
  ///
  /// * [String] version (required):
  Future<Response> apiVversionColoniasEnPuntoGetWithHttpInfo(String lat, String lon, String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/colonias/en-punto'
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'lat', lat));
      queryParams.addAll(_queryParams('', 'lon', lon));

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

  /// Colonia del punto o «fuera de cobertura» (200 en ambos casos). Las coordenadas se convierten en colonia y se descartan: no se guardan, no se registran, no se cachean y no vuelven en la respuesta. El 422 lo da `ValidationFilter` antes de esta acción.
  ///
  /// Parameters:
  ///
  /// * [String] lat (required):
  ///   Latitude in decimal degrees, from -90 to 90, dot as decimal separator, up to 10 decimals. Exactly one value.
  ///
  /// * [String] lon (required):
  ///   Longitude in decimal degrees, from -180 to 180, dot as decimal separator, up to 10 decimals. Exactly one value.
  ///
  /// * [String] version (required):
  Future<NeighborhoodAtPointResponse?> apiVversionColoniasEnPuntoGet(String lat, String lon, String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionColoniasEnPuntoGetWithHttpInfo(lat, lon, version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'NeighborhoodAtPointResponse',) as NeighborhoodAtPointResponse;
    
    }
    return null;
  }
}
