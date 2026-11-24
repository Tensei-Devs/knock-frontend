# knock_api.api.AvisosApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionAvisosGet**](AvisosApi.md#apivversionavisosget) | **GET** /api/v{version}/avisos | Lista los avisos de quien llama, del más reciente al más antiguo, por cursor (20 por omisión, 50 como máximo).
[**apiVversionAvisosIdLeidoPost**](AvisosApi.md#apivversionavisosidleidopost) | **POST** /api/v{version}/avisos/{id}/leido | Marca un aviso como leído; repetirlo responde 204 igual. Uno ajeno o inexistente responde 404 `notice_not_found`.
[**apiVversionAvisosLeidosPost**](AvisosApi.md#apivversionavisosleidospost) | **POST** /api/v{version}/avisos/leidos | Marca como leídos todos los avisos de quien llama y solo los suyos.
[**apiVversionAvisosNoLeidosContadorGet**](AvisosApi.md#apivversionavisosnoleidoscontadorget) | **GET** /api/v{version}/avisos/no-leidos/contador | Cantidad de avisos sin leer, hasta 99; no se cachea.


# **apiVversionAvisosGet**
> NoticeListResponse apiVversionAvisosGet(version, cursor, limite, leido, comoRol)

Lista los avisos de quien llama, del más reciente al más antiguo, por cursor (20 por omisión, 50 como máximo).

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = AvisosApi();
final version = version_example; // String | 
final cursor = cursor_example; // String | 
final limite = limite_example; // String | 
final leido = leido_example; // String | 
final comoRol = comoRol_example; // String | 

try {
    final result = api_instance.apiVversionAvisosGet(version, cursor, limite, leido, comoRol);
    print(result);
} catch (e) {
    print('Exception when calling AvisosApi->apiVversionAvisosGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **cursor** | **String**|  | [optional] 
 **limite** | **String**|  | [optional] 
 **leido** | **String**|  | [optional] 
 **comoRol** | **String**|  | [optional] 

### Return type

[**NoticeListResponse**](NoticeListResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionAvisosIdLeidoPost**
> apiVversionAvisosIdLeidoPost(id, version)

Marca un aviso como leído; repetirlo responde 204 igual. Uno ajeno o inexistente responde 404 `notice_not_found`.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = AvisosApi();
final id = id_example; // String | 
final version = version_example; // String | 

try {
    api_instance.apiVversionAvisosIdLeidoPost(id, version);
} catch (e) {
    print('Exception when calling AvisosApi->apiVversionAvisosIdLeidoPost: $e\n');
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

# **apiVversionAvisosLeidosPost**
> apiVversionAvisosLeidosPost(version)

Marca como leídos todos los avisos de quien llama y solo los suyos.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = AvisosApi();
final version = version_example; // String | 

try {
    api_instance.apiVversionAvisosLeidosPost(version);
} catch (e) {
    print('Exception when calling AvisosApi->apiVversionAvisosLeidosPost: $e\n');
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

# **apiVversionAvisosNoLeidosContadorGet**
> UnreadCountResponse apiVversionAvisosNoLeidosContadorGet(version)

Cantidad de avisos sin leer, hasta 99; no se cachea.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = AvisosApi();
final version = version_example; // String | 

try {
    final result = api_instance.apiVversionAvisosNoLeidosContadorGet(version);
    print(result);
} catch (e) {
    print('Exception when calling AvisosApi->apiVversionAvisosNoLeidosContadorGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 

### Return type

[**UnreadCountResponse**](UnreadCountResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

