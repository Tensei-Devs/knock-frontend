# knock_api.api.ConversationPermissionApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionSolicitudesIdConversacionGet**](ConversationPermissionApi.md#apivversionsolicitudesidconversacionget) | **GET** /api/v{version}/solicitudes/{id}/conversacion | El permiso del par (solicitud, técnico) para quien pide: el cliente dueño debe mandar `tecnicoId`; el técnico no (se ignora si lo manda). Cualquier otro caso es 404 uniforme.


# **apiVversionSolicitudesIdConversacionGet**
> PermisoConversacion apiVversionSolicitudesIdConversacionGet(id, version, tecnicoId)

El permiso del par (solicitud, técnico) para quien pide: el cliente dueño debe mandar `tecnicoId`; el técnico no (se ignora si lo manda). Cualquier otro caso es 404 uniforme.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = ConversationPermissionApi();
final id = id_example; // String | 
final version = version_example; // String | 
final tecnicoId = tecnicoId_example; // String | 

try {
    final result = api_instance.apiVversionSolicitudesIdConversacionGet(id, version, tecnicoId);
    print(result);
} catch (e) {
    print('Exception when calling ConversationPermissionApi->apiVversionSolicitudesIdConversacionGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 
 **tecnicoId** | **String**|  | [optional] 

### Return type

[**PermisoConversacion**](PermisoConversacion.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

