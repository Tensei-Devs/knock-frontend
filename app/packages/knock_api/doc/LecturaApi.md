# knock_api.api.LecturaApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionConversacionesIdLeidoPost**](LecturaApi.md#apivversionconversacionesidleidopost) | **POST** /api/v{version}/conversaciones/{id}/leido | Marca como leído hasta `hasta` (acotado al último mensaje). Repetirlo o mandar una fecha anterior responde 204 sin cambios.
[**apiVversionConversacionesIdMensajesGet**](LecturaApi.md#apivversionconversacionesidmensajesget) | **GET** /api/v{version}/conversaciones/{id}/mensajes | Los mensajes de la conversación del más reciente al más antiguo, con paginación por cursor (`limit` de 1 a 50, 30 por omisión).


# **apiVversionConversacionesIdLeidoPost**
> apiVversionConversacionesIdLeidoPost(id, version, leidoBody)

Marca como leído hasta `hasta` (acotado al último mensaje). Repetirlo o mandar una fecha anterior responde 204 sin cambios.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = LecturaApi();
final id = id_example; // String | 
final version = version_example; // String | 
final leidoBody = LeidoBody(); // LeidoBody | 

try {
    api_instance.apiVversionConversacionesIdLeidoPost(id, version, leidoBody);
} catch (e) {
    print('Exception when calling LecturaApi->apiVversionConversacionesIdLeidoPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 
 **leidoBody** | [**LeidoBody**](LeidoBody.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionConversacionesIdMensajesGet**
> CursorPageOfMensajeView apiVversionConversacionesIdMensajesGet(id, version, cursor, limit)

Los mensajes de la conversación del más reciente al más antiguo, con paginación por cursor (`limit` de 1 a 50, 30 por omisión).

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = LecturaApi();
final id = id_example; // String | 
final version = version_example; // String | 
final cursor = cursor_example; // String | Opaque cursor returned as nextCursor by the previous page.
final limit = 56; // int | Page size, 1 to 50. Defaults to 30.

try {
    final result = api_instance.apiVversionConversacionesIdMensajesGet(id, version, cursor, limit);
    print(result);
} catch (e) {
    print('Exception when calling LecturaApi->apiVversionConversacionesIdMensajesGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 
 **cursor** | **String**| Opaque cursor returned as nextCursor by the previous page. | [optional] 
 **limit** | **int**| Page size, 1 to 50. Defaults to 30. | [optional] 

### Return type

[**CursorPageOfMensajeView**](CursorPageOfMensajeView.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

