# knock_api.api.CancelacionApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionSolicitudesIdCancelarPost**](CancelacionApi.md#apivversionsolicitudesidcancelarpost) | **POST** /api/v{version}/solicitudes/{id}/cancelar | Cancela la solicitud del cliente mientras no tenga cita. Es idempotente: repetirla devuelve el mismo cuerpo sin otro evento.


# **apiVversionSolicitudesIdCancelarPost**
> CancelRequestResponse apiVversionSolicitudesIdCancelarPost(id, version, cancelRequestBody)

Cancela la solicitud del cliente mientras no tenga cita. Es idempotente: repetirla devuelve el mismo cuerpo sin otro evento.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = CancelacionApi();
final id = id_example; // String | 
final version = version_example; // String | 
final cancelRequestBody = CancelRequestBody(); // CancelRequestBody | 

try {
    final result = api_instance.apiVversionSolicitudesIdCancelarPost(id, version, cancelRequestBody);
    print(result);
} catch (e) {
    print('Exception when calling CancelacionApi->apiVversionSolicitudesIdCancelarPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 
 **cancelRequestBody** | [**CancelRequestBody**](CancelRequestBody.md)|  | [optional] 

### Return type

[**CancelRequestResponse**](CancelRequestResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

