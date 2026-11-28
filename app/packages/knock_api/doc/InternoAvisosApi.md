# knock_api.api.InternoAvisosApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionInternoAvisosPost**](InternoAvisosApi.md#apivversioninternoavisospost) | **POST** /api/v{version}/interno/avisos | Recibe el evento de un servicio emisor y responde 202, también si ya lo recibió. 401 con token inválido o vencido; 403 `service_not_allowed` si el emisor no tiene el tipo en `permisos`; 422 con un tipo o cuerpo fuera del catálogo.


# **apiVversionInternoAvisosPost**
> apiVversionInternoAvisosPost(version, avisoInterno)

Recibe el evento de un servicio emisor y responde 202, también si ya lo recibió. 401 con token inválido o vencido; 403 `service_not_allowed` si el emisor no tiene el tipo en `permisos`; 422 con un tipo o cuerpo fuera del catálogo.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = InternoAvisosApi();
final version = version_example; // String | 
final avisoInterno = AvisoInterno(); // AvisoInterno | 

try {
    api_instance.apiVversionInternoAvisosPost(version, avisoInterno);
} catch (e) {
    print('Exception when calling InternoAvisosApi->apiVversionInternoAvisosPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **avisoInterno** | [**AvisoInterno**](AvisoInterno.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

