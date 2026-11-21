//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class MeCambioNumeroApi {
  MeCambioNumeroApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// USR-04. Confirma el cambio con el token de Firebase del número nuevo, cambia el celular y cierra las demás sesiones.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [ConfirmPhoneChangeRequest] confirmPhoneChangeRequest (required):
  Future<Response> apiVversionMeCambioNumeroConfirmarPostWithHttpInfo(String version, ConfirmPhoneChangeRequest confirmPhoneChangeRequest, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/me/cambio-numero/confirmar'
      .replaceAll('{version}', version);

    Object? postBody = confirmPhoneChangeRequest;

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

  /// USR-04. Confirma el cambio con el token de Firebase del número nuevo, cambia el celular y cierra las demás sesiones.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [ConfirmPhoneChangeRequest] confirmPhoneChangeRequest (required):
  Future<void> apiVversionMeCambioNumeroConfirmarPost(String version, ConfirmPhoneChangeRequest confirmPhoneChangeRequest, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionMeCambioNumeroConfirmarPostWithHttpInfo(version, confirmPhoneChangeRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// USR-03. Comprueba que el número nuevo no pertenece a otra cuenta, antes de que la app gaste un SMS de Firebase.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [PhoneAvailabilityRequest] phoneAvailabilityRequest (required):
  Future<Response> apiVversionMeCambioNumeroPostWithHttpInfo(String version, PhoneAvailabilityRequest phoneAvailabilityRequest, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/me/cambio-numero'
      .replaceAll('{version}', version);

    Object? postBody = phoneAvailabilityRequest;

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

  /// USR-03. Comprueba que el número nuevo no pertenece a otra cuenta, antes de que la app gaste un SMS de Firebase.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [PhoneAvailabilityRequest] phoneAvailabilityRequest (required):
  Future<void> apiVversionMeCambioNumeroPost(String version, PhoneAvailabilityRequest phoneAvailabilityRequest, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionMeCambioNumeroPostWithHttpInfo(version, phoneAvailabilityRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }
}
