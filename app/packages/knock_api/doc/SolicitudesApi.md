# knock_api.api.SolicitudesApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionSolicitudesGet**](SolicitudesApi.md#apivversionsolicitudesget) | **GET** /api/v{version}/solicitudes | Solicitudes del `sub` del token, las activas primero y cada grupo de la más reciente a la más antigua, con paginación por cursor.
[**apiVversionSolicitudesIdGet**](SolicitudesApi.md#apivversionsolicitudesidget) | **GET** /api/v{version}/solicitudes/{id} | Detalle: vista del cliente dueño, o vista acotada del técnico elegible o que ya cotizó. Cualquier otra persona recibe 404.
[**apiVversionSolicitudesPost**](SolicitudesApi.md#apivversionsolicitudespost) | **POST** /api/v{version}/solicitudes | Crea la solicitud en estado `enviada` y con `venceEn` a 48 h.


# **apiVversionSolicitudesGet**
> RequestPage apiVversionSolicitudesGet(version, cursor, limit, estado)

Solicitudes del `sub` del token, las activas primero y cada grupo de la más reciente a la más antigua, con paginación por cursor.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = SolicitudesApi();
final version = version_example; // String | 
final cursor = cursor_example; // String | Opaque cursor returned as nextCursor by the previous page.
final limit = 56; // int | Page size, 1 to 50. Defaults to 20.
final estado = estado_example; // String | Optional filter by state: enviada, cotizando, cita_confirmada, terminada, calificada, cancelada or vencida.

try {
    final result = api_instance.apiVversionSolicitudesGet(version, cursor, limit, estado);
    print(result);
} catch (e) {
    print('Exception when calling SolicitudesApi->apiVversionSolicitudesGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **cursor** | **String**| Opaque cursor returned as nextCursor by the previous page. | [optional] 
 **limit** | **int**| Page size, 1 to 50. Defaults to 20. | [optional] 
 **estado** | **String**| Optional filter by state: enviada, cotizando, cita_confirmada, terminada, calificada, cancelada or vencida. | [optional] 

### Return type

[**RequestPage**](RequestPage.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionSolicitudesIdGet**
> RequestResponse apiVversionSolicitudesIdGet(id, version)

Detalle: vista del cliente dueño, o vista acotada del técnico elegible o que ya cotizó. Cualquier otra persona recibe 404.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = SolicitudesApi();
final id = id_example; // String | 
final version = version_example; // String | 

try {
    final result = api_instance.apiVversionSolicitudesIdGet(id, version);
    print(result);
} catch (e) {
    print('Exception when calling SolicitudesApi->apiVversionSolicitudesIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 

### Return type

[**RequestResponse**](RequestResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionSolicitudesPost**
> RequestResponse apiVversionSolicitudesPost(version, createRequestBody)

Crea la solicitud en estado `enviada` y con `venceEn` a 48 h.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = SolicitudesApi();
final version = version_example; // String | 
final createRequestBody = CreateRequestBody(); // CreateRequestBody | 

try {
    final result = api_instance.apiVversionSolicitudesPost(version, createRequestBody);
    print(result);
} catch (e) {
    print('Exception when calling SolicitudesApi->apiVversionSolicitudesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **createRequestBody** | [**CreateRequestBody**](CreateRequestBody.md)|  | 

### Return type

[**RequestResponse**](RequestResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

