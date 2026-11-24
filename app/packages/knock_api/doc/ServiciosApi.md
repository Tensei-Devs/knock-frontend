# knock_api.api.ServiciosApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionTecnicosIdServiciosGet**](ServiciosApi.md#apivversiontecnicosidserviciosget) | **GET** /api/v{version}/tecnicos/{id}/servicios | Servicios y precios de referencia de un técnico visible (SRV-01), para cualquier persona con sesión.
[**apiVversionTecnicosMeServiciosIdDelete**](ServiciosApi.md#apivversiontecnicosmeserviciosiddelete) | **DELETE** /api/v{version}/tecnicos/me/servicios/{id} | Quita un servicio propio (SRV-04): 204; uno ajeno o inexistente responde 404 `service_not_found`.
[**apiVversionTecnicosMeServiciosIdPut**](ServiciosApi.md#apivversiontecnicosmeserviciosidput) | **PUT** /api/v{version}/tecnicos/me/servicios/{id} | Edita un servicio propio (SRV-03): cambian solo los campos enviados.
[**apiVversionTecnicosMeServiciosPost**](ServiciosApi.md#apivversiontecnicosmeserviciospost) | **POST** /api/v{version}/tecnicos/me/servicios | Agrega un servicio (SRV-02): 201; el 51.º responde 409 `service_limit_reached`.


# **apiVversionTecnicosIdServiciosGet**
> TechnicianServiceList apiVversionTecnicosIdServiciosGet(id, version)

Servicios y precios de referencia de un técnico visible (SRV-01), para cualquier persona con sesión.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = ServiciosApi();
final id = id_example; // String | 
final version = version_example; // String | 

try {
    final result = api_instance.apiVversionTecnicosIdServiciosGet(id, version);
    print(result);
} catch (e) {
    print('Exception when calling ServiciosApi->apiVversionTecnicosIdServiciosGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 

### Return type

[**TechnicianServiceList**](TechnicianServiceList.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionTecnicosMeServiciosIdDelete**
> apiVversionTecnicosMeServiciosIdDelete(id, version)

Quita un servicio propio (SRV-04): 204; uno ajeno o inexistente responde 404 `service_not_found`.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = ServiciosApi();
final id = id_example; // String | 
final version = version_example; // String | 

try {
    api_instance.apiVversionTecnicosMeServiciosIdDelete(id, version);
} catch (e) {
    print('Exception when calling ServiciosApi->apiVversionTecnicosMeServiciosIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionTecnicosMeServiciosIdPut**
> TechnicianService apiVversionTecnicosMeServiciosIdPut(id, version, updateServiceBody)

Edita un servicio propio (SRV-03): cambian solo los campos enviados.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = ServiciosApi();
final id = id_example; // String | 
final version = version_example; // String | 
final updateServiceBody = UpdateServiceBody(); // UpdateServiceBody | 

try {
    final result = api_instance.apiVversionTecnicosMeServiciosIdPut(id, version, updateServiceBody);
    print(result);
} catch (e) {
    print('Exception when calling ServiciosApi->apiVversionTecnicosMeServiciosIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 
 **updateServiceBody** | [**UpdateServiceBody**](UpdateServiceBody.md)|  | 

### Return type

[**TechnicianService**](TechnicianService.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionTecnicosMeServiciosPost**
> TechnicianService apiVversionTecnicosMeServiciosPost(version, createServiceBody)

Agrega un servicio (SRV-02): 201; el 51.º responde 409 `service_limit_reached`.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = ServiciosApi();
final version = version_example; // String | 
final createServiceBody = CreateServiceBody(); // CreateServiceBody | 

try {
    final result = api_instance.apiVversionTecnicosMeServiciosPost(version, createServiceBody);
    print(result);
} catch (e) {
    print('Exception when calling ServiciosApi->apiVversionTecnicosMeServiciosPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **createServiceBody** | [**CreateServiceBody**](CreateServiceBody.md)|  | 

### Return type

[**TechnicianService**](TechnicianService.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

