//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class AvisosApi {
  AvisosApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Lista los avisos de quien llama, del más reciente al más antiguo, por cursor (20 por omisión, 50 como máximo).
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] cursor:
  ///
  /// * [String] limite:
  ///
  /// * [String] leido:
  ///
  /// * [String] comoRol:
  Future<Response> apiVversionAvisosGetWithHttpInfo(String version, { String? cursor, String? limite, String? leido, String? comoRol, Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/avisos'
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
    if (leido != null) {
      queryParams.addAll(_queryParams('', 'leido', leido));
    }
    if (comoRol != null) {
      queryParams.addAll(_queryParams('', 'comoRol', comoRol));
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

  /// Lista los avisos de quien llama, del más reciente al más antiguo, por cursor (20 por omisión, 50 como máximo).
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] cursor:
  ///
  /// * [String] limite:
  ///
  /// * [String] leido:
  ///
  /// * [String] comoRol:
  Future<NoticeListResponse?> apiVversionAvisosGet(String version, { String? cursor, String? limite, String? leido, String? comoRol, Future<void>? abortTrigger, }) async {
    final response = await apiVversionAvisosGetWithHttpInfo(version, cursor: cursor, limite: limite, leido: leido, comoRol: comoRol, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'NoticeListResponse',) as NoticeListResponse;
    
    }
    return null;
  }

  /// Marca un aviso como leído; repetirlo responde 204 igual. Uno ajeno o inexistente responde 404 `notice_not_found`.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  Future<Response> apiVversionAvisosIdLeidoPostWithHttpInfo(String id, String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/avisos/{id}/leido'
      .replaceAll('{id}', id)
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


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

  /// Marca un aviso como leído; repetirlo responde 204 igual. Uno ajeno o inexistente responde 404 `notice_not_found`.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  Future<void> apiVversionAvisosIdLeidoPost(String id, String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionAvisosIdLeidoPostWithHttpInfo(id, version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Marca como leídos todos los avisos de quien llama y solo los suyos.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  Future<Response> apiVversionAvisosLeidosPostWithHttpInfo(String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/avisos/leidos'
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


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

  /// Marca como leídos todos los avisos de quien llama y solo los suyos.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  Future<void> apiVversionAvisosLeidosPost(String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionAvisosLeidosPostWithHttpInfo(version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Cantidad de avisos sin leer, hasta 99; no se cachea.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  Future<Response> apiVversionAvisosNoLeidosContadorGetWithHttpInfo(String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/avisos/no-leidos/contador'
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

  /// Cantidad de avisos sin leer, hasta 99; no se cachea.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  Future<UnreadCountResponse?> apiVversionAvisosNoLeidosContadorGet(String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionAvisosNoLeidosContadorGetWithHttpInfo(version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'UnreadCountResponse',) as UnreadCountResponse;
    
    }
    return null;
  }
}
