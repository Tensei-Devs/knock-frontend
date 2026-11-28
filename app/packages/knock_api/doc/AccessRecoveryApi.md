# knock_api.api.AccessRecoveryApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionRecuperacionAccesoPost**](AccessRecoveryApi.md#apivversionrecuperacionaccesopost) | **POST** /api/v{version}/recuperacion-acceso | USR-05. Inicia la recuperación con el número nuevo verificado por Firebase; si existe la cuenta, crea un caso para la cola del panel. Siempre responde 202 sin revelar si la cuenta existe.


# **apiVversionRecuperacionAccesoPost**
> apiVversionRecuperacionAccesoPost(version, accessRecoveryRequest)

USR-05. Inicia la recuperación con el número nuevo verificado por Firebase; si existe la cuenta, crea un caso para la cola del panel. Siempre responde 202 sin revelar si la cuenta existe.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = AccessRecoveryApi();
final version = version_example; // String | 
final accessRecoveryRequest = AccessRecoveryRequest(); // AccessRecoveryRequest | 

try {
    api_instance.apiVversionRecuperacionAccesoPost(version, accessRecoveryRequest);
} catch (e) {
    print('Exception when calling AccessRecoveryApi->apiVversionRecuperacionAccesoPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **accessRecoveryRequest** | [**AccessRecoveryRequest**](AccessRecoveryRequest.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

