//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class AdminApelacionesApi {
  AdminApelacionesApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Acepta (reactiva la cuenta) o rechaza la apelación. 404 `appeal_not_found`; 409 `appeal_already_resolved`; 403 `self_review_not_allowed`.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [AppealResolutionBody] appealResolutionBody (required):
  Future<Response> apiVversionAdminApelacionesIdResolucionPostWithHttpInfo(String id, String version, AppealResolutionBody appealResolutionBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/admin/apelaciones/{id}/resolucion'
      .replaceAll('{id}', id)
      .replaceAll('{version}', version);

    Object? postBody = appealResolutionBody;

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

  /// Acepta (reactiva la cuenta) o rechaza la apelación. 404 `appeal_not_found`; 409 `appeal_already_resolved`; 403 `self_review_not_allowed`.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [AppealResolutionBody] appealResolutionBody (required):
  Future<AppealResolutionResult?> apiVversionAdminApelacionesIdResolucionPost(String id, String version, AppealResolutionBody appealResolutionBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionAdminApelacionesIdResolucionPostWithHttpInfo(id, version, appealResolutionBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AppealResolutionResult',) as AppealResolutionResult;
    
    }
    return null;
  }
}
