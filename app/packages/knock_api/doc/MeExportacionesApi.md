# knock_api.api.MeExportacionesApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionMeExportacionesPost**](MeExportacionesApi.md#apivversionmeexportacionespost) | **POST** /api/v{version}/me/exportaciones | USR-06. Pide la descarga de todos los datos propios; se entrega en 48 horas. Una sola en curso por persona.
[**apiVversionMeExportacionesUltimaGet**](MeExportacionesApi.md#apivversionmeexportacionesultimaget) | **GET** /api/v{version}/me/exportaciones/ultima | USR-06b. La app lo llama al abrir el aviso `exportacion_lista`: `en_preparacion`, `vencida` o `lista` con un enlace firmado de 24 horas que se genera en este momento. 404 `export_not_found` si nunca pidió una; 503 `export_unavailable` si el contenedor no responde. Solo la persona del token; sin caché y el enlace no se registra.


# **apiVversionMeExportacionesPost**
> apiVversionMeExportacionesPost(version)

USR-06. Pide la descarga de todos los datos propios; se entrega en 48 horas. Una sola en curso por persona.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = MeExportacionesApi();
final version = version_example; // String | 

try {
    api_instance.apiVversionMeExportacionesPost(version);
} catch (e) {
    print('Exception when calling MeExportacionesApi->apiVversionMeExportacionesPost: $e\n');
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
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionMeExportacionesUltimaGet**
> LatestExportResponse apiVversionMeExportacionesUltimaGet(version)

USR-06b. La app lo llama al abrir el aviso `exportacion_lista`: `en_preparacion`, `vencida` o `lista` con un enlace firmado de 24 horas que se genera en este momento. 404 `export_not_found` si nunca pidió una; 503 `export_unavailable` si el contenedor no responde. Solo la persona del token; sin caché y el enlace no se registra.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = MeExportacionesApi();
final version = version_example; // String | 

try {
    final result = api_instance.apiVversionMeExportacionesUltimaGet(version);
    print(result);
} catch (e) {
    print('Exception when calling MeExportacionesApi->apiVversionMeExportacionesUltimaGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 

### Return type

[**LatestExportResponse**](LatestExportResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

