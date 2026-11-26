# knock_api.api.AdminTradesApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionAdminOficiosClavePut**](AdminTradesApi.md#apivversionadminoficiosclaveput) | **PUT** /api/v{version}/admin/oficios/{clave} | Edición parcial de un oficio y sus parámetros de precio (OFI-05): 200 con el oficio como quedó. La clave no se puede cambiar: una `clave` distinta de la de la ruta responde 422 `errors.clave`. Un oficio que no existe responde 404 `trade_not_found`; la caché de oficios activos se invalida al escribir.
[**apiVversionAdminOficiosGet**](AdminTradesApi.md#apivversionadminoficiosget) | **GET** /api/v{version}/admin/oficios | Todos los oficios, activos e inactivos, con sus parámetros de precio (OFI-03).
[**apiVversionAdminOficiosPost**](AdminTradesApi.md#apivversionadminoficiospost) | **POST** /api/v{version}/admin/oficios | Alta de un oficio (OFI-04): 201 con el oficio creado. La clave repetida responde 409 `trade_key_taken`; un cuerpo ilegible, 400; un valor inválido, 422. La auditoría del panel se escribe en la misma transacción que el oficio (bandeja de salida) y llega a Identidad después, con reintentos.


# **apiVversionAdminOficiosClavePut**
> AdminTradeResponse apiVversionAdminOficiosClavePut(clave, version, updateTradeBody)

Edición parcial de un oficio y sus parámetros de precio (OFI-05): 200 con el oficio como quedó. La clave no se puede cambiar: una `clave` distinta de la de la ruta responde 422 `errors.clave`. Un oficio que no existe responde 404 `trade_not_found`; la caché de oficios activos se invalida al escribir.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = AdminTradesApi();
final clave = clave_example; // String | 
final version = version_example; // String | 
final updateTradeBody = UpdateTradeBody(); // UpdateTradeBody | 

try {
    final result = api_instance.apiVversionAdminOficiosClavePut(clave, version, updateTradeBody);
    print(result);
} catch (e) {
    print('Exception when calling AdminTradesApi->apiVversionAdminOficiosClavePut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **clave** | **String**|  | 
 **version** | **String**|  | 
 **updateTradeBody** | [**UpdateTradeBody**](UpdateTradeBody.md)|  | 

### Return type

[**AdminTradeResponse**](AdminTradeResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionAdminOficiosGet**
> AdminTradeListResponse apiVversionAdminOficiosGet(version)

Todos los oficios, activos e inactivos, con sus parámetros de precio (OFI-03).

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = AdminTradesApi();
final version = version_example; // String | 

try {
    final result = api_instance.apiVversionAdminOficiosGet(version);
    print(result);
} catch (e) {
    print('Exception when calling AdminTradesApi->apiVversionAdminOficiosGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 

### Return type

[**AdminTradeListResponse**](AdminTradeListResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionAdminOficiosPost**
> AdminTradeResponse apiVversionAdminOficiosPost(version, createTradeBody)

Alta de un oficio (OFI-04): 201 con el oficio creado. La clave repetida responde 409 `trade_key_taken`; un cuerpo ilegible, 400; un valor inválido, 422. La auditoría del panel se escribe en la misma transacción que el oficio (bandeja de salida) y llega a Identidad después, con reintentos.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = AdminTradesApi();
final version = version_example; // String | 
final createTradeBody = CreateTradeBody(); // CreateTradeBody | 

try {
    final result = api_instance.apiVversionAdminOficiosPost(version, createTradeBody);
    print(result);
} catch (e) {
    print('Exception when calling AdminTradesApi->apiVversionAdminOficiosPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **createTradeBody** | [**CreateTradeBody**](CreateTradeBody.md)|  | 

### Return type

[**AdminTradeResponse**](AdminTradeResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

