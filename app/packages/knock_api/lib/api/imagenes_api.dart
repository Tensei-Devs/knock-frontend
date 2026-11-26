//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class ImagenesApi {
  ImagenesApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Performs an HTTP 'POST /api/v{version}/imagenes/subidas/{id}/confirmar' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  Future<Response> apiVversionImagenesSubidasIdConfirmarPostWithHttpInfo(String id, String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/imagenes/subidas/{id}/confirmar'
      .replaceAll('{id}', id)
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

  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  Future<ImagenConfirmadaResponse?> apiVversionImagenesSubidasIdConfirmarPost(String id, String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionImagenesSubidasIdConfirmarPostWithHttpInfo(id, version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ImagenConfirmadaResponse',) as ImagenConfirmadaResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'POST /api/v{version}/imagenes/subidas' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [PedirSubidaImagenRequest] pedirSubidaImagenRequest (required):
  Future<Response> apiVversionImagenesSubidasPostWithHttpInfo(String version, PedirSubidaImagenRequest pedirSubidaImagenRequest, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/imagenes/subidas'
      .replaceAll('{version}', version);

    Object? postBody = pedirSubidaImagenRequest;

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

  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [PedirSubidaImagenRequest] pedirSubidaImagenRequest (required):
  Future<SubidaImagenResponse?> apiVversionImagenesSubidasPost(String version, PedirSubidaImagenRequest pedirSubidaImagenRequest, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionImagenesSubidasPostWithHttpInfo(version, pedirSubidaImagenRequest, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'SubidaImagenResponse',) as SubidaImagenResponse;
    
    }
    return null;
  }
}
