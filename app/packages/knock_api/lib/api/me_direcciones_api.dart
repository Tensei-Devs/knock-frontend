//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class MeDireccionesApi {
  MeDireccionesApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Lista las direcciones de quien llama, la más reciente primero. Sin paginar: una persona tiene pocas.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  Future<Response> apiVversionMeDireccionesGetWithHttpInfo(String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/me/direcciones'
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

  /// Lista las direcciones de quien llama, la más reciente primero. Sin paginar: una persona tiene pocas.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  Future<List<AddressResponse>?> apiVversionMeDireccionesGet(String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionMeDireccionesGetWithHttpInfo(version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<AddressResponse>') as List)
        .cast<AddressResponse>()
        .toList(growable: false);

    }
    return null;
  }

  /// Elimina una dirección propia. Una dirección ajena responde 404 igual que una que no existe (R-14).
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  Future<Response> apiVversionMeDireccionesIdDeleteWithHttpInfo(String id, String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/me/direcciones/{id}'
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

  /// Elimina una dirección propia. Una dirección ajena responde 404 igual que una que no existe (R-14).
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  Future<void> apiVversionMeDireccionesIdDelete(String id, String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionMeDireccionesIdDeleteWithHttpInfo(id, version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Edita los campos enviados de una dirección propia. Una dirección ajena responde 404 igual que una que no existe (R-14).
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [UpdateAddressRequest] updateAddressRequest (required):
  Future<Response> apiVversionMeDireccionesIdPutWithHttpInfo(String id, String version, UpdateAddressRequest updateAddressRequest, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/me/direcciones/{id}'
      .replaceAll('{id}', id)
      .replaceAll('{version}', version);

    Object? postBody = updateAddressRequest;

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

  /// Edita los campos enviados de una dirección propia. Una dirección ajena responde 404 igual que una que no existe (R-14).
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [UpdateAddressRequest] updateAddressRequest (required):
  Future<AddressResponse?> apiVversionMeDireccionesIdPut(String id, String version, UpdateAddressRequest updateAddressRequest, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionMeDireccionesIdPutWithHttpInfo(id, version, updateAddressRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AddressResponse',) as AddressResponse;
    
    }
    return null;
  }

  /// Guarda una dirección nueva. Un valor inválido responde 422 con `errors.&lt;campo&gt;` sin repetirlo; una colonia que no está en el catálogo, 422 en `errors.colonia`.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [CreateAddressRequest] createAddressRequest (required):
  Future<Response> apiVversionMeDireccionesPostWithHttpInfo(String version, CreateAddressRequest createAddressRequest, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/me/direcciones'
      .replaceAll('{version}', version);

    Object? postBody = createAddressRequest;

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

  /// Guarda una dirección nueva. Un valor inválido responde 422 con `errors.&lt;campo&gt;` sin repetirlo; una colonia que no está en el catálogo, 422 en `errors.colonia`.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [CreateAddressRequest] createAddressRequest (required):
  Future<AddressResponse?> apiVversionMeDireccionesPost(String version, CreateAddressRequest createAddressRequest, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionMeDireccionesPostWithHttpInfo(version, createAddressRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AddressResponse',) as AddressResponse;
    
    }
    return null;
  }
}
