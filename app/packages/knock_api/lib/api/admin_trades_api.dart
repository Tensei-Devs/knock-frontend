//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class AdminTradesApi {
  AdminTradesApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Edición parcial de un oficio y sus parámetros de precio (OFI-05): 200 con el oficio como quedó. La clave no se puede cambiar: una `clave` distinta de la de la ruta responde 422 `errors.clave`. Un oficio que no existe responde 404 `trade_not_found`; la caché de oficios activos se invalida al escribir.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] clave (required):
  ///
  /// * [String] version (required):
  ///
  /// * [UpdateTradeBody] updateTradeBody (required):
  Future<Response> apiVversionAdminOficiosClavePutWithHttpInfo(String clave, String version, UpdateTradeBody updateTradeBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/admin/oficios/{clave}'
      .replaceAll('{clave}', clave)
      .replaceAll('{version}', version);

    Object? postBody = updateTradeBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json', 'text/json', 'application/*+json'];


    return apiClient.invokeAPI(
      path,
      'PUT',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      abortTrigger: abortTrigger,
    );
  }

  /// Edición parcial de un oficio y sus parámetros de precio (OFI-05): 200 con el oficio como quedó. La clave no se puede cambiar: una `clave` distinta de la de la ruta responde 422 `errors.clave`. Un oficio que no existe responde 404 `trade_not_found`; la caché de oficios activos se invalida al escribir.
  ///
  /// Parameters:
  ///
  /// * [String] clave (required):
  ///
  /// * [String] version (required):
  ///
  /// * [UpdateTradeBody] updateTradeBody (required):
  Future<AdminTradeResponse?> apiVversionAdminOficiosClavePut(String clave, String version, UpdateTradeBody updateTradeBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionAdminOficiosClavePutWithHttpInfo(clave, version, updateTradeBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminTradeResponse',) as AdminTradeResponse;
    
    }
    return null;
  }

  /// Todos los oficios, activos e inactivos, con sus parámetros de precio (OFI-03).
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  Future<Response> apiVversionAdminOficiosGetWithHttpInfo(String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/admin/oficios'
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

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

  /// Todos los oficios, activos e inactivos, con sus parámetros de precio (OFI-03).
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  Future<AdminTradeListResponse?> apiVversionAdminOficiosGet(String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionAdminOficiosGetWithHttpInfo(version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminTradeListResponse',) as AdminTradeListResponse;
    
    }
    return null;
  }

  /// Alta de un oficio (OFI-04): 201 con el oficio creado. La clave repetida responde 409 `trade_key_taken`; un cuerpo ilegible, 400; un valor inválido, 422. Deja la auditoría del panel antes de escribir: sin ella responde 503 `panel_audit_unavailable` y no cambia nada.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [CreateTradeBody] createTradeBody (required):
  Future<Response> apiVversionAdminOficiosPostWithHttpInfo(String version, CreateTradeBody createTradeBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/admin/oficios'
      .replaceAll('{version}', version);

    Object? postBody = createTradeBody;

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

  /// Alta de un oficio (OFI-04): 201 con el oficio creado. La clave repetida responde 409 `trade_key_taken`; un cuerpo ilegible, 400; un valor inválido, 422. Deja la auditoría del panel antes de escribir: sin ella responde 503 `panel_audit_unavailable` y no cambia nada.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [CreateTradeBody] createTradeBody (required):
  Future<AdminTradeResponse?> apiVversionAdminOficiosPost(String version, CreateTradeBody createTradeBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionAdminOficiosPostWithHttpInfo(version, createTradeBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminTradeResponse',) as AdminTradeResponse;
    
    }
    return null;
  }
}
