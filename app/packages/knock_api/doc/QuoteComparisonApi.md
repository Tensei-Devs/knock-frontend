# knock_api.api.QuoteComparisonApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionSolicitudesIdCotizacionesGet**](QuoteComparisonApi.md#apivversionsolicitudesidcotizacionesget) | **GET** /api/v{version}/solicitudes/{id}/cotizaciones | Cotizaciones de una solicitud propia, con el orden pedido. El `sub` del token debe ser el del dueño; cualquier otro recibe 404.


# **apiVversionSolicitudesIdCotizacionesGet**
> QuoteComparison apiVversionSolicitudesIdCotizacionesGet(id, version, orden)

Cotizaciones de una solicitud propia, con el orden pedido. El `sub` del token debe ser el del dueño; cualquier otro recibe 404.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = QuoteComparisonApi();
final id = id_example; // String | 
final version = version_example; // String | 
final orden = orden_example; // String | Sort order: recomendadas (default), precio, calificacion or pronto.

try {
    final result = api_instance.apiVversionSolicitudesIdCotizacionesGet(id, version, orden);
    print(result);
} catch (e) {
    print('Exception when calling QuoteComparisonApi->apiVversionSolicitudesIdCotizacionesGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 
 **orden** | **String**| Sort order: recomendadas (default), precio, calificacion or pronto. | [optional] 

### Return type

[**QuoteComparison**](QuoteComparison.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

