//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class CancelacionApi {
  CancelacionApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Cancela la solicitud del cliente mientras no tenga cita. Es idempotente: repetirla devuelve el mismo cuerpo sin otro evento.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [CancelRequestBody] cancelRequestBody:
  Future<Response> apiVversionSolicitudesIdCancelarPostWithHttpInfo(String id, String version, { CancelRequestBody? cancelRequestBody, Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/solicitudes/{id}/cancelar'
      .replaceAll('{id}', id)
      .replaceAll('{version}', version);

    Object? postBody = cancelRequestBody;

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

  /// Cancela la solicitud del cliente mientras no tenga cita. Es idempotente: repetirla devuelve el mismo cuerpo sin otro evento.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [CancelRequestBody] cancelRequestBody:
  Future<CancelRequestResponse?> apiVversionSolicitudesIdCancelarPost(String id, String version, { CancelRequestBody? cancelRequestBody, Future<void>? abortTrigger, }) async {
    final response = await apiVversionSolicitudesIdCancelarPostWithHttpInfo(id, version, cancelRequestBody: cancelRequestBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CancelRequestResponse',) as CancelRequestResponse;
    
    }
    return null;
  }
}
