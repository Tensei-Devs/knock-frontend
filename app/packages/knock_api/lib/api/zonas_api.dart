//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class ZonasApi {
  ZonasApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Performs an HTTP 'GET /api/v{version}/zonas/cp/{cp}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] cp (required):
  ///
  /// * [String] version (required):
  ///
  /// * [String] ifNoneMatch:
  Future<Response> apiVversionZonasCpCpGetWithHttpInfo(String cp, String version, { String? ifNoneMatch, Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/zonas/cp/{cp}'
      .replaceAll('{cp}', cp)
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (ifNoneMatch != null) {
      headerParams[r'If-None-Match'] = parameterToString(ifNoneMatch);
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
  /// * [String] cp (required):
  ///
  /// * [String] version (required):
  ///
  /// * [String] ifNoneMatch:
  Future<ZonaResponse?> apiVversionZonasCpCpGet(String cp, String version, { String? ifNoneMatch, Future<void>? abortTrigger, }) async {
    final response = await apiVversionZonasCpCpGetWithHttpInfo(cp, version, ifNoneMatch: ifNoneMatch, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ZonaResponse',) as ZonaResponse;
    
    }
    return null;
  }
}
