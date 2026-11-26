# knock_api.api.CasaYAutoApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionMeCasaYAutoGet**](CasaYAutoApi.md#apivversionmecasayautoget) | **GET** /api/v{version}/me/casa-y-auto | Lista los autos y las cosas de la casa de la persona (CAS-01).
[**apiVversionMeCasaYAutoIdDelete**](CasaYAutoApi.md#apivversionmecasayautoiddelete) | **DELETE** /api/v{version}/me/casa-y-auto/{id} | Quita un elemento propio (CAS-04). Uno ajeno o inexistente responde 404. Los trabajos terminados de Mercado no se tocan.
[**apiVversionMeCasaYAutoIdHistorialGet**](CasaYAutoApi.md#apivversionmecasayautoidhistorialget) | **GET** /api/v{version}/me/casa-y-auto/{id}/historial | Trabajos terminados ligados a un elemento propio (CAS-05), del más reciente al más antiguo y por cursor. Uno ajeno o inexistente responde 404; si Mercado no responde, 503 `market_unavailable`.
[**apiVversionMeCasaYAutoIdPut**](CasaYAutoApi.md#apivversionmecasayautoidput) | **PUT** /api/v{version}/me/casa-y-auto/{id} | Edita un elemento propio (CAS-03): cambian solo los campos enviados. Uno ajeno o inexistente responde 404.
[**apiVversionMeCasaYAutoPost**](CasaYAutoApi.md#apivversionmecasayautopost) | **POST** /api/v{version}/me/casa-y-auto | Registra un auto o una cosa de la casa (CAS-02). Con 20 elementos ya registrados responde 409 `item_limit_reached`.


# **apiVversionMeCasaYAutoGet**
> List<ItemResponse> apiVversionMeCasaYAutoGet(version)

Lista los autos y las cosas de la casa de la persona (CAS-01).

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = CasaYAutoApi();
final version = version_example; // String | 

try {
    final result = api_instance.apiVversionMeCasaYAutoGet(version);
    print(result);
} catch (e) {
    print('Exception when calling CasaYAutoApi->apiVversionMeCasaYAutoGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 

### Return type

[**List<ItemResponse>**](ItemResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionMeCasaYAutoIdDelete**
> apiVversionMeCasaYAutoIdDelete(id, version)

Quita un elemento propio (CAS-04). Uno ajeno o inexistente responde 404. Los trabajos terminados de Mercado no se tocan.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = CasaYAutoApi();
final id = id_example; // String | 
final version = version_example; // String | 

try {
    api_instance.apiVversionMeCasaYAutoIdDelete(id, version);
} catch (e) {
    print('Exception when calling CasaYAutoApi->apiVversionMeCasaYAutoIdDelete: $e\n');
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

# **apiVversionMeCasaYAutoIdHistorialGet**
> CursorPageOfHistoryItemResponse apiVversionMeCasaYAutoIdHistorialGet(id, version, cursor, limite, resolvedLimit)

Trabajos terminados ligados a un elemento propio (CAS-05), del más reciente al más antiguo y por cursor. Uno ajeno o inexistente responde 404; si Mercado no responde, 503 `market_unavailable`.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = CasaYAutoApi();
final id = id_example; // String | 
final version = version_example; // String | 
final cursor = cursor_example; // String | 
final limite = limite_example; // String | Texto a propósito: un valor que no es número responde 422 con el resto, no el 400 automático del enlace de datos.
final resolvedLimit = 56; // int | El límite ya validado (el validador corre antes de la acción).

try {
    final result = api_instance.apiVversionMeCasaYAutoIdHistorialGet(id, version, cursor, limite, resolvedLimit);
    print(result);
} catch (e) {
    print('Exception when calling CasaYAutoApi->apiVversionMeCasaYAutoIdHistorialGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 
 **cursor** | **String**|  | [optional] 
 **limite** | **String**| Texto a propósito: un valor que no es número responde 422 con el resto, no el 400 automático del enlace de datos. | [optional] 
 **resolvedLimit** | **int**| El límite ya validado (el validador corre antes de la acción). | [optional] 

### Return type

[**CursorPageOfHistoryItemResponse**](CursorPageOfHistoryItemResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionMeCasaYAutoIdPut**
> ItemResponse apiVversionMeCasaYAutoIdPut(id, version, updateItemRequest)

Edita un elemento propio (CAS-03): cambian solo los campos enviados. Uno ajeno o inexistente responde 404.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = CasaYAutoApi();
final id = id_example; // String | 
final version = version_example; // String | 
final updateItemRequest = UpdateItemRequest(); // UpdateItemRequest | 

try {
    final result = api_instance.apiVversionMeCasaYAutoIdPut(id, version, updateItemRequest);
    print(result);
} catch (e) {
    print('Exception when calling CasaYAutoApi->apiVversionMeCasaYAutoIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 
 **updateItemRequest** | [**UpdateItemRequest**](UpdateItemRequest.md)|  | 

### Return type

[**ItemResponse**](ItemResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionMeCasaYAutoPost**
> ItemResponse apiVversionMeCasaYAutoPost(version, createItemRequest)

Registra un auto o una cosa de la casa (CAS-02). Con 20 elementos ya registrados responde 409 `item_limit_reached`.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = CasaYAutoApi();
final version = version_example; // String | 
final createItemRequest = CreateItemRequest(); // CreateItemRequest | 

try {
    final result = api_instance.apiVversionMeCasaYAutoPost(version, createItemRequest);
    print(result);
} catch (e) {
    print('Exception when calling CasaYAutoApi->apiVversionMeCasaYAutoPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **createItemRequest** | [**CreateItemRequest**](CreateItemRequest.md)|  | 

### Return type

[**ItemResponse**](ItemResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

