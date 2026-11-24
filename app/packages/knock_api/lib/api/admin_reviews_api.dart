//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class AdminReviewsApi {
  AdminReviewsApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Vuelve a mostrar la opinión. Sobre una visible responde 200 sin cambios.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  Future<Response> apiVversionAdminOpinionesIdMostrarPostWithHttpInfo(String id, String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/admin/opiniones/{id}/mostrar'
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

  /// Vuelve a mostrar la opinión. Sobre una visible responde 200 sin cambios.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  Future<void> apiVversionAdminOpinionesIdMostrarPost(String id, String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionAdminOpinionesIdMostrarPostWithHttpInfo(id, version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Oculta la opinión con un motivo de 8 a 300 caracteres. Repetirlo responde 200 sin cambios.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [HideReviewBody] hideReviewBody (required):
  Future<Response> apiVversionAdminOpinionesIdOcultarPostWithHttpInfo(String id, String version, HideReviewBody hideReviewBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/admin/opiniones/{id}/ocultar'
      .replaceAll('{id}', id)
      .replaceAll('{version}', version);

    Object? postBody = hideReviewBody;

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

  /// Oculta la opinión con un motivo de 8 a 300 caracteres. Repetirlo responde 200 sin cambios.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [HideReviewBody] hideReviewBody (required):
  Future<void> apiVversionAdminOpinionesIdOcultarPost(String id, String version, HideReviewBody hideReviewBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionAdminOpinionesIdOcultarPostWithHttpInfo(id, version, hideReviewBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }
}
