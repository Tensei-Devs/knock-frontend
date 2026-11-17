# knock_api.api.MeSesionesApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionMeSesionesGet**](MeSesionesApi.md#apivversionmesesionesget) | **GET** /api/v{version}/me/sesiones | Lista las sesiones no revocadas ni vencidas de la cuenta autenticada, sin exponer tokens ni huellas.
[**apiVversionMeSesionesIdDelete**](MeSesionesApi.md#apivversionmesesionesiddelete) | **DELETE** /api/v{version}/me/sesiones/{id} | Revoca una sesión propia distinta de la actual y bloquea su `sid` en Redis hasta que venza el JWT.


# **apiVversionMeSesionesGet**
> List<SessionListItemResponse> apiVversionMeSesionesGet(version)

Lista las sesiones no revocadas ni vencidas de la cuenta autenticada, sin exponer tokens ni huellas.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = MeSesionesApi();
final version = version_example; // String | 

try {
    final result = api_instance.apiVversionMeSesionesGet(version);
    print(result);
} catch (e) {
    print('Exception when calling MeSesionesApi->apiVversionMeSesionesGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 

### Return type

[**List<SessionListItemResponse>**](SessionListItemResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionMeSesionesIdDelete**
> apiVversionMeSesionesIdDelete(id, version)

Revoca una sesión propia distinta de la actual y bloquea su `sid` en Redis hasta que venza el JWT.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = MeSesionesApi();
final id = id_example; // String | 
final version = version_example; // String | 

try {
    api_instance.apiVversionMeSesionesIdDelete(id, version);
} catch (e) {
    print('Exception when calling MeSesionesApi->apiVversionMeSesionesIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

