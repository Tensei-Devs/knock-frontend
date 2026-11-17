//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class TrustNoticeApi {
  TrustNoticeApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// El cliente dueño obtiene el texto para compartir con alguien de confianza. Solo con la visita `confirmada` o `en_curso`.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  Future<Response> apiVversionVisitasIdAvisoPostWithHttpInfo(String id, String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/visitas/{id}/aviso'
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

  /// El cliente dueño obtiene el texto para compartir con alguien de confianza. Solo con la visita `confirmada` o `en_curso`.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  Future<TrustNotice?> apiVversionVisitasIdAvisoPost(String id, String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionVisitasIdAvisoPostWithHttpInfo(id, version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'TrustNotice',) as TrustNotice;
    
    }
    return null;
  }
}
