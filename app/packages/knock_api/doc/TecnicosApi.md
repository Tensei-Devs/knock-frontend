# knock_api.api.TecnicosApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionTecnicosAutocompletarGet**](TecnicosApi.md#apivversiontecnicosautocompletarget) | **GET** /api/v{version}/tecnicos/autocompletar | Sugerencias de oficios y negocios mientras se escribe (TEC-03): hasta 8, públicas y sin registrar el texto.
[**apiVversionTecnicosGet**](TecnicosApi.md#apivversiontecnicosget) | **GET** /api/v{version}/tecnicos | Busca técnicos por filtros, orden y cursor (TEC-02, spec 046, R-04): solo técnicos `activo` y visibles; es pública y la respuesta no se cachea (ninguna clave lleva datos de otra persona). `radioKm` es 3, 5, 8 o 12; por defecto devuelve 20 técnicos (máx. 50) y el cursor de la página siguiente; un cursor mal formado o `limite` fuera de rango responde 422.
[**apiVversionTecnicosIdFotosTrabajosGet**](TecnicosApi.md#apivversiontecnicosidfotostrabajosget) | **GET** /api/v{version}/tecnicos/{id}/fotos-trabajos | Fotos de trabajos terminados que el cliente permitió publicar y que pasaron la moderación (TEC-07), por cursor (20 por defecto, máx. 50). 404 si el técnico no existe o está oculto; el servidor guarda cada página 1 minuto.
[**apiVversionTecnicosIdGet**](TecnicosApi.md#apivversiontecnicosidget) | **GET** /api/v{version}/tecnicos/{id} | Perfil de un técnico (TEC-05): sin sesión, solo el resumen; con sesión válida, también el detalle. Un técnico que no existe o está oculto responde 404 `technician_not_found`.
[**apiVversionTecnicosIdLlegaAMiColoniaGet**](TecnicosApi.md#apivversiontecnicosidllegaamicoloniaget) | **GET** /api/v{version}/tecnicos/{id}/llega-a-mi-colonia | Dice si el técnico atiende la colonia de la persona (TEC-06). 404 si el técnico no existe o está oculto; 422 si la colonia no está en el catálogo.
[**apiVversionTecnicosPost**](TecnicosApi.md#apivversiontecnicospost) | **POST** /api/v{version}/tecnicos | Registra a la persona del token como técnico (TEC-01): nace `activo`, sin verificación y con «Disponible hoy» apagado.


# **apiVversionTecnicosAutocompletarGet**
> AutocompleteResponse apiVversionTecnicosAutocompletarGet(version, q)

Sugerencias de oficios y negocios mientras se escribe (TEC-03): hasta 8, públicas y sin registrar el texto.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = TecnicosApi();
final version = version_example; // String | 
final q = q_example; // String | 

try {
    final result = api_instance.apiVversionTecnicosAutocompletarGet(version, q);
    print(result);
} catch (e) {
    print('Exception when calling TecnicosApi->apiVversionTecnicosAutocompletarGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **q** | **String**|  | [optional] 

### Return type

[**AutocompleteResponse**](AutocompleteResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionTecnicosGet**
> TechnicianListResponse apiVversionTecnicosGet(version, oficio, colonia, lat, lng, radioKm, disponibleHoy, soloVerificados, orden, cursor, limite)

Busca técnicos por filtros, orden y cursor (TEC-02, spec 046, R-04): solo técnicos `activo` y visibles; es pública y la respuesta no se cachea (ninguna clave lleva datos de otra persona). `radioKm` es 3, 5, 8 o 12; por defecto devuelve 20 técnicos (máx. 50) y el cursor de la página siguiente; un cursor mal formado o `limite` fuera de rango responde 422.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = TecnicosApi();
final version = version_example; // String | 
final oficio = oficio_example; // String | 
final colonia = colonia_example; // String | 
final lat = lat_example; // String | 
final lng = lng_example; // String | 
final radioKm = radioKm_example; // String | 
final disponibleHoy = disponibleHoy_example; // String | 
final soloVerificados = soloVerificados_example; // String | 
final orden = orden_example; // String | 
final cursor = cursor_example; // String | 
final limite = limite_example; // String | 

try {
    final result = api_instance.apiVversionTecnicosGet(version, oficio, colonia, lat, lng, radioKm, disponibleHoy, soloVerificados, orden, cursor, limite);
    print(result);
} catch (e) {
    print('Exception when calling TecnicosApi->apiVversionTecnicosGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **oficio** | **String**|  | [optional] 
 **colonia** | **String**|  | [optional] 
 **lat** | **String**|  | [optional] 
 **lng** | **String**|  | [optional] 
 **radioKm** | **String**|  | [optional] 
 **disponibleHoy** | **String**|  | [optional] 
 **soloVerificados** | **String**|  | [optional] 
 **orden** | **String**|  | [optional] 
 **cursor** | **String**|  | [optional] 
 **limite** | **String**|  | [optional] 

### Return type

[**TechnicianListResponse**](TechnicianListResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionTecnicosIdFotosTrabajosGet**
> WorkPhotoListResponse apiVversionTecnicosIdFotosTrabajosGet(id, version, cursor, limite)

Fotos de trabajos terminados que el cliente permitió publicar y que pasaron la moderación (TEC-07), por cursor (20 por defecto, máx. 50). 404 si el técnico no existe o está oculto; el servidor guarda cada página 1 minuto.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = TecnicosApi();
final id = id_example; // String | 
final version = version_example; // String | 
final cursor = cursor_example; // String | 
final limite = limite_example; // String | 

try {
    final result = api_instance.apiVversionTecnicosIdFotosTrabajosGet(id, version, cursor, limite);
    print(result);
} catch (e) {
    print('Exception when calling TecnicosApi->apiVversionTecnicosIdFotosTrabajosGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 
 **cursor** | **String**|  | [optional] 
 **limite** | **String**|  | [optional] 

### Return type

[**WorkPhotoListResponse**](WorkPhotoListResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionTecnicosIdGet**
> TechnicianProfileResponse apiVversionTecnicosIdGet(id, version)

Perfil de un técnico (TEC-05): sin sesión, solo el resumen; con sesión válida, también el detalle. Un técnico que no existe o está oculto responde 404 `technician_not_found`.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = TecnicosApi();
final id = id_example; // String | 
final version = version_example; // String | 

try {
    final result = api_instance.apiVversionTecnicosIdGet(id, version);
    print(result);
} catch (e) {
    print('Exception when calling TecnicosApi->apiVversionTecnicosIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 

### Return type

[**TechnicianProfileResponse**](TechnicianProfileResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionTecnicosIdLlegaAMiColoniaGet**
> CoverageResponse apiVversionTecnicosIdLlegaAMiColoniaGet(id, version, colonia)

Dice si el técnico atiende la colonia de la persona (TEC-06). 404 si el técnico no existe o está oculto; 422 si la colonia no está en el catálogo.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = TecnicosApi();
final id = id_example; // String | 
final version = version_example; // String | 
final colonia = colonia_example; // String | 

try {
    final result = api_instance.apiVversionTecnicosIdLlegaAMiColoniaGet(id, version, colonia);
    print(result);
} catch (e) {
    print('Exception when calling TecnicosApi->apiVversionTecnicosIdLlegaAMiColoniaGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 
 **colonia** | **String**|  | [optional] 

### Return type

[**CoverageResponse**](CoverageResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionTecnicosPost**
> TechnicianResponse apiVversionTecnicosPost(version, registerTechnicianBody)

Registra a la persona del token como técnico (TEC-01): nace `activo`, sin verificación y con «Disponible hoy» apagado.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = TecnicosApi();
final version = version_example; // String | 
final registerTechnicianBody = RegisterTechnicianBody(); // RegisterTechnicianBody | 

try {
    final result = api_instance.apiVversionTecnicosPost(version, registerTechnicianBody);
    print(result);
} catch (e) {
    print('Exception when calling TecnicosApi->apiVversionTecnicosPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **registerTechnicianBody** | [**RegisterTechnicianBody**](RegisterTechnicianBody.md)|  | 

### Return type

[**TechnicianResponse**](TechnicianResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

