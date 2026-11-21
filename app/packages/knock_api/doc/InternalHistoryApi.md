# knock_api.api.InternalHistoryApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionInternoHistorialGet**](InternalHistoryApi.md#apivversioninternohistorialget) | **GET** /api/v{version}/interno/historial | Visitas terminadas del cliente ligadas al elemento, de la más reciente a la más antigua, por cursor. Sin precios ni direcciones.


# **apiVversionInternoHistorialGet**
> CursorPageOfHistoryEntryResponse apiVversionInternoHistorialGet(version, usuarioId, elementoId, cursor, limite)

Visitas terminadas del cliente ligadas al elemento, de la más reciente a la más antigua, por cursor. Sin precios ni direcciones.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = InternalHistoryApi();
final version = version_example; // String | 
final usuarioId = usuarioId_example; // String | The sub of the client whose finished visits are listed.
final elementoId = elementoId_example; // String | The element id (24 hexadecimal characters) linked to the requests.
final cursor = cursor_example; // String | Opaque cursor returned as nextCursor by the previous page.
final limite = 56; // int | Page size, 1 to 50. Defaults to 20.

try {
    final result = api_instance.apiVversionInternoHistorialGet(version, usuarioId, elementoId, cursor, limite);
    print(result);
} catch (e) {
    print('Exception when calling InternalHistoryApi->apiVversionInternoHistorialGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **usuarioId** | **String**| The sub of the client whose finished visits are listed. | [optional] 
 **elementoId** | **String**| The element id (24 hexadecimal characters) linked to the requests. | [optional] 
 **cursor** | **String**| Opaque cursor returned as nextCursor by the previous page. | [optional] 
 **limite** | **int**| Page size, 1 to 50. Defaults to 20. | [optional] 

### Return type

[**CursorPageOfHistoryEntryResponse**](CursorPageOfHistoryEntryResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

