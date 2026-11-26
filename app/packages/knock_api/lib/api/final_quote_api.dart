//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class FinalQuoteApi {
  FinalQuoteApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// AJU-02: el cliente dueño aprueba o rechaza el ajuste; el precio cambia solo si aprueba.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [DecisionBody] decisionBody (required):
  Future<Response> apiVversionAjustesIdDecisionPostWithHttpInfo(String id, String version, DecisionBody decisionBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/ajustes/{id}/decision'
      .replaceAll('{id}', id)
      .replaceAll('{version}', version);

    Object? postBody = decisionBody;

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

  /// AJU-02: el cliente dueño aprueba o rechaza el ajuste; el precio cambia solo si aprueba.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [DecisionBody] decisionBody (required):
  Future<AdjustmentDecisionResponse?> apiVversionAjustesIdDecisionPost(String id, String version, DecisionBody decisionBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionAjustesIdDecisionPostWithHttpInfo(id, version, decisionBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdjustmentDecisionResponse',) as AdjustmentDecisionResponse;
    
    }
    return null;
  }

  /// AJU-01: el técnico de una cotización aceptada propone un monto mayor al tope, con motivo (un solo ajuste pendiente por cotización).
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [AdjustmentBody] adjustmentBody (required):
  Future<Response> apiVversionCotizacionesIdAjustePrecioPostWithHttpInfo(String id, String version, AdjustmentBody adjustmentBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/cotizaciones/{id}/ajuste-precio'
      .replaceAll('{id}', id)
      .replaceAll('{version}', version);

    Object? postBody = adjustmentBody;

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

  /// AJU-01: el técnico de una cotización aceptada propone un monto mayor al tope, con motivo (un solo ajuste pendiente por cotización).
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [AdjustmentBody] adjustmentBody (required):
  Future<AdjustmentResponse?> apiVversionCotizacionesIdAjustePrecioPost(String id, String version, AdjustmentBody adjustmentBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionCotizacionesIdAjustePrecioPostWithHttpInfo(id, version, adjustmentBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdjustmentResponse',) as AdjustmentResponse;
    
    }
    return null;
  }

  /// Lectura de los ajustes pendientes y vigentes de la visita (spec 063); sin ajustes responde 200 con la lista vacía.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  Future<Response> apiVversionVisitasIdAjustesPendientesGetWithHttpInfo(String id, String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/visitas/{id}/ajustes-pendientes'
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

  /// Lectura de los ajustes pendientes y vigentes de la visita (spec 063); sin ajustes responde 200 con la lista vacía.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  Future<PendingAdjustmentsResponse?> apiVversionVisitasIdAjustesPendientesGet(String id, String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionVisitasIdAjustesPendientesGetWithHttpInfo(id, version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PendingAdjustmentsResponse',) as PendingAdjustmentsResponse;
    
    }
    return null;
  }

  /// COT-07: el cliente dueño aprueba o rechaza la cotización final. La decisión es definitiva.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [DecisionBody] decisionBody (required):
  Future<Response> apiVversionVisitasIdCotizacionFinalDecisionPostWithHttpInfo(String id, String version, DecisionBody decisionBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/visitas/{id}/cotizacion-final/decision'
      .replaceAll('{id}', id)
      .replaceAll('{version}', version);

    Object? postBody = decisionBody;

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

  /// COT-07: el cliente dueño aprueba o rechaza la cotización final. La decisión es definitiva.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [DecisionBody] decisionBody (required):
  Future<FinalQuoteDecisionResponse?> apiVversionVisitasIdCotizacionFinalDecisionPost(String id, String version, DecisionBody decisionBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionVisitasIdCotizacionFinalDecisionPostWithHttpInfo(id, version, decisionBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'FinalQuoteDecisionResponse',) as FinalQuoteDecisionResponse;
    
    }
    return null;
  }

  /// Lectura de la cotización final (spec 063): el cliente dueño y el técnico de la visita; cualquier otra persona recibe el mismo 404.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  Future<Response> apiVversionVisitasIdCotizacionFinalGetWithHttpInfo(String id, String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/visitas/{id}/cotizacion-final'
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

  /// Lectura de la cotización final (spec 063): el cliente dueño y el técnico de la visita; cualquier otra persona recibe el mismo 404.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  Future<FinalQuoteReadResponse?> apiVversionVisitasIdCotizacionFinalGet(String id, String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionVisitasIdCotizacionFinalGetWithHttpInfo(id, version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'FinalQuoteReadResponse',) as FinalQuoteReadResponse;
    
    }
    return null;
  }

  /// COT-06: el técnico de la visita envía la cotización final (una sola por visita, con la visita en curso).
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [FinalQuoteBody] finalQuoteBody (required):
  Future<Response> apiVversionVisitasIdCotizacionFinalPostWithHttpInfo(String id, String version, FinalQuoteBody finalQuoteBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/visitas/{id}/cotizacion-final'
      .replaceAll('{id}', id)
      .replaceAll('{version}', version);

    Object? postBody = finalQuoteBody;

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

  /// COT-06: el técnico de la visita envía la cotización final (una sola por visita, con la visita en curso).
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [FinalQuoteBody] finalQuoteBody (required):
  Future<FinalQuoteResponse?> apiVversionVisitasIdCotizacionFinalPost(String id, String version, FinalQuoteBody finalQuoteBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionVisitasIdCotizacionFinalPostWithHttpInfo(id, version, finalQuoteBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'FinalQuoteResponse',) as FinalQuoteResponse;
    
    }
    return null;
  }
}
