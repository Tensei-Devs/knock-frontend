//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class VisitScheduleApi {
  VisitScheduleApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// VIS-02: agenda del técnico entre `desde` y `hasta` (por omisión hoy y 14 días), por fecha y hora, con cursor.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] desde:
  ///   First day of the range, yyyy-MM-dd. Defaults to today.
  ///
  /// * [String] hasta:
  ///   Last day of the range, yyyy-MM-dd. Defaults to 14 days after the first day. The range is 31 days at most.
  ///
  /// * [String] cursor:
  ///   Opaque cursor returned as nextCursor by the previous page.
  ///
  /// * [int] limite:
  ///   Page size, 1 to 50. Defaults to 20.
  Future<Response> apiVversionAgendaGetWithHttpInfo(String version, { String? desde, String? hasta, String? cursor, int? limite, Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/agenda'
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (desde != null) {
      queryParams.addAll(_queryParams('', 'Desde', desde));
    }
    if (hasta != null) {
      queryParams.addAll(_queryParams('', 'Hasta', hasta));
    }
    if (cursor != null) {
      queryParams.addAll(_queryParams('', 'Cursor', cursor));
    }
    if (limite != null) {
      queryParams.addAll(_queryParams('', 'Limite', limite));
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

  /// VIS-02: agenda del técnico entre `desde` y `hasta` (por omisión hoy y 14 días), por fecha y hora, con cursor.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] desde:
  ///   First day of the range, yyyy-MM-dd. Defaults to today.
  ///
  /// * [String] hasta:
  ///   Last day of the range, yyyy-MM-dd. Defaults to 14 days after the first day. The range is 31 days at most.
  ///
  /// * [String] cursor:
  ///   Opaque cursor returned as nextCursor by the previous page.
  ///
  /// * [int] limite:
  ///   Page size, 1 to 50. Defaults to 20.
  Future<AgendaResponse?> apiVversionAgendaGet(String version, { String? desde, String? hasta, String? cursor, int? limite, Future<void>? abortTrigger, }) async {
    final response = await apiVversionAgendaGetWithHttpInfo(version, desde: desde, hasta: hasta, cursor: cursor, limite: limite, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AgendaResponse',) as AgendaResponse;
    
    }
    return null;
  }

  /// VIS-06: cancela con motivo obligatorio; con menos de 24 horas queda `tardia`.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [CancelVisitBody] cancelVisitBody (required):
  Future<Response> apiVversionVisitasIdCancelarPostWithHttpInfo(String id, String version, CancelVisitBody cancelVisitBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/visitas/{id}/cancelar'
      .replaceAll('{id}', id)
      .replaceAll('{version}', version);

    Object? postBody = cancelVisitBody;

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

  /// VIS-06: cancela con motivo obligatorio; con menos de 24 horas queda `tardia`.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [CancelVisitBody] cancelVisitBody (required):
  Future<CancelVisitResponse?> apiVversionVisitasIdCancelarPost(String id, String version, CancelVisitBody cancelVisitBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionVisitasIdCancelarPostWithHttpInfo(id, version, cancelVisitBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CancelVisitResponse',) as CancelVisitResponse;
    
    }
    return null;
  }

  /// VIS-07: el técnico registra que el cliente no estaba, dentro de la ventana de la cita y sin penalizar.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  Future<Response> apiVversionVisitasIdClienteAusentePostWithHttpInfo(String id, String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/visitas/{id}/cliente-ausente'
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

  /// VIS-07: el técnico registra que el cliente no estaba, dentro de la ventana de la cita y sin penalizar.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  Future<ClientAbsentResponse?> apiVversionVisitasIdClienteAusentePost(String id, String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionVisitasIdClienteAusentePostWithHttpInfo(id, version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ClientAbsentResponse',) as ClientAbsentResponse;
    
    }
    return null;
  }

  /// VIS-10: el cliente reporta que no se terminó, una sola vez y hasta 7 días después.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [NotFinishedBody] notFinishedBody (required):
  Future<Response> apiVversionVisitasIdNoTerminadoPostWithHttpInfo(String id, String version, NotFinishedBody notFinishedBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/visitas/{id}/no-terminado'
      .replaceAll('{id}', id)
      .replaceAll('{version}', version);

    Object? postBody = notFinishedBody;

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

  /// VIS-10: el cliente reporta que no se terminó, una sola vez y hasta 7 días después.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [NotFinishedBody] notFinishedBody (required):
  Future<NotFinishedResponse?> apiVversionVisitasIdNoTerminadoPost(String id, String version, NotFinishedBody notFinishedBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionVisitasIdNoTerminadoPostWithHttpInfo(id, version, notFinishedBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'NotFinishedResponse',) as NotFinishedResponse;
    
    }
    return null;
  }

  /// VIS-11: el cliente autoriza o no publicar las fotos del trabajo.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [PhotoPermissionBody] photoPermissionBody (required):
  Future<Response> apiVversionVisitasIdPermisoFotosPutWithHttpInfo(String id, String version, PhotoPermissionBody photoPermissionBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/visitas/{id}/permiso-fotos'
      .replaceAll('{id}', id)
      .replaceAll('{version}', version);

    Object? postBody = photoPermissionBody;

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

  /// VIS-11: el cliente autoriza o no publicar las fotos del trabajo.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [PhotoPermissionBody] photoPermissionBody (required):
  Future<PhotoPermissionResponse?> apiVversionVisitasIdPermisoFotosPut(String id, String version, PhotoPermissionBody photoPermissionBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionVisitasIdPermisoFotosPutWithHttpInfo(id, version, photoPermissionBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PhotoPermissionResponse',) as PhotoPermissionResponse;
    
    }
    return null;
  }

  /// VIS-04: una parte propone otra fecha para la visita.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [RescheduleBody] rescheduleBody (required):
  Future<Response> apiVversionVisitasIdReprogramarPostWithHttpInfo(String id, String version, RescheduleBody rescheduleBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/visitas/{id}/reprogramar'
      .replaceAll('{id}', id)
      .replaceAll('{version}', version);

    Object? postBody = rescheduleBody;

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

  /// VIS-04: una parte propone otra fecha para la visita.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [RescheduleBody] rescheduleBody (required):
  Future<RescheduleProposalResponse?> apiVversionVisitasIdReprogramarPost(String id, String version, RescheduleBody rescheduleBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionVisitasIdReprogramarPostWithHttpInfo(id, version, rescheduleBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'RescheduleProposalResponse',) as RescheduleProposalResponse;
    
    }
    return null;
  }

  /// VIS-05: la otra parte confirma o rechaza la propuesta.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [RescheduleReplyBody] rescheduleReplyBody (required):
  Future<Response> apiVversionVisitasIdReprogramarRespuestaPostWithHttpInfo(String id, String version, RescheduleReplyBody rescheduleReplyBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/visitas/{id}/reprogramar/respuesta'
      .replaceAll('{id}', id)
      .replaceAll('{version}', version);

    Object? postBody = rescheduleReplyBody;

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

  /// VIS-05: la otra parte confirma o rechaza la propuesta.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [RescheduleReplyBody] rescheduleReplyBody (required):
  Future<RescheduleReplyResponse?> apiVversionVisitasIdReprogramarRespuestaPost(String id, String version, RescheduleReplyBody rescheduleReplyBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionVisitasIdReprogramarRespuestaPostWithHttpInfo(id, version, rescheduleReplyBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'RescheduleReplyResponse',) as RescheduleReplyResponse;
    
    }
    return null;
  }

  /// VIS-12 (spec 064): el cliente dueño reporta que el técnico no llegó, dentro de la ventana de la cita. Sin cuerpo; repetirlo es idempotente.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  Future<Response> apiVversionVisitasIdTecnicoAusentePostWithHttpInfo(String id, String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/visitas/{id}/tecnico-ausente'
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

  /// VIS-12 (spec 064): el cliente dueño reporta que el técnico no llegó, dentro de la ventana de la cita. Sin cuerpo; repetirlo es idempotente.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  Future<TechnicianAbsentResponse?> apiVversionVisitasIdTecnicoAusentePost(String id, String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionVisitasIdTecnicoAusentePostWithHttpInfo(id, version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'TechnicianAbsentResponse',) as TechnicianAbsentResponse;
    
    }
    return null;
  }

  /// VIS-09: el técnico termina la visita en curso con descripción y fotos; no hay confirmación del cliente.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [FinishVisitBody] finishVisitBody (required):
  Future<Response> apiVversionVisitasIdTerminarPostWithHttpInfo(String id, String version, FinishVisitBody finishVisitBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/visitas/{id}/terminar'
      .replaceAll('{id}', id)
      .replaceAll('{version}', version);

    Object? postBody = finishVisitBody;

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

  /// VIS-09: el técnico termina la visita en curso con descripción y fotos; no hay confirmación del cliente.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [FinishVisitBody] finishVisitBody (required):
  Future<FinishVisitResponse?> apiVversionVisitasIdTerminarPost(String id, String version, FinishVisitBody finishVisitBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionVisitasIdTerminarPostWithHttpInfo(id, version, finishVisitBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'FinishVisitResponse',) as FinishVisitResponse;
    
    }
    return null;
  }
}
