//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class MePreferenciasAvisosApi {
  MePreferenciasAvisosApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Un interruptor por tipo; sin cambios guardados, todos activos salvo promociones; seguridad siempre activa y no apagable.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  Future<Response> apiVversionMePreferenciasAvisosGetWithHttpInfo(String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/me/preferencias-avisos'
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

  /// Un interruptor por tipo; sin cambios guardados, todos activos salvo promociones; seguridad siempre activa y no apagable.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  Future<NoticePreferencesResponse?> apiVversionMePreferenciasAvisosGet(String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionMePreferenciasAvisosGetWithHttpInfo(version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'NoticePreferencesResponse',) as NoticePreferencesResponse;
    
    }
    return null;
  }

  /// Cambia los interruptores indicados y devuelve las preferencias vigentes. Los avisos de seguridad no se pueden apagar (422).
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [UpdateNoticePreferencesRequest] updateNoticePreferencesRequest (required):
  Future<Response> apiVversionMePreferenciasAvisosPutWithHttpInfo(String version, UpdateNoticePreferencesRequest updateNoticePreferencesRequest, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/me/preferencias-avisos'
      .replaceAll('{version}', version);

    Object? postBody = updateNoticePreferencesRequest;

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

  /// Cambia los interruptores indicados y devuelve las preferencias vigentes. Los avisos de seguridad no se pueden apagar (422).
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [UpdateNoticePreferencesRequest] updateNoticePreferencesRequest (required):
  Future<NoticePreferencesResponse?> apiVversionMePreferenciasAvisosPut(String version, UpdateNoticePreferencesRequest updateNoticePreferencesRequest, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionMePreferenciasAvisosPutWithHttpInfo(version, updateNoticePreferencesRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'NoticePreferencesResponse',) as NoticePreferencesResponse;
    
    }
    return null;
  }
}
