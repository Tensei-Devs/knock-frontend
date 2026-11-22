# knock_api.api.TrustedTechniciansApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionMeTecnicosConfianzaGet**](TrustedTechniciansApi.md#apivversionmetecnicosconfianzaget) | **GET** /api/v{version}/me/tecnicos-confianza | Los técnicos guardados, del más reciente al más antiguo, con paginación por cursor. Un técnico oculto no aparece.
[**apiVversionMeTecnicosConfianzaTecnicoIdDelete**](TrustedTechniciansApi.md#apivversionmetecnicosconfianzatecnicoiddelete) | **DELETE** /api/v{version}/me/tecnicos-confianza/{tecnicoId} | Quita al técnico de la lista: 204; si no estaba, 404 `trusted_technician_not_found`.
[**apiVversionMeTecnicosConfianzaTecnicoIdPut**](TrustedTechniciansApi.md#apivversionmetecnicosconfianzatecnicoidput) | **PUT** /api/v{version}/me/tecnicos-confianza/{tecnicoId} | Guarda al técnico: 201 la primera vez y 200 al repetir, sin duplicar. Un técnico que no existe o está oculto responde 404 `technician_not_found`.


# **apiVversionMeTecnicosConfianzaGet**
> TrustedTechnicianPage apiVversionMeTecnicosConfianzaGet(version, cursor, limite)

Los técnicos guardados, del más reciente al más antiguo, con paginación por cursor. Un técnico oculto no aparece.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = TrustedTechniciansApi();
final version = version_example; // String | 
final cursor = cursor_example; // String | Opaque cursor returned as nextCursor by the previous page.
final limite = 56; // int | Page size, 1 to 50. Defaults to 20.

try {
    final result = api_instance.apiVversionMeTecnicosConfianzaGet(version, cursor, limite);
    print(result);
} catch (e) {
    print('Exception when calling TrustedTechniciansApi->apiVversionMeTecnicosConfianzaGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **cursor** | **String**| Opaque cursor returned as nextCursor by the previous page. | [optional] 
 **limite** | **int**| Page size, 1 to 50. Defaults to 20. | [optional] 

### Return type

[**TrustedTechnicianPage**](TrustedTechnicianPage.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionMeTecnicosConfianzaTecnicoIdDelete**
> apiVversionMeTecnicosConfianzaTecnicoIdDelete(tecnicoId, version)

Quita al técnico de la lista: 204; si no estaba, 404 `trusted_technician_not_found`.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = TrustedTechniciansApi();
final tecnicoId = tecnicoId_example; // String | 
final version = version_example; // String | 

try {
    api_instance.apiVversionMeTecnicosConfianzaTecnicoIdDelete(tecnicoId, version);
} catch (e) {
    print('Exception when calling TrustedTechniciansApi->apiVversionMeTecnicosConfianzaTecnicoIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tecnicoId** | **String**|  | 
 **version** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionMeTecnicosConfianzaTecnicoIdPut**
> TrustedTechnician apiVversionMeTecnicosConfianzaTecnicoIdPut(tecnicoId, version)

Guarda al técnico: 201 la primera vez y 200 al repetir, sin duplicar. Un técnico que no existe o está oculto responde 404 `technician_not_found`.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = TrustedTechniciansApi();
final tecnicoId = tecnicoId_example; // String | 
final version = version_example; // String | 

try {
    final result = api_instance.apiVversionMeTecnicosConfianzaTecnicoIdPut(tecnicoId, version);
    print(result);
} catch (e) {
    print('Exception when calling TrustedTechniciansApi->apiVversionMeTecnicosConfianzaTecnicoIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tecnicoId** | **String**|  | 
 **version** | **String**|  | 

### Return type

[**TrustedTechnician**](TrustedTechnician.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

