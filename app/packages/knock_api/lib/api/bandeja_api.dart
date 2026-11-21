//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class BandejaApi {
  BandejaApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Performs an HTTP 'GET /api/v{version}/tecnicos/me/solicitudes' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] cursor:
  ///
  /// * [int] limit:
  Future<Response> apiVversionTecnicosMeSolicitudesGetWithHttpInfo(String version, { String? cursor, int? limit, Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/tecnicos/me/solicitudes'
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
  /// * [String] cursor:
  ///
  /// * [int] limit:
  Future<InboxResponse?> apiVversionTecnicosMeSolicitudesGet(String version, { String? cursor, int? limit, Future<void>? abortTrigger, }) async {
    final response = await apiVversionTecnicosMeSolicitudesGetWithHttpInfo(version, cursor: cursor, limit: limit, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'InboxResponse',) as InboxResponse;
    
    }
    return null;
  }
}
