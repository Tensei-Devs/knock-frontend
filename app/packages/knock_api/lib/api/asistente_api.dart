//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class AsistenteApi {
  AsistenteApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// ASI-06: lee la bitácora propia; la de otro técnico responde 404 `log_not_found`.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] solicitudId (required):
  ///
  /// * [String] version (required):
  Future<Response> apiVversionAsistenteBitacoraSolicitudIdGetWithHttpInfo(String solicitudId, String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/asistente/bitacora/{solicitudId}'
      .replaceAll('{solicitudId}', solicitudId)
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

  /// ASI-06: lee la bitácora propia; la de otro técnico responde 404 `log_not_found`.
  ///
  /// Parameters:
  ///
  /// * [String] solicitudId (required):
  ///
  /// * [String] version (required):
  Future<BitacoraResponse?> apiVversionAsistenteBitacoraSolicitudIdGet(String solicitudId, String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionAsistenteBitacoraSolicitudIdGetWithHttpInfo(solicitudId, version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'BitacoraResponse',) as BitacoraResponse;
    
    }
    return null;
  }

  /// ASI-05: guarda o reemplaza la bitácora del técnico (201 al crear, 200 al reemplazar).
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] solicitudId (required):
  ///
  /// * [String] version (required):
  ///
  /// * [BitacoraBody] bitacoraBody (required):
  Future<Response> apiVversionAsistenteBitacoraSolicitudIdPutWithHttpInfo(String solicitudId, String version, BitacoraBody bitacoraBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/asistente/bitacora/{solicitudId}'
      .replaceAll('{solicitudId}', solicitudId)
      .replaceAll('{version}', version);

    Object? postBody = bitacoraBody;

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

  /// ASI-05: guarda o reemplaza la bitácora del técnico (201 al crear, 200 al reemplazar).
  ///
  /// Parameters:
  ///
  /// * [String] solicitudId (required):
  ///
  /// * [String] version (required):
  ///
  /// * [BitacoraBody] bitacoraBody (required):
  Future<BitacoraResponse?> apiVversionAsistenteBitacoraSolicitudIdPut(String solicitudId, String version, BitacoraBody bitacoraBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionAsistenteBitacoraSolicitudIdPutWithHttpInfo(solicitudId, version, bitacoraBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'BitacoraResponse',) as BitacoraResponse;
    
    }
    return null;
  }

  /// ASI-03: borrador editable de cotización; nunca se envía ni se guarda como cotización.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [ConversacionBody] conversacionBody (required):
  Future<Response> apiVversionAsistenteBorradorCotizacionPostWithHttpInfo(String version, ConversacionBody conversacionBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/asistente/borrador-cotizacion'
      .replaceAll('{version}', version);

    Object? postBody = conversacionBody;

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

  /// ASI-03: borrador editable de cotización; nunca se envía ni se guarda como cotización.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [ConversacionBody] conversacionBody (required):
  Future<BorradorCotizacionResponse?> apiVversionAsistenteBorradorCotizacionPost(String version, ConversacionBody conversacionBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionAsistenteBorradorCotizacionPostWithHttpInfo(version, conversacionBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'BorradorCotizacionResponse',) as BorradorCotizacionResponse;
    
    }
    return null;
  }

  /// ASI-01: un turno con el asistente Knock (cliente o técnico).
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [TurnoBody] turnoBody (required):
  Future<Response> apiVversionAsistenteConversacionesPostWithHttpInfo(String version, TurnoBody turnoBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/asistente/conversaciones'
      .replaceAll('{version}', version);

    Object? postBody = turnoBody;

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

  /// ASI-01: un turno con el asistente Knock (cliente o técnico).
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [TurnoBody] turnoBody (required):
  Future<TurnoResponse?> apiVversionAsistenteConversacionesPost(String version, TurnoBody turnoBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionAsistenteConversacionesPostWithHttpInfo(version, turnoBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'TurnoResponse',) as TurnoResponse;
    
    }
    return null;
  }

  /// ASI-04: rango de precio de la referencia de mercado (spec 048), en caché de 1 hora.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] oficio:
  ///
  /// * [String] tipoTrabajo:
  Future<Response> apiVversionAsistenteRangoPrecioGetWithHttpInfo(String version, { String? oficio, String? tipoTrabajo, Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/asistente/rango-precio'
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (oficio != null) {
      queryParams.addAll(_queryParams('', 'oficio', oficio));
    }
    if (tipoTrabajo != null) {
      queryParams.addAll(_queryParams('', 'tipoTrabajo', tipoTrabajo));
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

  /// ASI-04: rango de precio de la referencia de mercado (spec 048), en caché de 1 hora.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] oficio:
  ///
  /// * [String] tipoTrabajo:
  Future<RangoPrecioResponse?> apiVversionAsistenteRangoPrecioGet(String version, { String? oficio, String? tipoTrabajo, Future<void>? abortTrigger, }) async {
    final response = await apiVversionAsistenteRangoPrecioGetWithHttpInfo(version, oficio: oficio, tipoTrabajo: tipoTrabajo, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'RangoPrecioResponse',) as RangoPrecioResponse;
    
    }
    return null;
  }

  /// ASI-02: resumen de una conversación en la que el técnico participa.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [ConversacionBody] conversacionBody (required):
  Future<Response> apiVversionAsistenteResumenChatPostWithHttpInfo(String version, ConversacionBody conversacionBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/asistente/resumen-chat'
      .replaceAll('{version}', version);

    Object? postBody = conversacionBody;

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

  /// ASI-02: resumen de una conversación en la que el técnico participa.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [ConversacionBody] conversacionBody (required):
  Future<ResumenChatResponse?> apiVversionAsistenteResumenChatPost(String version, ConversacionBody conversacionBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionAsistenteResumenChatPostWithHttpInfo(version, conversacionBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ResumenChatResponse',) as ResumenChatResponse;
    
    }
    return null;
  }
}
