# knock_api.api.PanelSesionApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionPanelSesionCelularPost**](PanelSesionApi.md#apivversionpanelsesioncelularpost) | **POST** /api/v{version}/panel/sesion/celular | Primer paso (R-04 a R-07): valida el `idToken` de Firebase y abre un desafío de un solo uso.
[**apiVversionPanelSesionTotpPost**](PanelSesionApi.md#apivversionpanelsesiontotppost) | **POST** /api/v{version}/panel/sesion/totp | Segundo paso (R-08 a R-12): valida el TOTP y abre la sesión del panel; la cookie de renovación va en `Set-Cookie`.


# **apiVversionPanelSesionCelularPost**
> PanelCelularResponse apiVversionPanelSesionCelularPost(version, panelCelularRequest)

Primer paso (R-04 a R-07): valida el `idToken` de Firebase y abre un desafío de un solo uso.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = PanelSesionApi();
final version = version_example; // String | 
final panelCelularRequest = PanelCelularRequest(); // PanelCelularRequest | 

try {
    final result = api_instance.apiVversionPanelSesionCelularPost(version, panelCelularRequest);
    print(result);
} catch (e) {
    print('Exception when calling PanelSesionApi->apiVversionPanelSesionCelularPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **panelCelularRequest** | [**PanelCelularRequest**](PanelCelularRequest.md)|  | 

### Return type

[**PanelCelularResponse**](PanelCelularResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionPanelSesionTotpPost**
> PanelAccesoResponse apiVversionPanelSesionTotpPost(version, panelTotpRequest)

Segundo paso (R-08 a R-12): valida el TOTP y abre la sesión del panel; la cookie de renovación va en `Set-Cookie`.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = PanelSesionApi();
final version = version_example; // String | 
final panelTotpRequest = PanelTotpRequest(); // PanelTotpRequest | 

try {
    final result = api_instance.apiVversionPanelSesionTotpPost(version, panelTotpRequest);
    print(result);
} catch (e) {
    print('Exception when calling PanelSesionApi->apiVversionPanelSesionTotpPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **panelTotpRequest** | [**PanelTotpRequest**](PanelTotpRequest.md)|  | 

### Return type

[**PanelAccesoResponse**](PanelAccesoResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

