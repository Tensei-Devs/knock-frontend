//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class HttpBasicAuth implements Authentication {
  HttpBasicAuth({this.username = '', this.password = ''});

  String username;
  String password;

  @override
  Future<void> applyToParams(List<QueryParam> queryParams, Map<String, String> headerParams,) async {
    if (username.isNotEmpty && password.isNotEmpty) {
      final credentials = '$username:$password';
      headerParams['Authorization'] = 'Basic ${base64.encode(utf8.encode(credentials))}';
    }
  }
}
