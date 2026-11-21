//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class PanelSesionApi {
  PanelSesionApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Primer paso (R-04 a R-07): valida el `idToken` de Firebase y abre un desafío de un solo uso.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [PanelCelularRequest] panelCelularRequest (required):
  Future<Response> apiVversionPanelSesionCelularPostWithHttpInfo(String version, PanelCelularRequest panelCelularRequest, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/panel/sesion/celular'
      .replaceAll('{version}', version);

    Object? postBody = panelCelularRequest;

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

  /// Primer paso (R-04 a R-07): valida el `idToken` de Firebase y abre un desafío de un solo uso.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [PanelCelularRequest] panelCelularRequest (required):
  Future<PanelCelularResponse?> apiVversionPanelSesionCelularPost(String version, PanelCelularRequest panelCelularRequest, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionPanelSesionCelularPostWithHttpInfo(version, panelCelularRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PanelCelularResponse',) as PanelCelularResponse;
    
    }
    return null;
  }

  /// Segundo paso (R-08 a R-12): valida el TOTP y abre la sesión del panel; la cookie de renovación va en `Set-Cookie`.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [PanelTotpRequest] panelTotpRequest (required):
  Future<Response> apiVversionPanelSesionTotpPostWithHttpInfo(String version, PanelTotpRequest panelTotpRequest, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/panel/sesion/totp'
      .replaceAll('{version}', version);

    Object? postBody = panelTotpRequest;

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

  /// Segundo paso (R-08 a R-12): valida el TOTP y abre la sesión del panel; la cookie de renovación va en `Set-Cookie`.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [PanelTotpRequest] panelTotpRequest (required):
  Future<PanelAccesoResponse?> apiVversionPanelSesionTotpPost(String version, PanelTotpRequest panelTotpRequest, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionPanelSesionTotpPostWithHttpInfo(version, panelTotpRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PanelAccesoResponse',) as PanelAccesoResponse;
    
    }
    return null;
  }
}
