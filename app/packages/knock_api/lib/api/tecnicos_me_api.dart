//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class TecnicosMeApi {
  TecnicosMeApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Enciende o apaga «Disponible hoy» (TEC-09).
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [AvailabilityBody] availabilityBody (required):
  Future<Response> apiVversionTecnicosMeDisponibilidadPutWithHttpInfo(String version, AvailabilityBody availabilityBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/tecnicos/me/disponibilidad'
      .replaceAll('{version}', version);

    Object? postBody = availabilityBody;

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

  /// Enciende o apaga «Disponible hoy» (TEC-09).
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [AvailabilityBody] availabilityBody (required):
  Future<AvailabilityResponse?> apiVversionTecnicosMeDisponibilidadPut(String version, AvailabilityBody availabilityBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionTecnicosMeDisponibilidadPutWithHttpInfo(version, availabilityBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AvailabilityResponse',) as AvailabilityResponse;
    
    }
    return null;
  }

  /// Perfil propio (TEC-15), con la foto y la dirección del taller; una cuenta sin perfil de técnico recibe 404.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  Future<Response> apiVversionTecnicosMeGetWithHttpInfo(String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/tecnicos/me'
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

  /// Perfil propio (TEC-15), con la foto y la dirección del taller; una cuenta sin perfil de técnico recibe 404.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  Future<MyTechnicianProfileResponse?> apiVversionTecnicosMeGet(String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionTecnicosMeGetWithHttpInfo(version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'MyTechnicianProfileResponse',) as MyTechnicianProfileResponse;
    
    }
    return null;
  }

  /// Horarios de los siete días (TEC-10); sin horario guardado, todos cerrados.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  Future<Response> apiVversionTecnicosMeHorariosGetWithHttpInfo(String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/tecnicos/me/horarios'
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

  /// Horarios de los siete días (TEC-10); sin horario guardado, todos cerrados.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  Future<ScheduleBody?> apiVversionTecnicosMeHorariosGet(String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionTecnicosMeHorariosGetWithHttpInfo(version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ScheduleBody',) as ScheduleBody;
    
    }
    return null;
  }

  /// Reemplaza los horarios de los siete días (TEC-11).
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [ScheduleBody] scheduleBody (required):
  Future<Response> apiVversionTecnicosMeHorariosPutWithHttpInfo(String version, ScheduleBody scheduleBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/tecnicos/me/horarios'
      .replaceAll('{version}', version);

    Object? postBody = scheduleBody;

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

  /// Reemplaza los horarios de los siete días (TEC-11).
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [ScheduleBody] scheduleBody (required):
  Future<ScheduleBody?> apiVversionTecnicosMeHorariosPut(String version, ScheduleBody scheduleBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionTecnicosMeHorariosPutWithHttpInfo(version, scheduleBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ScheduleBody',) as ScheduleBody;
    
    }
    return null;
  }

  /// Edita el perfil público (TEC-08): cambian solo los campos enviados.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [UpdateTechnicianBody] updateTechnicianBody (required):
  Future<Response> apiVversionTecnicosMePutWithHttpInfo(String version, UpdateTechnicianBody updateTechnicianBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/tecnicos/me'
      .replaceAll('{version}', version);

    Object? postBody = updateTechnicianBody;

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

  /// Edita el perfil público (TEC-08): cambian solo los campos enviados.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [UpdateTechnicianBody] updateTechnicianBody (required):
  Future<TechnicianResponse?> apiVversionTecnicosMePut(String version, UpdateTechnicianBody updateTechnicianBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionTecnicosMePutWithHttpInfo(version, updateTechnicianBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'TechnicianResponse',) as TechnicianResponse;
    
    }
    return null;
  }

  /// Reputación propia (TEC-13): promedio, distribución por estrellas y nivel; una cuenta sin perfil de técnico recibe 404.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  Future<Response> apiVversionTecnicosMeReputacionGetWithHttpInfo(String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/tecnicos/me/reputacion'
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

  /// Reputación propia (TEC-13): promedio, distribución por estrellas y nivel; una cuenta sin perfil de técnico recibe 404.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  Future<ReputationResponse?> apiVversionTecnicosMeReputacionGet(String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionTecnicosMeReputacionGetWithHttpInfo(version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ReputationResponse',) as ReputationResponse;
    
    }
    return null;
  }
}
