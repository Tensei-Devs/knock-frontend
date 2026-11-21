//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class InternalHistoryApi {
  InternalHistoryApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Visitas terminadas del cliente ligadas al elemento, de la más reciente a la más antigua, por cursor. Sin precios ni direcciones.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] usuarioId:
  ///   The sub of the client whose finished visits are listed.
  ///
  /// * [String] elementoId:
  ///   The element id (24 hexadecimal characters) linked to the requests.
  ///
  /// * [String] cursor:
  ///   Opaque cursor returned as nextCursor by the previous page.
  ///
  /// * [int] limite:
  ///   Page size, 1 to 50. Defaults to 20.
  Future<Response> apiVversionInternoHistorialGetWithHttpInfo(String version, { String? usuarioId, String? elementoId, String? cursor, int? limite, Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/interno/historial'
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (usuarioId != null) {
      queryParams.addAll(_queryParams('', 'usuarioId', usuarioId));
    }
    if (elementoId != null) {
      queryParams.addAll(_queryParams('', 'elementoId', elementoId));
    }
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

  /// Visitas terminadas del cliente ligadas al elemento, de la más reciente a la más antigua, por cursor. Sin precios ni direcciones.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] usuarioId:
  ///   The sub of the client whose finished visits are listed.
  ///
  /// * [String] elementoId:
  ///   The element id (24 hexadecimal characters) linked to the requests.
  ///
  /// * [String] cursor:
  ///   Opaque cursor returned as nextCursor by the previous page.
  ///
  /// * [int] limite:
  ///   Page size, 1 to 50. Defaults to 20.
  Future<CursorPageOfHistoryEntryResponse?> apiVversionInternoHistorialGet(String version, { String? usuarioId, String? elementoId, String? cursor, int? limite, Future<void>? abortTrigger, }) async {
    final response = await apiVversionInternoHistorialGetWithHttpInfo(version, usuarioId: usuarioId, elementoId: elementoId, cursor: cursor, limite: limite, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CursorPageOfHistoryEntryResponse',) as CursorPageOfHistoryEntryResponse;
    
    }
    return null;
  }
}
