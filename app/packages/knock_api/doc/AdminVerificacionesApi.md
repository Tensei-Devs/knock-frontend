# knock_api.api.AdminVerificacionesApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionAdminVerificacionesGet**](AdminVerificacionesApi.md#apivversionadminverificacionesget) | **GET** /api/v{version}/admin/verificaciones | VER-03: la cola, de la más antigua a la más reciente, con cursor. Sin fotos ni datos personales.
[**apiVversionAdminVerificacionesIdDecisionPost**](AdminVerificacionesApi.md#apivversionadminverificacionesiddecisionpost) | **POST** /api/v{version}/admin/verificaciones/{id}/decision | VER-05: aprueba o rechaza con motivo; destruye la llave de las fotos (identidad) o cambia el número (recuperación). 404, 409 `verification_already_decided`, 503 `audit_unavailable`.
[**apiVversionAdminVerificacionesIdGet**](AdminVerificacionesApi.md#apivversionadminverificacionesidget) | **GET** /api/v{version}/admin/verificaciones/{id} | VER-04: abre una verificación; entrega enlaces de 5 minutos a las fotos y registra quién los abrió. 404 `verification_not_found`; 410 `photos_destroyed`.


# **apiVversionAdminVerificacionesGet**
> VerificationQueuePage apiVversionAdminVerificacionesGet(version, tipo, estado, desde, hasta, cursor, limite)

VER-03: la cola, de la más antigua a la más reciente, con cursor. Sin fotos ni datos personales.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = AdminVerificacionesApi();
final version = version_example; // String | 
final tipo = tipo_example; // String | identidad (default) or recuperacion.
final estado = estado_example; // String | en_revision by default.
final desde = 2013-10-20T19:20:30+01:00; // DateTime | 
final hasta = 2013-10-20T19:20:30+01:00; // DateTime | 
final cursor = cursor_example; // String | Opaque cursor returned as nextCursor by the previous page.
final limite = 56; // int | Page size, 1 to 50. Defaults to 20.

try {
    final result = api_instance.apiVversionAdminVerificacionesGet(version, tipo, estado, desde, hasta, cursor, limite);
    print(result);
} catch (e) {
    print('Exception when calling AdminVerificacionesApi->apiVversionAdminVerificacionesGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **tipo** | **String**| identidad (default) or recuperacion. | [optional] 
 **estado** | **String**| en_revision by default. | [optional] 
 **desde** | **DateTime**|  | [optional] 
 **hasta** | **DateTime**|  | [optional] 
 **cursor** | **String**| Opaque cursor returned as nextCursor by the previous page. | [optional] 
 **limite** | **int**| Page size, 1 to 50. Defaults to 20. | [optional] 

### Return type

[**VerificationQueuePage**](VerificationQueuePage.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionAdminVerificacionesIdDecisionPost**
> VerificationDecisionResult apiVversionAdminVerificacionesIdDecisionPost(id, version, verificationDecisionBody)

VER-05: aprueba o rechaza con motivo; destruye la llave de las fotos (identidad) o cambia el número (recuperación). 404, 409 `verification_already_decided`, 503 `audit_unavailable`.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = AdminVerificacionesApi();
final id = id_example; // String | 
final version = version_example; // String | 
final verificationDecisionBody = VerificationDecisionBody(); // VerificationDecisionBody | 

try {
    final result = api_instance.apiVversionAdminVerificacionesIdDecisionPost(id, version, verificationDecisionBody);
    print(result);
} catch (e) {
    print('Exception when calling AdminVerificacionesApi->apiVversionAdminVerificacionesIdDecisionPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 
 **verificationDecisionBody** | [**VerificationDecisionBody**](VerificationDecisionBody.md)|  | 

### Return type

[**VerificationDecisionResult**](VerificationDecisionResult.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionAdminVerificacionesIdGet**
> VerificationDetail apiVversionAdminVerificacionesIdGet(id, version)

VER-04: abre una verificación; entrega enlaces de 5 minutos a las fotos y registra quién los abrió. 404 `verification_not_found`; 410 `photos_destroyed`.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = AdminVerificacionesApi();
final id = id_example; // String | 
final version = version_example; // String | 

try {
    final result = api_instance.apiVversionAdminVerificacionesIdGet(id, version);
    print(result);
} catch (e) {
    print('Exception when calling AdminVerificacionesApi->apiVversionAdminVerificacionesIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 

### Return type

[**VerificationDetail**](VerificationDetail.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

