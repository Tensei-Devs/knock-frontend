//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class FotosVerificacionApi {
  FotosVerificacionApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Performs an HTTP 'POST /api/v{version}/me/verificacion/{id}/fotos/{tipo}/confirmar' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] tipo (required):
  ///
  /// * [String] version (required):
  Future<Response> apiVversionMeVerificacionIdFotosTipoConfirmarPostWithHttpInfo(String id, String tipo, String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/me/verificacion/{id}/fotos/{tipo}/confirmar'
      .replaceAll('{id}', id)
      .replaceAll('{tipo}', tipo)
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
  /// * [String] tipo (required):
  ///
  /// * [String] version (required):
  Future<PhotoConfirmedResponse?> apiVversionMeVerificacionIdFotosTipoConfirmarPost(String id, String tipo, String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionMeVerificacionIdFotosTipoConfirmarPostWithHttpInfo(id, tipo, version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PhotoConfirmedResponse',) as PhotoConfirmedResponse;
    
    }
    return null;
  }
}
