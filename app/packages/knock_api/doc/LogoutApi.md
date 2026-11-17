# knock_api.api.LogoutApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionAuthLogoutPost**](LogoutApi.md#apivversionauthlogoutpost) | **POST** /api/v{version}/auth/logout | Cierra la sesión del dispositivo: la revoca y cancela su `sid` en Redis (spec 016). Sin cuerpo.


# **apiVversionAuthLogoutPost**
> apiVversionAuthLogoutPost(version)

Cierra la sesión del dispositivo: la revoca y cancela su `sid` en Redis (spec 016). Sin cuerpo.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = LogoutApi();
final version = version_example; // String | 

try {
    api_instance.apiVversionAuthLogoutPost(version);
} catch (e) {
    print('Exception when calling LogoutApi->apiVversionAuthLogoutPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

