//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class ChooseQuoteApi {
  ChooseQuoteApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Elige la cotización de una solicitud propia; la elección y sus efectos ocurren en una sola transacción.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [ChooseQuoteBody] chooseQuoteBody (required):
  Future<Response> apiVversionSolicitudesIdElegirPostWithHttpInfo(String id, String version, ChooseQuoteBody chooseQuoteBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/solicitudes/{id}/elegir'
      .replaceAll('{id}', id)
      .replaceAll('{version}', version);

    Object? postBody = chooseQuoteBody;

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

  /// Elige la cotización de una solicitud propia; la elección y sus efectos ocurren en una sola transacción.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [ChooseQuoteBody] chooseQuoteBody (required):
  Future<Appointment?> apiVversionSolicitudesIdElegirPost(String id, String version, ChooseQuoteBody chooseQuoteBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionSolicitudesIdElegirPostWithHttpInfo(id, version, chooseQuoteBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Appointment',) as Appointment;
    
    }
    return null;
  }
}
