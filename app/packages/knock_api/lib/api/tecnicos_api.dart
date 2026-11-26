//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class TecnicosApi {
  TecnicosApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Sugerencias de oficios y negocios mientras se escribe (TEC-03): hasta 8, públicas y sin registrar el texto.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] q:
  Future<Response> apiVversionTecnicosAutocompletarGetWithHttpInfo(String version, { String? q, Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/tecnicos/autocompletar'
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (q != null) {
      queryParams.addAll(_queryParams('', 'q', q));
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

  /// Sugerencias de oficios y negocios mientras se escribe (TEC-03): hasta 8, públicas y sin registrar el texto.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] q:
  Future<AutocompleteResponse?> apiVversionTecnicosAutocompletarGet(String version, { String? q, Future<void>? abortTrigger, }) async {
    final response = await apiVversionTecnicosAutocompletarGetWithHttpInfo(version, q: q, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AutocompleteResponse',) as AutocompleteResponse;
    
    }
    return null;
  }

  /// Busca técnicos por filtros, orden y cursor (TEC-02, spec 046, R-04): solo técnicos `activo` y visibles; es pública y la respuesta no se cachea (ninguna clave lleva datos de otra persona). `radioKm` es 3, 5, 8 o 12; por defecto devuelve 20 técnicos (máx. 50) y el cursor de la página siguiente; un cursor mal formado o `limite` fuera de rango responde 422.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] oficio:
  ///
  /// * [String] colonia:
  ///
  /// * [String] lat:
  ///
  /// * [String] lng:
  ///
  /// * [String] radioKm:
  ///
  /// * [String] disponibleHoy:
  ///
  /// * [String] soloVerificados:
  ///
  /// * [String] orden:
  ///
  /// * [String] cursor:
  ///
  /// * [String] limite:
  Future<Response> apiVversionTecnicosGetWithHttpInfo(String version, { String? oficio, String? colonia, String? lat, String? lng, String? radioKm, String? disponibleHoy, String? soloVerificados, String? orden, String? cursor, String? limite, Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/tecnicos'
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (oficio != null) {
      queryParams.addAll(_queryParams('', 'oficio', oficio));
    }
    if (colonia != null) {
      queryParams.addAll(_queryParams('', 'colonia', colonia));
    }
    if (lat != null) {
      queryParams.addAll(_queryParams('', 'lat', lat));
    }
    if (lng != null) {
      queryParams.addAll(_queryParams('', 'lng', lng));
    }
    if (radioKm != null) {
      queryParams.addAll(_queryParams('', 'radioKm', radioKm));
    }
    if (disponibleHoy != null) {
      queryParams.addAll(_queryParams('', 'disponibleHoy', disponibleHoy));
    }
    if (soloVerificados != null) {
      queryParams.addAll(_queryParams('', 'soloVerificados', soloVerificados));
    }
    if (orden != null) {
      queryParams.addAll(_queryParams('', 'orden', orden));
    }
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

  /// Busca técnicos por filtros, orden y cursor (TEC-02, spec 046, R-04): solo técnicos `activo` y visibles; es pública y la respuesta no se cachea (ninguna clave lleva datos de otra persona). `radioKm` es 3, 5, 8 o 12; por defecto devuelve 20 técnicos (máx. 50) y el cursor de la página siguiente; un cursor mal formado o `limite` fuera de rango responde 422.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] oficio:
  ///
  /// * [String] colonia:
  ///
  /// * [String] lat:
  ///
  /// * [String] lng:
  ///
  /// * [String] radioKm:
  ///
  /// * [String] disponibleHoy:
  ///
  /// * [String] soloVerificados:
  ///
  /// * [String] orden:
  ///
  /// * [String] cursor:
  ///
  /// * [String] limite:
  Future<TechnicianListResponse?> apiVversionTecnicosGet(String version, { String? oficio, String? colonia, String? lat, String? lng, String? radioKm, String? disponibleHoy, String? soloVerificados, String? orden, String? cursor, String? limite, Future<void>? abortTrigger, }) async {
    final response = await apiVversionTecnicosGetWithHttpInfo(version, oficio: oficio, colonia: colonia, lat: lat, lng: lng, radioKm: radioKm, disponibleHoy: disponibleHoy, soloVerificados: soloVerificados, orden: orden, cursor: cursor, limite: limite, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'TechnicianListResponse',) as TechnicianListResponse;
    
    }
    return null;
  }

  /// Fotos de trabajos terminados que el cliente permitió publicar y que pasaron la moderación (TEC-07), por cursor (20 por defecto, máx. 50). 404 si el técnico no existe o está oculto; el servidor guarda cada página 1 minuto.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [String] cursor:
  ///
  /// * [String] limite:
  Future<Response> apiVversionTecnicosIdFotosTrabajosGetWithHttpInfo(String id, String version, { String? cursor, String? limite, Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/tecnicos/{id}/fotos-trabajos'
      .replaceAll('{id}', id)
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

  /// Fotos de trabajos terminados que el cliente permitió publicar y que pasaron la moderación (TEC-07), por cursor (20 por defecto, máx. 50). 404 si el técnico no existe o está oculto; el servidor guarda cada página 1 minuto.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [String] cursor:
  ///
  /// * [String] limite:
  Future<WorkPhotoListResponse?> apiVversionTecnicosIdFotosTrabajosGet(String id, String version, { String? cursor, String? limite, Future<void>? abortTrigger, }) async {
    final response = await apiVversionTecnicosIdFotosTrabajosGetWithHttpInfo(id, version, cursor: cursor, limite: limite, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'WorkPhotoListResponse',) as WorkPhotoListResponse;
    
    }
    return null;
  }

  /// Perfil de un técnico (TEC-05): sin sesión, solo el resumen; con sesión válida, también el detalle. Un técnico que no existe o está oculto responde 404 `technician_not_found`.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  Future<Response> apiVversionTecnicosIdGetWithHttpInfo(String id, String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/tecnicos/{id}'
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

  /// Perfil de un técnico (TEC-05): sin sesión, solo el resumen; con sesión válida, también el detalle. Un técnico que no existe o está oculto responde 404 `technician_not_found`.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  Future<TechnicianProfileResponse?> apiVversionTecnicosIdGet(String id, String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionTecnicosIdGetWithHttpInfo(id, version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'TechnicianProfileResponse',) as TechnicianProfileResponse;
    
    }
    return null;
  }

  /// Dice si el técnico atiende la colonia de la persona (TEC-06). 404 si el técnico no existe o está oculto; 422 si la colonia no está en el catálogo.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [String] colonia:
  Future<Response> apiVversionTecnicosIdLlegaAMiColoniaGetWithHttpInfo(String id, String version, { String? colonia, Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/tecnicos/{id}/llega-a-mi-colonia'
      .replaceAll('{id}', id)
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (colonia != null) {
      queryParams.addAll(_queryParams('', 'colonia', colonia));
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

  /// Dice si el técnico atiende la colonia de la persona (TEC-06). 404 si el técnico no existe o está oculto; 422 si la colonia no está en el catálogo.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [String] colonia:
  Future<CoverageResponse?> apiVversionTecnicosIdLlegaAMiColoniaGet(String id, String version, { String? colonia, Future<void>? abortTrigger, }) async {
    final response = await apiVversionTecnicosIdLlegaAMiColoniaGetWithHttpInfo(id, version, colonia: colonia, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CoverageResponse',) as CoverageResponse;
    
    }
    return null;
  }

  /// Registra a la persona del token como técnico (TEC-01): nace `activo`, sin verificación y con «Disponible hoy» apagado.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [RegisterTechnicianBody] registerTechnicianBody (required):
  Future<Response> apiVversionTecnicosPostWithHttpInfo(String version, RegisterTechnicianBody registerTechnicianBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/tecnicos'
      .replaceAll('{version}', version);

    Object? postBody = registerTechnicianBody;

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

  /// Registra a la persona del token como técnico (TEC-01): nace `activo`, sin verificación y con «Disponible hoy» apagado.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [RegisterTechnicianBody] registerTechnicianBody (required):
  Future<TechnicianResponse?> apiVversionTecnicosPost(String version, RegisterTechnicianBody registerTechnicianBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionTecnicosPostWithHttpInfo(version, registerTechnicianBody, abortTrigger: abortTrigger,);
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
}
