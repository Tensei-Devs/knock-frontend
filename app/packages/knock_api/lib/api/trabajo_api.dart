//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class TrabajoApi {
  TrabajoApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Performs an HTTP 'GET /api/v{version}/tecnicos/me/trabajo' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] cursorTerminadas:
  ///
  /// * [int] limit:
  Future<Response> apiVversionTecnicosMeTrabajoGetWithHttpInfo(String version, { String? cursorTerminadas, int? limit, Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/tecnicos/me/trabajo'
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (cursorTerminadas != null) {
      queryParams.addAll(_queryParams('', 'cursorTerminadas', cursorTerminadas));
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

  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] cursorTerminadas:
  ///
  /// * [int] limit:
  Future<TrabajoResponse?> apiVversionTecnicosMeTrabajoGet(String version, { String? cursorTerminadas, int? limit, Future<void>? abortTrigger, }) async {
    final response = await apiVversionTecnicosMeTrabajoGetWithHttpInfo(version, cursorTerminadas: cursorTerminadas, limit: limit, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'TrabajoResponse',) as TrabajoResponse;
    
    }
    return null;
  }
}
