# knock_api.api.MeVerificacionApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionMeVerificacionGet**](MeVerificacionApi.md#apivversionmeverificacionget) | **GET** /api/v{version}/me/verificacion | Estado de la verificación más reciente; sin ninguna, `sin_verificar` (nunca 404).
[**apiVversionMeVerificacionPost**](MeVerificacionApi.md#apivversionmeverificacionpost) | **POST** /api/v{version}/me/verificacion | Crea la verificación en `en_captura` con su consentimiento. Las fotos llegan con la tarea T-04 (enlaces de subida).


# **apiVversionMeVerificacionGet**
> VerificationStatusResponse apiVversionMeVerificacionGet(version)

Estado de la verificación más reciente; sin ninguna, `sin_verificar` (nunca 404).

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = MeVerificacionApi();
final version = version_example; // String | 

try {
    final result = api_instance.apiVversionMeVerificacionGet(version);
    print(result);
} catch (e) {
    print('Exception when calling MeVerificacionApi->apiVversionMeVerificacionGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 

### Return type

[**VerificationStatusResponse**](VerificationStatusResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionMeVerificacionPost**
> VerificationCreatedResponse apiVversionMeVerificacionPost(version, createVerificationRequest)

Crea la verificación en `en_captura` con su consentimiento. Las fotos llegan con la tarea T-04 (enlaces de subida).

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = MeVerificacionApi();
final version = version_example; // String | 
final createVerificationRequest = CreateVerificationRequest(); // CreateVerificationRequest | 

try {
    final result = api_instance.apiVversionMeVerificacionPost(version, createVerificationRequest);
    print(result);
} catch (e) {
    print('Exception when calling MeVerificacionApi->apiVversionMeVerificacionPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **createVerificationRequest** | [**CreateVerificationRequest**](CreateVerificationRequest.md)|  | 

### Return type

[**VerificationCreatedResponse**](VerificationCreatedResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

