# knock_api.api.PanelCicloApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionPanelSesionCerrarPost**](PanelCicloApi.md#apivversionpanelsesioncerrarpost) | **POST** /api/v{version}/panel/sesion/cerrar | Cierre (R-19): exige el token del panel y `X-Knock-Panel: 1`; revoca la sesión y borra la cookie.
[**apiVversionPanelSesionRenovarPost**](PanelCicloApi.md#apivversionpanelsesionrenovarpost) | **POST** /api/v{version}/panel/sesion/renovar | Renovación (R-17 y R-18): sin cuerpo; exige la cookie, `X-Knock-Panel: 1` y el `Origin` del panel.


# **apiVversionPanelSesionCerrarPost**
> apiVversionPanelSesionCerrarPost(xKnockPanel, version)

Cierre (R-19): exige el token del panel y `X-Knock-Panel: 1`; revoca la sesión y borra la cookie.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = PanelCicloApi();
final xKnockPanel = xKnockPanel_example; // String | Must be 1: it forces a CORS preflight that only the panel origin passes.
final version = version_example; // String | 

try {
    api_instance.apiVversionPanelSesionCerrarPost(xKnockPanel, version);
} catch (e) {
    print('Exception when calling PanelCicloApi->apiVversionPanelSesionCerrarPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **xKnockPanel** | **String**| Must be 1: it forces a CORS preflight that only the panel origin passes. | 
 **version** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionPanelSesionRenovarPost**
> PanelAccesoResponse apiVversionPanelSesionRenovarPost(xKnockPanel, version, origin)

Renovación (R-17 y R-18): sin cuerpo; exige la cookie, `X-Knock-Panel: 1` y el `Origin` del panel.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = PanelCicloApi();
final xKnockPanel = xKnockPanel_example; // String | Must be 1: it forces a CORS preflight that only the panel origin passes.
final version = version_example; // String | 
final origin = origin_example; // String | 

try {
    final result = api_instance.apiVversionPanelSesionRenovarPost(xKnockPanel, version, origin);
    print(result);
} catch (e) {
    print('Exception when calling PanelCicloApi->apiVversionPanelSesionRenovarPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **xKnockPanel** | **String**| Must be 1: it forces a CORS preflight that only the panel origin passes. | 
 **version** | **String**|  | 
 **origin** | **String**|  | [optional] 

### Return type

[**PanelAccesoResponse**](PanelAccesoResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

