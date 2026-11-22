//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class PanelActivacionApi {
  PanelActivacionApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Consume el enlace y entrega el secreto una sola vez. 410 `activation_invalid` con el mismo cuerpo para cualquier enlace inservible.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [PanelActivacionRequest] panelActivacionRequest (required):
  Future<Response> apiVversionPanelActivacionPostWithHttpInfo(String version, PanelActivacionRequest panelActivacionRequest, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/panel/activacion'
      .replaceAll('{version}', version);

    Object? postBody = panelActivacionRequest;

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

  /// Consume el enlace y entrega el secreto una sola vez. 410 `activation_invalid` con el mismo cuerpo para cualquier enlace inservible.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [PanelActivacionRequest] panelActivacionRequest (required):
  Future<PanelActivacionResponse?> apiVversionPanelActivacionPost(String version, PanelActivacionRequest panelActivacionRequest, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionPanelActivacionPostWithHttpInfo(version, panelActivacionRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PanelActivacionResponse',) as PanelActivacionResponse;
    
    }
    return null;
  }
}
