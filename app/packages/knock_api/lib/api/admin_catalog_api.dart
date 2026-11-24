//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class AdminCatalogApi {
  AdminCatalogApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Cuántas personas esperan por código postal, ordenado por código postal, con paginación por cursor. Nunca incluye celulares.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] cursor:
  ///   Opaque cursor returned as nextCursor by the previous page.
  ///
  /// * [int] limite:
  ///   Page size, 1 to 50. Defaults to 20.
  Future<Response> apiVversionAdminListaEsperaGetWithHttpInfo(String version, { String? cursor, int? limite, Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/admin/lista-espera'
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (cursor != null) {
      queryParams.addAll(_queryParams('', 'cursor', cursor));
    }
    if (limite != null) {
      queryParams.addAll(_queryParams('', 'limite', limite));
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

  /// Cuántas personas esperan por código postal, ordenado por código postal, con paginación por cursor. Nunca incluye celulares.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] cursor:
  ///   Opaque cursor returned as nextCursor by the previous page.
  ///
  /// * [int] limite:
  ///   Page size, 1 to 50. Defaults to 20.
  Future<WaitlistZonePage?> apiVversionAdminListaEsperaGet(String version, { String? cursor, int? limite, Future<void>? abortTrigger, }) async {
    final response = await apiVversionAdminListaEsperaGetWithHttpInfo(version, cursor: cursor, limite: limite, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'WaitlistZonePage',) as WaitlistZonePage;
    
    }
    return null;
  }

  /// Oficios pedidos en «Otro oficio», agrupados por texto normalizado y contados, de más a menos pedidos, con paginación por cursor (20 por omisión, 50 como máximo).
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] cursor:
  ///   Opaque cursor returned as nextCursor by the previous page.
  ///
  /// * [int] limite:
  ///   Page size, 1 to 50. Defaults to 20.
  Future<Response> apiVversionAdminOficiosPedidosGetWithHttpInfo(String version, { String? cursor, int? limite, Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/admin/oficios-pedidos'
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (cursor != null) {
      queryParams.addAll(_queryParams('', 'cursor', cursor));
    }
    if (limite != null) {
      queryParams.addAll(_queryParams('', 'limite', limite));
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

  /// Oficios pedidos en «Otro oficio», agrupados por texto normalizado y contados, de más a menos pedidos, con paginación por cursor (20 por omisión, 50 como máximo).
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] cursor:
  ///   Opaque cursor returned as nextCursor by the previous page.
  ///
  /// * [int] limite:
  ///   Page size, 1 to 50. Defaults to 20.
  Future<TradeRequestPage?> apiVversionAdminOficiosPedidosGet(String version, { String? cursor, int? limite, Future<void>? abortTrigger, }) async {
    final response = await apiVversionAdminOficiosPedidosGetWithHttpInfo(version, cursor: cursor, limite: limite, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'TradeRequestPage',) as TradeRequestPage;
    
    }
    return null;
  }
}
