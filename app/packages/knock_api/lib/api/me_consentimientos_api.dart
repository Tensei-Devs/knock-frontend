//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class MeConsentimientosApi {
  MeConsentimientosApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// USR-07. Lista los consentimientos con su versión y fecha.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  Future<Response> apiVversionMeConsentimientosGetWithHttpInfo(String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/me/consentimientos'
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

  /// USR-07. Lista los consentimientos con su versión y fecha.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  Future<List<ConsentResponse>?> apiVversionMeConsentimientosGet(String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionMeConsentimientosGetWithHttpInfo(version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<ConsentResponse>') as List)
        .cast<ConsentResponse>()
        .toList(growable: false);

    }
    return null;
  }

  /// USR-08. Activa o retira un consentimiento opcional (promociones, encuestas, recomendaciones); surte efecto de inmediato.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [UpdateConsentRequest] updateConsentRequest (required):
  Future<Response> apiVversionMeConsentimientosPutWithHttpInfo(String version, UpdateConsentRequest updateConsentRequest, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/me/consentimientos'
      .replaceAll('{version}', version);

    Object? postBody = updateConsentRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json', 'text/json', 'application/*+json'];


    return apiClient.invokeAPI(
      path,
      'PUT',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      abortTrigger: abortTrigger,
    );
  }

  /// USR-08. Activa o retira un consentimiento opcional (promociones, encuestas, recomendaciones); surte efecto de inmediato.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [UpdateConsentRequest] updateConsentRequest (required):
  Future<ConsentResponse?> apiVversionMeConsentimientosPut(String version, UpdateConsentRequest updateConsentRequest, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionMeConsentimientosPutWithHttpInfo(version, updateConsentRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ConsentResponse',) as ConsentResponse;
    
    }
    return null;
  }
}
