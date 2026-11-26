# knock_api.api.MeApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionMeGet**](MeApi.md#apivversionmeget) | **GET** /api/v{version}/me | 
[**apiVversionMePut**](MeApi.md#apivversionmeput) | **PUT** /api/v{version}/me | Actualiza el perfil. Los campos inválidos responden 422 con errores por campo; una colonia inexistente responde 422 con su código.


# **apiVversionMeGet**
> ProfileResponse apiVversionMeGet(version)



### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = MeApi();
final version = version_example; // String | 

try {
    final result = api_instance.apiVversionMeGet(version);
    print(result);
} catch (e) {
    print('Exception when calling MeApi->apiVversionMeGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 

### Return type

[**ProfileResponse**](ProfileResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionMePut**
> ProfileResponse apiVversionMePut(version, updateProfileRequest)

Actualiza el perfil. Los campos inválidos responden 422 con errores por campo; una colonia inexistente responde 422 con su código.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = MeApi();
final version = version_example; // String | 
final updateProfileRequest = UpdateProfileRequest(); // UpdateProfileRequest | 

try {
    final result = api_instance.apiVversionMePut(version, updateProfileRequest);
    print(result);
} catch (e) {
    print('Exception when calling MeApi->apiVversionMePut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **updateProfileRequest** | [**UpdateProfileRequest**](UpdateProfileRequest.md)|  | 

### Return type

[**ProfileResponse**](ProfileResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

