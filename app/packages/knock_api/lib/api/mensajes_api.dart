//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class MensajesApi {
  MensajesApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Envía un mensaje: oculta datos de contacto antes de elegir, lo modera y lo guarda; luego lo entrega en vivo.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [EnviarMensajeRequest] enviarMensajeRequest (required):
  Future<Response> apiVversionConversacionesIdMensajesPostWithHttpInfo(String id, String version, EnviarMensajeRequest enviarMensajeRequest, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/conversaciones/{id}/mensajes'
      .replaceAll('{id}', id)
      .replaceAll('{version}', version);

    Object? postBody = enviarMensajeRequest;

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

  /// Envía un mensaje: oculta datos de contacto antes de elegir, lo modera y lo guarda; luego lo entrega en vivo.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [EnviarMensajeRequest] enviarMensajeRequest (required):
  Future<MensajeResponse?> apiVversionConversacionesIdMensajesPost(String id, String version, EnviarMensajeRequest enviarMensajeRequest, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionConversacionesIdMensajesPostWithHttpInfo(id, version, enviarMensajeRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'MensajeResponse',) as MensajeResponse;
    
    }
    return null;
  }
}
