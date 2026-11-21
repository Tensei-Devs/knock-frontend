//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class MeVerificacionApi {
  MeVerificacionApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Estado de la verificación más reciente; sin ninguna, `sin_verificar` (nunca 404).
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  Future<Response> apiVversionMeVerificacionGetWithHttpInfo(String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/me/verificacion'
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

  /// Estado de la verificación más reciente; sin ninguna, `sin_verificar` (nunca 404).
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  Future<VerificationStatusResponse?> apiVversionMeVerificacionGet(String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionMeVerificacionGetWithHttpInfo(version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'VerificationStatusResponse',) as VerificationStatusResponse;
    
    }
    return null;
  }

  /// Crea la verificación en `en_captura` con su consentimiento. Las fotos llegan con la tarea T-04 (enlaces de subida).
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [CreateVerificationRequest] createVerificationRequest (required):
  Future<Response> apiVversionMeVerificacionPostWithHttpInfo(String version, CreateVerificationRequest createVerificationRequest, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/me/verificacion'
      .replaceAll('{version}', version);

    Object? postBody = createVerificationRequest;

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

  /// Crea la verificación en `en_captura` con su consentimiento. Las fotos llegan con la tarea T-04 (enlaces de subida).
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [CreateVerificationRequest] createVerificationRequest (required):
  Future<VerificationCreatedResponse?> apiVversionMeVerificacionPost(String version, CreateVerificationRequest createVerificationRequest, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionMeVerificacionPostWithHttpInfo(version, createVerificationRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'VerificationCreatedResponse',) as VerificationCreatedResponse;
    
    }
    return null;
  }
}
