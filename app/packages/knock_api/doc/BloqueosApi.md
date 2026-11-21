# knock_api.api.BloqueosApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionMeBloqueosGet**](BloqueosApi.md#apivversionmebloqueosget) | **GET** /api/v{version}/me/bloqueos | A quién tiene bloqueado quien llama, de lo más reciente a lo más antiguo, con paginación por cursor y solo con identificador, nombre público y fecha.
[**apiVversionUsuariosIdBloqueoDelete**](BloqueosApi.md#apivversionusuariosidbloqueodelete) | **DELETE** /api/v{version}/usuarios/{id}/bloqueo | Quita el bloqueo («Deshacer»). 204; 404 `block_not_found` si no había.
[**apiVversionUsuariosIdBloqueoPost**](BloqueosApi.md#apivversionusuariosidbloqueopost) | **POST** /api/v{version}/usuarios/{id}/bloqueo | Bloquea a la persona de la ruta. 201; 404 `user_not_found`; 409 `already_blocked`; 422 si es uno mismo o el identificador no es válido.


# **apiVversionMeBloqueosGet**
> BlockedPage apiVversionMeBloqueosGet(version, cursor, limite)

A quién tiene bloqueado quien llama, de lo más reciente a lo más antiguo, con paginación por cursor y solo con identificador, nombre público y fecha.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = BloqueosApi();
final version = version_example; // String | 
final cursor = cursor_example; // String | Opaque cursor returned as nextCursor by the previous page.
final limite = 56; // int | Page size, 1 to 50. Defaults to 20.

try {
    final result = api_instance.apiVversionMeBloqueosGet(version, cursor, limite);
    print(result);
} catch (e) {
    print('Exception when calling BloqueosApi->apiVversionMeBloqueosGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **cursor** | **String**| Opaque cursor returned as nextCursor by the previous page. | [optional] 
 **limite** | **int**| Page size, 1 to 50. Defaults to 20. | [optional] 

### Return type

[**BlockedPage**](BlockedPage.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionUsuariosIdBloqueoDelete**
> apiVversionUsuariosIdBloqueoDelete(id, version)

Quita el bloqueo («Deshacer»). 204; 404 `block_not_found` si no había.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = BloqueosApi();
final id = id_example; // String | 
final version = version_example; // String | 

try {
    api_instance.apiVversionUsuariosIdBloqueoDelete(id, version);
} catch (e) {
    print('Exception when calling BloqueosApi->apiVversionUsuariosIdBloqueoDelete: $e\n');
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

# **apiVversionUsuariosIdBloqueoPost**
> apiVversionUsuariosIdBloqueoPost(id, version)

Bloquea a la persona de la ruta. 201; 404 `user_not_found`; 409 `already_blocked`; 422 si es uno mismo o el identificador no es válido.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = BloqueosApi();
final id = id_example; // String | 
final version = version_example; // String | 

try {
    api_instance.apiVversionUsuariosIdBloqueoPost(id, version);
} catch (e) {
    print('Exception when calling BloqueosApi->apiVversionUsuariosIdBloqueoPost: $e\n');
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

