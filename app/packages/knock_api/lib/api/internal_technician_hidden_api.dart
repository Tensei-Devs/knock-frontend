//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class InternalTechnicianHiddenApi {
  InternalTechnicianHiddenApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Performs an HTTP 'POST /api/v{version}/interno/tecnicos-ocultados' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [TechnicianHiddenEventBody] technicianHiddenEventBody (required):
  Future<Response> apiVversionInternoTecnicosOcultadosPostWithHttpInfo(String version, TechnicianHiddenEventBody technicianHiddenEventBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/interno/tecnicos-ocultados'
      .replaceAll('{version}', version);

    Object? postBody = technicianHiddenEventBody;

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
  /// * [TechnicianHiddenEventBody] technicianHiddenEventBody (required):
  Future<void> apiVversionInternoTecnicosOcultadosPost(String version, TechnicianHiddenEventBody technicianHiddenEventBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionInternoTecnicosOcultadosPostWithHttpInfo(version, technicianHiddenEventBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }
}
