# knock_api.api.BusquedaApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionBusquedaGet**](BusquedaApi.md#apivversionbusquedaget) | **GET** /api/v{version}/busqueda | 


# **apiVversionBusquedaGet**
> BusquedaResponse apiVversionBusquedaGet(version, q, coloniaId, oficio, soloVerificados, cursor, limit)



### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = BusquedaApi();
final version = version_example; // String | 
final q = q_example; // String | Obligatorio; texto normalizado de 2 a 80 caracteres.
final coloniaId = coloniaId_example; // String | Obligatorio; ObjectId de la colonia activa.
final oficio = oficio_example; // String | Clave opcional de un oficio activo.
final soloVerificados = soloVerificados_example; // String | Booleano opcional true o false; por defecto false.
final cursor = cursor_example; // String | Cursor opaco de la consulta y versión del diccionario.
final limit = limit_example; // String | Entero de 1 a 20; por defecto 20.

try {
    final result = api_instance.apiVversionBusquedaGet(version, q, coloniaId, oficio, soloVerificados, cursor, limit);
    print(result);
} catch (e) {
    print('Exception when calling BusquedaApi->apiVversionBusquedaGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **q** | **String**| Obligatorio; texto normalizado de 2 a 80 caracteres. | [optional] 
 **coloniaId** | **String**| Obligatorio; ObjectId de la colonia activa. | [optional] 
 **oficio** | **String**| Clave opcional de un oficio activo. | [optional] 
 **soloVerificados** | **String**| Booleano opcional true o false; por defecto false. | [optional] 
 **cursor** | **String**| Cursor opaco de la consulta y versión del diccionario. | [optional] 
 **limit** | **String**| Entero de 1 a 20; por defecto 20. | [optional] 

### Return type

[**BusquedaResponse**](BusquedaResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

