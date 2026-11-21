//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class CasaYAutoApi {
  CasaYAutoApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Lista los autos y las cosas de la casa de la persona (CAS-01).
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  Future<Response> apiVversionMeCasaYAutoGetWithHttpInfo(String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/me/casa-y-auto'
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

  /// Lista los autos y las cosas de la casa de la persona (CAS-01).
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  Future<List<ItemResponse>?> apiVversionMeCasaYAutoGet(String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionMeCasaYAutoGetWithHttpInfo(version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<ItemResponse>') as List)
        .cast<ItemResponse>()
        .toList(growable: false);

    }
    return null;
  }

  /// Quita un elemento propio (CAS-04). Uno ajeno o inexistente responde 404. Los trabajos terminados de Mercado no se tocan.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  Future<Response> apiVversionMeCasaYAutoIdDeleteWithHttpInfo(String id, String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/me/casa-y-auto/{id}'
      .replaceAll('{id}', id)
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      abortTrigger: abortTrigger,
    );
  }

  /// Quita un elemento propio (CAS-04). Uno ajeno o inexistente responde 404. Los trabajos terminados de Mercado no se tocan.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  Future<void> apiVversionMeCasaYAutoIdDelete(String id, String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionMeCasaYAutoIdDeleteWithHttpInfo(id, version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Trabajos terminados ligados a un elemento propio (CAS-05), del más reciente al más antiguo y por cursor. Uno ajeno o inexistente responde 404; si Mercado no responde, 503 `market_unavailable`.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [String] cursor:
  ///
  /// * [String] limite:
  ///   Texto a propósito: un valor que no es número responde 422 con el resto, no el 400 automático del enlace de datos.
  ///
  /// * [int] resolvedLimit:
  ///   El límite ya validado (el validador corre antes de la acción).
  Future<Response> apiVversionMeCasaYAutoIdHistorialGetWithHttpInfo(String id, String version, { String? cursor, String? limite, int? resolvedLimit, Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/me/casa-y-auto/{id}/historial'
      .replaceAll('{id}', id)
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
    if (resolvedLimit != null) {
      queryParams.addAll(_queryParams('', 'ResolvedLimit', resolvedLimit));
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

  /// Trabajos terminados ligados a un elemento propio (CAS-05), del más reciente al más antiguo y por cursor. Uno ajeno o inexistente responde 404; si Mercado no responde, 503 `market_unavailable`.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [String] cursor:
  ///
  /// * [String] limite:
  ///   Texto a propósito: un valor que no es número responde 422 con el resto, no el 400 automático del enlace de datos.
  ///
  /// * [int] resolvedLimit:
  ///   El límite ya validado (el validador corre antes de la acción).
  Future<CursorPageOfHistoryItemResponse?> apiVversionMeCasaYAutoIdHistorialGet(String id, String version, { String? cursor, String? limite, int? resolvedLimit, Future<void>? abortTrigger, }) async {
    final response = await apiVversionMeCasaYAutoIdHistorialGetWithHttpInfo(id, version, cursor: cursor, limite: limite, resolvedLimit: resolvedLimit, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CursorPageOfHistoryItemResponse',) as CursorPageOfHistoryItemResponse;
    
    }
    return null;
  }

  /// Edita un elemento propio (CAS-03): cambian solo los campos enviados. Uno ajeno o inexistente responde 404.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [UpdateItemRequest] updateItemRequest (required):
  Future<Response> apiVversionMeCasaYAutoIdPutWithHttpInfo(String id, String version, UpdateItemRequest updateItemRequest, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/me/casa-y-auto/{id}'
      .replaceAll('{id}', id)
      .replaceAll('{version}', version);

    Object? postBody = updateItemRequest;

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

  /// Edita un elemento propio (CAS-03): cambian solo los campos enviados. Uno ajeno o inexistente responde 404.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [UpdateItemRequest] updateItemRequest (required):
  Future<ItemResponse?> apiVversionMeCasaYAutoIdPut(String id, String version, UpdateItemRequest updateItemRequest, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionMeCasaYAutoIdPutWithHttpInfo(id, version, updateItemRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ItemResponse',) as ItemResponse;
    
    }
    return null;
  }

  /// Registra un auto o una cosa de la casa (CAS-02). Con 20 elementos ya registrados responde 409 `item_limit_reached`.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [CreateItemRequest] createItemRequest (required):
  Future<Response> apiVversionMeCasaYAutoPostWithHttpInfo(String version, CreateItemRequest createItemRequest, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/me/casa-y-auto'
      .replaceAll('{version}', version);

    Object? postBody = createItemRequest;

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

  /// Registra un auto o una cosa de la casa (CAS-02). Con 20 elementos ya registrados responde 409 `item_limit_reached`.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [CreateItemRequest] createItemRequest (required):
  Future<ItemResponse?> apiVversionMeCasaYAutoPost(String version, CreateItemRequest createItemRequest, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionMeCasaYAutoPostWithHttpInfo(version, createItemRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ItemResponse',) as ItemResponse;
    
    }
    return null;
  }
}
