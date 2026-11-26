//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class DispositivosApi {
  DispositivosApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Borra el dispositivo de la persona (spec 037, R-02): 204 también si ya no existe o es de otra persona.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  Future<Response> apiVversionDispositivosIdDeleteWithHttpInfo(String id, String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/dispositivos/{id}'
      .replaceAll('{id}', id)
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      abortTrigger: abortTrigger,
    );
  }

  /// Borra el dispositivo de la persona (spec 037, R-02): 204 también si ya no existe o es de otra persona.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  Future<void> apiVversionDispositivosIdDelete(String id, String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionDispositivosIdDeleteWithHttpInfo(id, version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Registra el token de notificaciones del dispositivo (spec 037, R-01): 201 la primera vez, 200 si ya estaba. 409 `device_conflict` si otra persona lo registró a la vez; 503 `devices_unavailable` con el registro de dispositivos apagado (sin llaves de cifrado); 20 por hora por persona.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [RegistroDispositivo] registroDispositivo (required):
  Future<Response> apiVversionDispositivosPostWithHttpInfo(String version, RegistroDispositivo registroDispositivo, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/dispositivos'
      .replaceAll('{version}', version);

    Object? postBody = registroDispositivo;

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

  /// Registra el token de notificaciones del dispositivo (spec 037, R-01): 201 la primera vez, 200 si ya estaba. 409 `device_conflict` si otra persona lo registró a la vez; 503 `devices_unavailable` con el registro de dispositivos apagado (sin llaves de cifrado); 20 por hora por persona.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [RegistroDispositivo] registroDispositivo (required):
  Future<IdDispositivo?> apiVversionDispositivosPost(String version, RegistroDispositivo registroDispositivo, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionDispositivosPostWithHttpInfo(version, registroDispositivo, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'IdDispositivo',) as IdDispositivo;
    
    }
    return null;
  }
}
