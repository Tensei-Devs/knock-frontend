# knock_api.api.AdminCatalogApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionAdminListaEsperaGet**](AdminCatalogApi.md#apivversionadminlistaesperaget) | **GET** /api/v{version}/admin/lista-espera | Cuántas personas esperan por código postal, ordenado por código postal, con paginación por cursor. Nunca incluye celulares.
[**apiVversionAdminOficiosPedidosGet**](AdminCatalogApi.md#apivversionadminoficiospedidosget) | **GET** /api/v{version}/admin/oficios-pedidos | Oficios pedidos en «Otro oficio», agrupados por texto normalizado y contados, de más a menos pedidos, con paginación por cursor (20 por omisión, 50 como máximo).


# **apiVversionAdminListaEsperaGet**
> WaitlistZonePage apiVversionAdminListaEsperaGet(version, cursor, limite)

Cuántas personas esperan por código postal, ordenado por código postal, con paginación por cursor. Nunca incluye celulares.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = AdminCatalogApi();
final version = version_example; // String | 
final cursor = cursor_example; // String | Opaque cursor returned as nextCursor by the previous page.
final limite = 56; // int | Page size, 1 to 50. Defaults to 20.

try {
    final result = api_instance.apiVversionAdminListaEsperaGet(version, cursor, limite);
    print(result);
} catch (e) {
    print('Exception when calling AdminCatalogApi->apiVversionAdminListaEsperaGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **cursor** | **String**| Opaque cursor returned as nextCursor by the previous page. | [optional] 
 **limite** | **int**| Page size, 1 to 50. Defaults to 20. | [optional] 

### Return type

[**WaitlistZonePage**](WaitlistZonePage.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionAdminOficiosPedidosGet**
> TradeRequestPage apiVversionAdminOficiosPedidosGet(version, cursor, limite)

Oficios pedidos en «Otro oficio», agrupados por texto normalizado y contados, de más a menos pedidos, con paginación por cursor (20 por omisión, 50 como máximo).

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = AdminCatalogApi();
final version = version_example; // String | 
final cursor = cursor_example; // String | Opaque cursor returned as nextCursor by the previous page.
final limite = 56; // int | Page size, 1 to 50. Defaults to 20.

try {
    final result = api_instance.apiVversionAdminOficiosPedidosGet(version, cursor, limite);
    print(result);
} catch (e) {
    print('Exception when calling AdminCatalogApi->apiVversionAdminOficiosPedidosGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **cursor** | **String**| Opaque cursor returned as nextCursor by the previous page. | [optional] 
 **limite** | **int**| Page size, 1 to 50. Defaults to 20. | [optional] 

### Return type

[**TradeRequestPage**](TradeRequestPage.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

