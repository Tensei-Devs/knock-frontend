//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class ConversationPermissionApi {
  ConversationPermissionApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// El permiso del par (solicitud, técnico) para quien pide: el cliente dueño debe mandar `tecnicoId`; el técnico no (se ignora si lo manda). Cualquier otro caso es 404 uniforme.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [String] tecnicoId:
  Future<Response> apiVversionSolicitudesIdConversacionGetWithHttpInfo(String id, String version, { String? tecnicoId, Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/solicitudes/{id}/conversacion'
      .replaceAll('{id}', id)
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (tecnicoId != null) {
      queryParams.addAll(_queryParams('', 'tecnicoId', tecnicoId));
    }

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

  /// El permiso del par (solicitud, técnico) para quien pide: el cliente dueño debe mandar `tecnicoId`; el técnico no (se ignora si lo manda). Cualquier otro caso es 404 uniforme.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [String] tecnicoId:
  Future<PermisoConversacion?> apiVversionSolicitudesIdConversacionGet(String id, String version, { String? tecnicoId, Future<void>? abortTrigger, }) async {
    final response = await apiVversionSolicitudesIdConversacionGetWithHttpInfo(id, version, tecnicoId: tecnicoId, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PermisoConversacion',) as PermisoConversacion;
    
    }
    return null;
  }
}
