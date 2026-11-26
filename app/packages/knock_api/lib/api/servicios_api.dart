//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class ServiciosApi {
  ServiciosApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Servicios y precios de referencia de un técnico visible (SRV-01), para cualquier persona con sesión.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  Future<Response> apiVversionTecnicosIdServiciosGetWithHttpInfo(String id, String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/tecnicos/{id}/servicios'
      .replaceAll('{id}', id)
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

  /// Servicios y precios de referencia de un técnico visible (SRV-01), para cualquier persona con sesión.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  Future<TechnicianServiceList?> apiVversionTecnicosIdServiciosGet(String id, String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionTecnicosIdServiciosGetWithHttpInfo(id, version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'TechnicianServiceList',) as TechnicianServiceList;
    
    }
    return null;
  }

  /// Quita un servicio propio (SRV-04): 204; uno ajeno o inexistente responde 404 `service_not_found`.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  Future<Response> apiVversionTecnicosMeServiciosIdDeleteWithHttpInfo(String id, String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/tecnicos/me/servicios/{id}'
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

  /// Quita un servicio propio (SRV-04): 204; uno ajeno o inexistente responde 404 `service_not_found`.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  Future<void> apiVversionTecnicosMeServiciosIdDelete(String id, String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionTecnicosMeServiciosIdDeleteWithHttpInfo(id, version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Edita un servicio propio (SRV-03): cambian solo los campos enviados.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [UpdateServiceBody] updateServiceBody (required):
  Future<Response> apiVversionTecnicosMeServiciosIdPutWithHttpInfo(String id, String version, UpdateServiceBody updateServiceBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/tecnicos/me/servicios/{id}'
      .replaceAll('{id}', id)
      .replaceAll('{version}', version);

    Object? postBody = updateServiceBody;

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

  /// Edita un servicio propio (SRV-03): cambian solo los campos enviados.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [UpdateServiceBody] updateServiceBody (required):
  Future<TechnicianService?> apiVversionTecnicosMeServiciosIdPut(String id, String version, UpdateServiceBody updateServiceBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionTecnicosMeServiciosIdPutWithHttpInfo(id, version, updateServiceBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'TechnicianService',) as TechnicianService;
    
    }
    return null;
  }

  /// Agrega un servicio (SRV-02): 201; el 51.º responde 409 `service_limit_reached`.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [CreateServiceBody] createServiceBody (required):
  Future<Response> apiVversionTecnicosMeServiciosPostWithHttpInfo(String version, CreateServiceBody createServiceBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/tecnicos/me/servicios'
      .replaceAll('{version}', version);

    Object? postBody = createServiceBody;

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

  /// Agrega un servicio (SRV-02): 201; el 51.º responde 409 `service_limit_reached`.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [CreateServiceBody] createServiceBody (required):
  Future<TechnicianService?> apiVversionTecnicosMeServiciosPost(String version, CreateServiceBody createServiceBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionTecnicosMeServiciosPostWithHttpInfo(version, createServiceBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'TechnicianService',) as TechnicianService;
    
    }
    return null;
  }
}
