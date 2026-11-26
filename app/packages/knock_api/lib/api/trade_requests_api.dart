//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class TradeRequestsApi {
  TradeRequestsApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Guarda el oficio escrito en «Otro oficio» (OFP-01): 201 con el registro. Repetir el mismo texto (ignorando acentos, mayúsculas y espacios) devuelve el registro existente. Quien no tiene perfil de técnico recibe 404 sin más datos; un cuerpo ilegible, 400; un texto inválido, 422 `errors.texto`.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [TradeRequestBody] tradeRequestBody (required):
  Future<Response> apiVversionOficiosPedidosPostWithHttpInfo(String version, TradeRequestBody tradeRequestBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/oficios-pedidos'
      .replaceAll('{version}', version);

    Object? postBody = tradeRequestBody;

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

  /// Guarda el oficio escrito en «Otro oficio» (OFP-01): 201 con el registro. Repetir el mismo texto (ignorando acentos, mayúsculas y espacios) devuelve el registro existente. Quien no tiene perfil de técnico recibe 404 sin más datos; un cuerpo ilegible, 400; un texto inválido, 422 `errors.texto`.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [TradeRequestBody] tradeRequestBody (required):
  Future<TradeRequestResponse?> apiVversionOficiosPedidosPost(String version, TradeRequestBody tradeRequestBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionOficiosPedidosPostWithHttpInfo(version, tradeRequestBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'TradeRequestResponse',) as TradeRequestResponse;
    
    }
    return null;
  }
}
