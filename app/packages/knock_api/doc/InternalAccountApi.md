# knock_api.api.InternalAccountApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionInternoCuentasUsuarioIdCancelacionesPost**](InternalAccountApi.md#apivversioninternocuentasusuarioidcancelacionespost) | **POST** /api/v{version}/interno/cuentas/{usuarioId}/cancelaciones | Cancela las solicitudes abiertas y retira las cotizaciones pendientes de la persona, avisando a la otra parte.
[**apiVversionInternoCuentasUsuarioIdEliminadaPost**](InternalAccountApi.md#apivversioninternocuentasusuarioideliminadapost) | **POST** /api/v{version}/interno/cuentas/{usuarioId}/eliminada | Consume `CuentaEliminada`: responde 202 cuando Mercado ya cerró y anonimizó lo de la persona (repetirlo no cambia nada).
[**apiVversionInternoCuentasUsuarioIdExportacionGet**](InternalAccountApi.md#apivversioninternocuentasusuarioidexportacionget) | **GET** /api/v{version}/interno/cuentas/{usuarioId}/exportacion | Datos de la persona en Mercado para su exportación (un JSON).
[**apiVversionInternoCuentasUsuarioIdPendientesGet**](InternalAccountApi.md#apivversioninternocuentasusuarioidpendientesget) | **GET** /api/v{version}/interno/cuentas/{usuarioId}/pendientes | Citas y cotizaciones abiertas de la persona, con conteos e identificadores propios (máximo 50 por grupo).


# **apiVversionInternoCuentasUsuarioIdCancelacionesPost**
> apiVversionInternoCuentasUsuarioIdCancelacionesPost(usuarioId, version)

Cancela las solicitudes abiertas y retira las cotizaciones pendientes de la persona, avisando a la otra parte.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = InternalAccountApi();
final usuarioId = usuarioId_example; // String | 
final version = version_example; // String | 

try {
    api_instance.apiVversionInternoCuentasUsuarioIdCancelacionesPost(usuarioId, version);
} catch (e) {
    print('Exception when calling InternalAccountApi->apiVversionInternoCuentasUsuarioIdCancelacionesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **usuarioId** | **String**|  | 
 **version** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionInternoCuentasUsuarioIdEliminadaPost**
> apiVversionInternoCuentasUsuarioIdEliminadaPost(usuarioId, version)

Consume `CuentaEliminada`: responde 202 cuando Mercado ya cerró y anonimizó lo de la persona (repetirlo no cambia nada).

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = InternalAccountApi();
final usuarioId = usuarioId_example; // String | 
final version = version_example; // String | 

try {
    api_instance.apiVversionInternoCuentasUsuarioIdEliminadaPost(usuarioId, version);
} catch (e) {
    print('Exception when calling InternalAccountApi->apiVversionInternoCuentasUsuarioIdEliminadaPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **usuarioId** | **String**|  | 
 **version** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionInternoCuentasUsuarioIdExportacionGet**
> apiVversionInternoCuentasUsuarioIdExportacionGet(usuarioId, version)

Datos de la persona en Mercado para su exportación (un JSON).

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = InternalAccountApi();
final usuarioId = usuarioId_example; // String | 
final version = version_example; // String | 

try {
    api_instance.apiVversionInternoCuentasUsuarioIdExportacionGet(usuarioId, version);
} catch (e) {
    print('Exception when calling InternalAccountApi->apiVversionInternoCuentasUsuarioIdExportacionGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **usuarioId** | **String**|  | 
 **version** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionInternoCuentasUsuarioIdPendientesGet**
> AccountPendingResponse apiVversionInternoCuentasUsuarioIdPendientesGet(usuarioId, version)

Citas y cotizaciones abiertas de la persona, con conteos e identificadores propios (máximo 50 por grupo).

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = InternalAccountApi();
final usuarioId = usuarioId_example; // String | 
final version = version_example; // String | 

try {
    final result = api_instance.apiVversionInternoCuentasUsuarioIdPendientesGet(usuarioId, version);
    print(result);
} catch (e) {
    print('Exception when calling InternalAccountApi->apiVversionInternoCuentasUsuarioIdPendientesGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **usuarioId** | **String**|  | 
 **version** | **String**|  | 

### Return type

[**AccountPendingResponse**](AccountPendingResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

