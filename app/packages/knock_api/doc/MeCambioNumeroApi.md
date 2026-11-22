# knock_api.api.MeCambioNumeroApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionMeCambioNumeroConfirmarPost**](MeCambioNumeroApi.md#apivversionmecambionumeroconfirmarpost) | **POST** /api/v{version}/me/cambio-numero/confirmar | USR-04. Confirma el cambio con el token de Firebase del número nuevo, cambia el celular y cierra las demás sesiones.
[**apiVversionMeCambioNumeroPost**](MeCambioNumeroApi.md#apivversionmecambionumeropost) | **POST** /api/v{version}/me/cambio-numero | USR-03. Comprueba que el número nuevo no pertenece a otra cuenta, antes de que la app gaste un SMS de Firebase.


# **apiVversionMeCambioNumeroConfirmarPost**
> apiVversionMeCambioNumeroConfirmarPost(version, confirmPhoneChangeRequest)

USR-04. Confirma el cambio con el token de Firebase del número nuevo, cambia el celular y cierra las demás sesiones.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = MeCambioNumeroApi();
final version = version_example; // String | 
final confirmPhoneChangeRequest = ConfirmPhoneChangeRequest(); // ConfirmPhoneChangeRequest | 

try {
    api_instance.apiVversionMeCambioNumeroConfirmarPost(version, confirmPhoneChangeRequest);
} catch (e) {
    print('Exception when calling MeCambioNumeroApi->apiVversionMeCambioNumeroConfirmarPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **confirmPhoneChangeRequest** | [**ConfirmPhoneChangeRequest**](ConfirmPhoneChangeRequest.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionMeCambioNumeroPost**
> apiVversionMeCambioNumeroPost(version, phoneAvailabilityRequest)

USR-03. Comprueba que el número nuevo no pertenece a otra cuenta, antes de que la app gaste un SMS de Firebase.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = MeCambioNumeroApi();
final version = version_example; // String | 
final phoneAvailabilityRequest = PhoneAvailabilityRequest(); // PhoneAvailabilityRequest | 

try {
    api_instance.apiVversionMeCambioNumeroPost(version, phoneAvailabilityRequest);
} catch (e) {
    print('Exception when calling MeCambioNumeroApi->apiVversionMeCambioNumeroPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **phoneAvailabilityRequest** | [**PhoneAvailabilityRequest**](PhoneAvailabilityRequest.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

