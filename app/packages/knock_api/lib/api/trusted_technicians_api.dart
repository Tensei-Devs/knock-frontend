//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class TrustedTechniciansApi {
  TrustedTechniciansApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Los técnicos guardados, del más reciente al más antiguo, con paginación por cursor. Un técnico oculto no aparece.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] cursor:
  ///   Opaque cursor returned as nextCursor by the previous page.
  ///
  /// * [int] limite:
  ///   Page size, 1 to 50. Defaults to 20.
  Future<Response> apiVversionMeTecnicosConfianzaGetWithHttpInfo(String version, { String? cursor, int? limite, Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/me/tecnicos-confianza'
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (cursor != null) {
      queryParams.addAll(_queryParams('', 'cursor', cursor));
    }
    if (limite != null) {
      queryParams.addAll(_queryParams('', 'limite', limite));
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

  /// Los técnicos guardados, del más reciente al más antiguo, con paginación por cursor. Un técnico oculto no aparece.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] cursor:
  ///   Opaque cursor returned as nextCursor by the previous page.
  ///
  /// * [int] limite:
  ///   Page size, 1 to 50. Defaults to 20.
  Future<TrustedTechnicianPage?> apiVversionMeTecnicosConfianzaGet(String version, { String? cursor, int? limite, Future<void>? abortTrigger, }) async {
    final response = await apiVversionMeTecnicosConfianzaGetWithHttpInfo(version, cursor: cursor, limite: limite, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'TrustedTechnicianPage',) as TrustedTechnicianPage;
    
    }
    return null;
  }

  /// Quita al técnico de la lista: 204; si no estaba, 404 `trusted_technician_not_found`.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] tecnicoId (required):
  ///
  /// * [String] version (required):
  Future<Response> apiVversionMeTecnicosConfianzaTecnicoIdDeleteWithHttpInfo(String tecnicoId, String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/me/tecnicos-confianza/{tecnicoId}'
      .replaceAll('{tecnicoId}', tecnicoId)
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

  /// Quita al técnico de la lista: 204; si no estaba, 404 `trusted_technician_not_found`.
  ///
  /// Parameters:
  ///
  /// * [String] tecnicoId (required):
  ///
  /// * [String] version (required):
  Future<void> apiVversionMeTecnicosConfianzaTecnicoIdDelete(String tecnicoId, String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionMeTecnicosConfianzaTecnicoIdDeleteWithHttpInfo(tecnicoId, version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Guarda al técnico: 201 la primera vez y 200 al repetir, sin duplicar. Un técnico que no existe o está oculto responde 404 `technician_not_found`.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] tecnicoId (required):
  ///
  /// * [String] version (required):
  Future<Response> apiVversionMeTecnicosConfianzaTecnicoIdPutWithHttpInfo(String tecnicoId, String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/me/tecnicos-confianza/{tecnicoId}'
      .replaceAll('{tecnicoId}', tecnicoId)
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


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

  /// Guarda al técnico: 201 la primera vez y 200 al repetir, sin duplicar. Un técnico que no existe o está oculto responde 404 `technician_not_found`.
  ///
  /// Parameters:
  ///
  /// * [String] tecnicoId (required):
  ///
  /// * [String] version (required):
  Future<TrustedTechnician?> apiVversionMeTecnicosConfianzaTecnicoIdPut(String tecnicoId, String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionMeTecnicosConfianzaTecnicoIdPutWithHttpInfo(tecnicoId, version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'TrustedTechnician',) as TrustedTechnician;
    
    }
    return null;
  }
}
