//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class MyQuotesApi {
  MyQuotesApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Performs an HTTP 'GET /api/v{version}/tecnicos/me/cotizaciones' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] estado:
  ///
  /// * [String] cursor:
  ///
  /// * [String] limite:
  Future<Response> apiVversionTecnicosMeCotizacionesGetWithHttpInfo(String version, { String? estado, String? cursor, String? limite, Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/tecnicos/me/cotizaciones'
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (estado != null) {
      queryParams.addAll(_queryParams('', 'Estado', estado));
    }
    if (cursor != null) {
      queryParams.addAll(_queryParams('', 'Cursor', cursor));
    }
    if (limite != null) {
      queryParams.addAll(_queryParams('', 'Limite', limite));
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
  /// * [String] estado:
  ///
  /// * [String] cursor:
  ///
  /// * [String] limite:
  Future<MyQuotePage?> apiVversionTecnicosMeCotizacionesGet(String version, { String? estado, String? cursor, String? limite, Future<void>? abortTrigger, }) async {
    final response = await apiVversionTecnicosMeCotizacionesGetWithHttpInfo(version, estado: estado, cursor: cursor, limite: limite, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'MyQuotePage',) as MyQuotePage;
    
    }
    return null;
  }
}
