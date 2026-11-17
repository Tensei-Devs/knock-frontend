//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class LogoutApi {
  LogoutApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Cierra la sesión del dispositivo: la revoca y cancela su `sid` en Redis (spec 016). Sin cuerpo.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  Future<Response> apiVversionAuthLogoutPostWithHttpInfo(String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/auth/logout'
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

  /// Cierra la sesión del dispositivo: la revoca y cancela su `sid` en Redis (spec 016). Sin cuerpo.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  Future<void> apiVversionAuthLogoutPost(String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionAuthLogoutPostWithHttpInfo(version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }
}
