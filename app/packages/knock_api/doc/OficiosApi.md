# knock_api.api.OficiosApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionOficiosGet**](OficiosApi.md#apivversionoficiosget) | **GET** /api/v{version}/oficios | Oficios activos como arreglo sin paginar: excepción documentada a la constitución §11 (catálogo acotado, D9). `[AllowAnonymous]` explícito para que siga público aunque se agregue una política de autorización global (D3). Responde con `ETag` débil, `Cache-Control: public, max-age=0, must-revalidate` y `Vary: Accept-Encoding` (la respuesta comprimida es otra variante); con `If-None-Match` vigente responde 304 sin cuerpo.


# **apiVversionOficiosGet**
> List<OficioResponse> apiVversionOficiosGet(version, ifNoneMatch)

Oficios activos como arreglo sin paginar: excepción documentada a la constitución §11 (catálogo acotado, D9). `[AllowAnonymous]` explícito para que siga público aunque se agregue una política de autorización global (D3). Responde con `ETag` débil, `Cache-Control: public, max-age=0, must-revalidate` y `Vary: Accept-Encoding` (la respuesta comprimida es otra variante); con `If-None-Match` vigente responde 304 sin cuerpo.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = OficiosApi();
final version = version_example; // String | 
final ifNoneMatch = ifNoneMatch_example; // String | 

try {
    final result = api_instance.apiVversionOficiosGet(version, ifNoneMatch);
    print(result);
} catch (e) {
    print('Exception when calling OficiosApi->apiVversionOficiosGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **ifNoneMatch** | **String**|  | [optional] 

### Return type

[**List<OficioResponse>**](OficioResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

