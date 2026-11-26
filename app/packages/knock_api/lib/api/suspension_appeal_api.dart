//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class SuspensionAppealApi {
  SuspensionAppealApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Estado de la apelación (R-09). 200 con estado y fechas; 401; 404 uniforme; 429.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  Future<Response> apiVversionSuspensionApelacionGetWithHttpInfo(String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/suspension/apelacion'
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

  /// Estado de la apelación (R-09). 200 con estado y fechas; 401; 404 uniforme; 429.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  Future<SuspensionAppealView?> apiVversionSuspensionApelacionGet(String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionSuspensionApelacionGetWithHttpInfo(version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'SuspensionAppealView',) as SuspensionAppealView;
    
    }
    return null;
  }

  /// Presenta la apelación de la suspensión vigente (R-01 a R-05). 200 con el estado; 401, 404 uniforme, 409 `appeal_not_allowed`.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [SuspensionAppealBody] suspensionAppealBody (required):
  Future<Response> apiVversionSuspensionApelacionPostWithHttpInfo(String version, SuspensionAppealBody suspensionAppealBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/suspension/apelacion'
      .replaceAll('{version}', version);

    Object? postBody = suspensionAppealBody;

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

  /// Presenta la apelación de la suspensión vigente (R-01 a R-05). 200 con el estado; 401, 404 uniforme, 409 `appeal_not_allowed`.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [SuspensionAppealBody] suspensionAppealBody (required):
  Future<SuspensionAppealView?> apiVversionSuspensionApelacionPost(String version, SuspensionAppealBody suspensionAppealBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionSuspensionApelacionPostWithHttpInfo(version, suspensionAppealBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'SuspensionAppealView',) as SuspensionAppealView;
    
    }
    return null;
  }
}
