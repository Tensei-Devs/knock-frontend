//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class SolicitudesApi {
  SolicitudesApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Solicitudes del `sub` del token, de la más reciente a la más antigua, con paginación por cursor.
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
  /// * [int] limit:
  ///   Page size, 1 to 50. Defaults to 20.
  ///
  /// * [String] estado:
  ///   Optional filter by state: enviada, cotizando, cita_confirmada, terminada, calificada, cancelada or vencida.
  Future<Response> apiVversionSolicitudesGetWithHttpInfo(String version, { String? cursor, int? limit, String? estado, Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/solicitudes'
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (cursor != null) {
      queryParams.addAll(_queryParams('', 'Cursor', cursor));
    }
    if (limit != null) {
      queryParams.addAll(_queryParams('', 'Limit', limit));
    }
    if (estado != null) {
      queryParams.addAll(_queryParams('', 'Estado', estado));
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

  /// Solicitudes del `sub` del token, de la más reciente a la más antigua, con paginación por cursor.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] cursor:
  ///   Opaque cursor returned as nextCursor by the previous page.
  ///
  /// * [int] limit:
  ///   Page size, 1 to 50. Defaults to 20.
  ///
  /// * [String] estado:
  ///   Optional filter by state: enviada, cotizando, cita_confirmada, terminada, calificada, cancelada or vencida.
  Future<RequestPage?> apiVversionSolicitudesGet(String version, { String? cursor, int? limit, String? estado, Future<void>? abortTrigger, }) async {
    final response = await apiVversionSolicitudesGetWithHttpInfo(version, cursor: cursor, limit: limit, estado: estado, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'RequestPage',) as RequestPage;
    
    }
    return null;
  }

  /// Detalle: vista del cliente dueño, o vista acotada del técnico elegible o que ya cotizó. Cualquier otra persona recibe 404.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  Future<Response> apiVversionSolicitudesIdGetWithHttpInfo(String id, String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/solicitudes/{id}'
      .replaceAll('{id}', id)
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

  /// Detalle: vista del cliente dueño, o vista acotada del técnico elegible o que ya cotizó. Cualquier otra persona recibe 404.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  Future<RequestResponse?> apiVversionSolicitudesIdGet(String id, String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionSolicitudesIdGetWithHttpInfo(id, version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'RequestResponse',) as RequestResponse;
    
    }
    return null;
  }

  /// Crea la solicitud en estado `enviada` y con `venceEn` a 48 h.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [CreateRequestBody] createRequestBody (required):
  Future<Response> apiVversionSolicitudesPostWithHttpInfo(String version, CreateRequestBody createRequestBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/solicitudes'
      .replaceAll('{version}', version);

    Object? postBody = createRequestBody;

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

  /// Crea la solicitud en estado `enviada` y con `venceEn` a 48 h.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [CreateRequestBody] createRequestBody (required):
  Future<RequestResponse?> apiVversionSolicitudesPost(String version, CreateRequestBody createRequestBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionSolicitudesPostWithHttpInfo(version, createRequestBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'RequestResponse',) as RequestResponse;
    
    }
    return null;
  }
}
