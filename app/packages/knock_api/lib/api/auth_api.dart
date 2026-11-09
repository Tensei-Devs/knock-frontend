//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class AuthApi {
  AuthApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Registro e inicio de sesión en un solo endpoint (spec 015): 201 con cuenta nueva, 200 con cuenta existente.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [FirebaseExchangeRequest] firebaseExchangeRequest (required):
  Future<Response> apiVversionAuthFirebasePostWithHttpInfo(String version, FirebaseExchangeRequest firebaseExchangeRequest, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/auth/firebase'
      .replaceAll('{version}', version);

    Object? postBody = firebaseExchangeRequest;

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

  /// Registro e inicio de sesión en un solo endpoint (spec 015): 201 con cuenta nueva, 200 con cuenta existente.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [FirebaseExchangeRequest] firebaseExchangeRequest (required):
  Future<SessionResponse?> apiVversionAuthFirebasePost(String version, FirebaseExchangeRequest firebaseExchangeRequest, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionAuthFirebasePostWithHttpInfo(version, firebaseExchangeRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'SessionResponse',) as SessionResponse;
    
    }
    return null;
  }
}
