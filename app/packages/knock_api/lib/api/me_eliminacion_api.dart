//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class MeEliminacionApi {
  MeEliminacionApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// USR-11. Cancela la eliminación durante los 7 días de gracia.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  Future<Response> apiVversionMeEliminacionCancelarPostWithHttpInfo(String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/me/eliminacion/cancelar'
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

  /// USR-11. Cancela la eliminación durante los 7 días de gracia.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  Future<void> apiVversionMeEliminacionCancelarPost(String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionMeEliminacionCancelarPostWithHttpInfo(version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// USR-10. Programa la eliminación con 7 días de gracia y cancela de inmediato las solicitudes abiertas y las cotizaciones pendientes. Se confirma con el texto `ELIMINAR`; con una sesión de más de 24 horas pide además el token de Firebase.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [DeleteAccountRequest] deleteAccountRequest (required):
  Future<Response> apiVversionMeEliminacionPostWithHttpInfo(String version, DeleteAccountRequest deleteAccountRequest, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/me/eliminacion'
      .replaceAll('{version}', version);

    Object? postBody = deleteAccountRequest;

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

  /// USR-10. Programa la eliminación con 7 días de gracia y cancela de inmediato las solicitudes abiertas y las cotizaciones pendientes. Se confirma con el texto `ELIMINAR`; con una sesión de más de 24 horas pide además el token de Firebase.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [DeleteAccountRequest] deleteAccountRequest (required):
  Future<DeletionScheduledResponse?> apiVversionMeEliminacionPost(String version, DeleteAccountRequest deleteAccountRequest, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionMeEliminacionPostWithHttpInfo(version, deleteAccountRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'DeletionScheduledResponse',) as DeletionScheduledResponse;
    
    }
    return null;
  }
}
