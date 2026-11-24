//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class OpinionesApi {
  OpinionesApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// OPI-03: el técnico calificado responde una sola vez a una opinión suya.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [AnswerReviewBody] answerReviewBody (required):
  Future<Response> apiVversionOpinionesIdRespuestaPostWithHttpInfo(String id, String version, AnswerReviewBody answerReviewBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/opiniones/{id}/respuesta'
      .replaceAll('{id}', id)
      .replaceAll('{version}', version);

    Object? postBody = answerReviewBody;

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

  /// OPI-03: el técnico calificado responde una sola vez a una opinión suya.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [AnswerReviewBody] answerReviewBody (required):
  Future<void> apiVversionOpinionesIdRespuestaPost(String id, String version, AnswerReviewBody answerReviewBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionOpinionesIdRespuestaPostWithHttpInfo(id, version, answerReviewBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// OPI-01: opiniones publicadas de un técnico visible con su distribución por estrellas, de la más nueva a la más vieja, por cursor.
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
  /// * [int] limite:
  Future<Response> apiVversionTecnicosIdOpinionesGetWithHttpInfo(String id, String version, { String? cursor, int? limite, Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/tecnicos/{id}/opiniones'
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

  /// OPI-01: opiniones publicadas de un técnico visible con su distribución por estrellas, de la más nueva a la más vieja, por cursor.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [String] cursor:
  ///
  /// * [int] limite:
  Future<ReviewPage?> apiVversionTecnicosIdOpinionesGet(String id, String version, { String? cursor, int? limite, Future<void>? abortTrigger, }) async {
    final response = await apiVversionTecnicosIdOpinionesGetWithHttpInfo(id, version, cursor: cursor, limite: limite, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ReviewPage',) as ReviewPage;
    
    }
    return null;
  }

  /// OPI-02: el cliente de una visita terminada la califica una sola vez, hasta 30 días después.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [CreateReviewBody] createReviewBody (required):
  Future<Response> apiVversionVisitasIdOpinionPostWithHttpInfo(String id, String version, CreateReviewBody createReviewBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/visitas/{id}/opinion'
      .replaceAll('{id}', id)
      .replaceAll('{version}', version);

    Object? postBody = createReviewBody;

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

  /// OPI-02: el cliente de una visita terminada la califica una sola vez, hasta 30 días después.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [CreateReviewBody] createReviewBody (required):
  Future<CreatedReview?> apiVversionVisitasIdOpinionPost(String id, String version, CreateReviewBody createReviewBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionVisitasIdOpinionPostWithHttpInfo(id, version, createReviewBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CreatedReview',) as CreatedReview;
    
    }
    return null;
  }
}
