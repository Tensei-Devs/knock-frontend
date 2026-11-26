//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class LecturaApi {
  LecturaApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Marca como leído hasta `hasta` (acotado al último mensaje). Repetirlo o mandar una fecha anterior responde 204 sin cambios.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [LeidoBody] leidoBody (required):
  Future<Response> apiVversionConversacionesIdLeidoPostWithHttpInfo(String id, String version, LeidoBody leidoBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/conversaciones/{id}/leido'
      .replaceAll('{id}', id)
      .replaceAll('{version}', version);

    Object? postBody = leidoBody;

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

  /// Marca como leído hasta `hasta` (acotado al último mensaje). Repetirlo o mandar una fecha anterior responde 204 sin cambios.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [LeidoBody] leidoBody (required):
  Future<void> apiVversionConversacionesIdLeidoPost(String id, String version, LeidoBody leidoBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionConversacionesIdLeidoPostWithHttpInfo(id, version, leidoBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Los mensajes de la conversación del más reciente al más antiguo, con paginación por cursor (`limit` de 1 a 50, 30 por omisión).
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
  ///   Opaque cursor returned as nextCursor by the previous page.
  ///
  /// * [int] limit:
  ///   Page size, 1 to 50. Defaults to 30.
  Future<Response> apiVversionConversacionesIdMensajesGetWithHttpInfo(String id, String version, { String? cursor, int? limit, Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/conversaciones/{id}/mensajes'
      .replaceAll('{id}', id)
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

  /// Los mensajes de la conversación del más reciente al más antiguo, con paginación por cursor (`limit` de 1 a 50, 30 por omisión).
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [String] cursor:
  ///   Opaque cursor returned as nextCursor by the previous page.
  ///
  /// * [int] limit:
  ///   Page size, 1 to 50. Defaults to 30.
  Future<CursorPageOfMensajeView?> apiVversionConversacionesIdMensajesGet(String id, String version, { String? cursor, int? limit, Future<void>? abortTrigger, }) async {
    final response = await apiVversionConversacionesIdMensajesGetWithHttpInfo(id, version, cursor: cursor, limit: limit, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CursorPageOfMensajeView',) as CursorPageOfMensajeView;
    
    }
    return null;
  }
}
