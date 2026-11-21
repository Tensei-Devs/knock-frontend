//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class PanelCicloApi {
  PanelCicloApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Cierre (R-19): exige el token del panel y `X-Knock-Panel: 1`; revoca la sesión y borra la cookie.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] xKnockPanel (required):
  ///   Must be 1: it forces a CORS preflight that only the panel origin passes.
  ///
  /// * [String] version (required):
  Future<Response> apiVversionPanelSesionCerrarPostWithHttpInfo(String xKnockPanel, String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/panel/sesion/cerrar'
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    headerParams[r'X-Knock-Panel'] = parameterToString(xKnockPanel);

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

  /// Cierre (R-19): exige el token del panel y `X-Knock-Panel: 1`; revoca la sesión y borra la cookie.
  ///
  /// Parameters:
  ///
  /// * [String] xKnockPanel (required):
  ///   Must be 1: it forces a CORS preflight that only the panel origin passes.
  ///
  /// * [String] version (required):
  Future<void> apiVversionPanelSesionCerrarPost(String xKnockPanel, String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionPanelSesionCerrarPostWithHttpInfo(xKnockPanel, version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Renovación (R-17 y R-18): sin cuerpo; exige la cookie, `X-Knock-Panel: 1` y el `Origin` del panel.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] xKnockPanel (required):
  ///   Must be 1: it forces a CORS preflight that only the panel origin passes.
  ///
  /// * [String] version (required):
  ///
  /// * [String] origin:
  Future<Response> apiVversionPanelSesionRenovarPostWithHttpInfo(String xKnockPanel, String version, { String? origin, Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/panel/sesion/renovar'
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    headerParams[r'X-Knock-Panel'] = parameterToString(xKnockPanel);
    if (origin != null) {
      headerParams[r'Origin'] = parameterToString(origin);
    }

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

  /// Renovación (R-17 y R-18): sin cuerpo; exige la cookie, `X-Knock-Panel: 1` y el `Origin` del panel.
  ///
  /// Parameters:
  ///
  /// * [String] xKnockPanel (required):
  ///   Must be 1: it forces a CORS preflight that only the panel origin passes.
  ///
  /// * [String] version (required):
  ///
  /// * [String] origin:
  Future<PanelAccesoResponse?> apiVversionPanelSesionRenovarPost(String xKnockPanel, String version, { String? origin, Future<void>? abortTrigger, }) async {
    final response = await apiVversionPanelSesionRenovarPostWithHttpInfo(xKnockPanel, version, origin: origin, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PanelAccesoResponse',) as PanelAccesoResponse;
    
    }
    return null;
  }
}
