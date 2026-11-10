//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

abstract class Authentication {
  /// Apply authentication settings to header and query params.
  Future<void> applyToParams(List<QueryParam> queryParams, Map<String, String> headerParams);
}
