//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class ArrivalApi {
  ArrivalApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// El técnico elegido confirma que llegó. Código incorrecto: 422 `wrong_code` con `intentosRestantes`; al tercero la visita queda bloqueada. Estados no válidos responden 409 con `outside_window`, `code_used`, `code_expired`, `visit_locked`, `visit_cancelled`, `visit_not_active` o `visit_without_code`.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [ArrivalBody] arrivalBody (required):
  Future<Response> apiVversionVisitasIdLlegadaPostWithHttpInfo(String id, String version, ArrivalBody arrivalBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/visitas/{id}/llegada'
      .replaceAll('{id}', id)
      .replaceAll('{version}', version);

    Object? postBody = arrivalBody;

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

  /// El técnico elegido confirma que llegó. Código incorrecto: 422 `wrong_code` con `intentosRestantes`; al tercero la visita queda bloqueada. Estados no válidos responden 409 con `outside_window`, `code_used`, `code_expired`, `visit_locked`, `visit_cancelled`, `visit_not_active` o `visit_without_code`.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [ArrivalBody] arrivalBody (required):
  Future<VisitResponse?> apiVversionVisitasIdLlegadaPost(String id, String version, ArrivalBody arrivalBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionVisitasIdLlegadaPostWithHttpInfo(id, version, arrivalBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'VisitResponse',) as VisitResponse;
    
    }
    return null;
  }
}
