//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class ConversacionesApi {
  ConversacionesApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Las conversaciones de la persona, de la más reciente a la más antigua, con paginación por cursor (1 a 20) y el total de no leídos.
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
  ///   Page size, 1 to 20. Defaults to 20.
  Future<Response> apiVversionConversacionesGetWithHttpInfo(String version, { String? cursor, int? limit, Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/conversaciones'
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (cursor != null) {
      queryParams.addAll(_queryParams('', 'cursor', cursor));
    }
    if (limit != null) {
      queryParams.addAll(_queryParams('', 'limit', limit));
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

  /// Las conversaciones de la persona, de la más reciente a la más antigua, con paginación por cursor (1 a 20) y el total de no leídos.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] cursor:
  ///   Opaque cursor returned as nextCursor by the previous page.
  ///
  /// * [int] limit:
  ///   Page size, 1 to 20. Defaults to 20.
  Future<ConversacionPage?> apiVversionConversacionesGet(String version, { String? cursor, int? limit, Future<void>? abortTrigger, }) async {
    final response = await apiVversionConversacionesGetWithHttpInfo(version, cursor: cursor, limit: limit, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ConversacionPage',) as ConversacionPage;
    
    }
    return null;
  }

  /// Una conversación, solo para sus dos participantes; para cualquier otra persona, 404.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  Future<Response> apiVversionConversacionesIdGetWithHttpInfo(String id, String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/conversaciones/{id}'
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

  /// Una conversación, solo para sus dos participantes; para cualquier otra persona, 404.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  Future<ConversacionView?> apiVversionConversacionesIdGet(String id, String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionConversacionesIdGetWithHttpInfo(id, version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ConversacionView',) as ConversacionView;
    
    }
    return null;
  }

  /// La suma de los no leídos de la persona en todas sus conversaciones.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  Future<Response> apiVversionConversacionesNoLeidasGetWithHttpInfo(String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/conversaciones/no-leidas'
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

  /// La suma de los no leídos de la persona en todas sus conversaciones.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  Future<NoLeidasView?> apiVversionConversacionesNoLeidasGet(String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionConversacionesNoLeidasGetWithHttpInfo(version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'NoLeidasView',) as NoLeidasView;
    
    }
    return null;
  }

  /// Crea la conversación del par (solicitud, técnico) o devuelve la que ya existe: 201 la primera vez y 200 después. 409 `conversation_closed` si está cerrada; 20 por hora por persona.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [CrearConversacionBody] crearConversacionBody (required):
  Future<Response> apiVversionConversacionesPostWithHttpInfo(String version, CrearConversacionBody crearConversacionBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/conversaciones'
      .replaceAll('{version}', version);

    Object? postBody = crearConversacionBody;

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

  /// Crea la conversación del par (solicitud, técnico) o devuelve la que ya existe: 201 la primera vez y 200 después. 409 `conversation_closed` si está cerrada; 20 por hora por persona.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [CrearConversacionBody] crearConversacionBody (required):
  Future<ConversacionView?> apiVversionConversacionesPost(String version, CrearConversacionBody crearConversacionBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionConversacionesPostWithHttpInfo(version, crearConversacionBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ConversacionView',) as ConversacionView;
    
    }
    return null;
  }
}
