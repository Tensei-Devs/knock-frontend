# knock_api.api.EnvioVerificacionApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionMeVerificacionIdEnviarPost**](EnvioVerificacionApi.md#apivversionmeverificacionidenviarpost) | **POST** /api/v{version}/me/verificacion/{id}/enviar | 


# **apiVversionMeVerificacionIdEnviarPost**
> VerificationSentResponse apiVversionMeVerificacionIdEnviarPost(id, version)



### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = EnvioVerificacionApi();
final id = id_example; // String | 
final version = version_example; // String | 

try {
    final result = api_instance.apiVversionMeVerificacionIdEnviarPost(id, version);
    print(result);
} catch (e) {
    print('Exception when calling EnvioVerificacionApi->apiVversionMeVerificacionIdEnviarPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 

### Return type

[**VerificationSentResponse**](VerificationSentResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

