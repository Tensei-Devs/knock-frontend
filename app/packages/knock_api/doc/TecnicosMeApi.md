# knock_api.api.TecnicosMeApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionTecnicosMeDisponibilidadPut**](TecnicosMeApi.md#apivversiontecnicosmedisponibilidadput) | **PUT** /api/v{version}/tecnicos/me/disponibilidad | Enciende o apaga «Disponible hoy» (TEC-09).
[**apiVversionTecnicosMeHorariosGet**](TecnicosMeApi.md#apivversiontecnicosmehorariosget) | **GET** /api/v{version}/tecnicos/me/horarios | Horarios de los siete días (TEC-10); sin horario guardado, todos cerrados.
[**apiVversionTecnicosMeHorariosPut**](TecnicosMeApi.md#apivversiontecnicosmehorariosput) | **PUT** /api/v{version}/tecnicos/me/horarios | Reemplaza los horarios de los siete días (TEC-11).
[**apiVversionTecnicosMePut**](TecnicosMeApi.md#apivversiontecnicosmeput) | **PUT** /api/v{version}/tecnicos/me | Edita el perfil público (TEC-08): cambian solo los campos enviados.


# **apiVversionTecnicosMeDisponibilidadPut**
> AvailabilityResponse apiVversionTecnicosMeDisponibilidadPut(version, availabilityBody)

Enciende o apaga «Disponible hoy» (TEC-09).

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = TecnicosMeApi();
final version = version_example; // String | 
final availabilityBody = AvailabilityBody(); // AvailabilityBody | 

try {
    final result = api_instance.apiVversionTecnicosMeDisponibilidadPut(version, availabilityBody);
    print(result);
} catch (e) {
    print('Exception when calling TecnicosMeApi->apiVversionTecnicosMeDisponibilidadPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **availabilityBody** | [**AvailabilityBody**](AvailabilityBody.md)|  | 

### Return type

[**AvailabilityResponse**](AvailabilityResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionTecnicosMeHorariosGet**
> ScheduleBody apiVversionTecnicosMeHorariosGet(version)

Horarios de los siete días (TEC-10); sin horario guardado, todos cerrados.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = TecnicosMeApi();
final version = version_example; // String | 

try {
    final result = api_instance.apiVversionTecnicosMeHorariosGet(version);
    print(result);
} catch (e) {
    print('Exception when calling TecnicosMeApi->apiVversionTecnicosMeHorariosGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 

### Return type

[**ScheduleBody**](ScheduleBody.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionTecnicosMeHorariosPut**
> ScheduleBody apiVversionTecnicosMeHorariosPut(version, scheduleBody)

Reemplaza los horarios de los siete días (TEC-11).

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = TecnicosMeApi();
final version = version_example; // String | 
final scheduleBody = ScheduleBody(); // ScheduleBody | 

try {
    final result = api_instance.apiVversionTecnicosMeHorariosPut(version, scheduleBody);
    print(result);
} catch (e) {
    print('Exception when calling TecnicosMeApi->apiVversionTecnicosMeHorariosPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **scheduleBody** | [**ScheduleBody**](ScheduleBody.md)|  | 

### Return type

[**ScheduleBody**](ScheduleBody.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionTecnicosMePut**
> TechnicianResponse apiVversionTecnicosMePut(version, updateTechnicianBody)

Edita el perfil público (TEC-08): cambian solo los campos enviados.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = TecnicosMeApi();
final version = version_example; // String | 
final updateTechnicianBody = UpdateTechnicianBody(); // UpdateTechnicianBody | 

try {
    final result = api_instance.apiVversionTecnicosMePut(version, updateTechnicianBody);
    print(result);
} catch (e) {
    print('Exception when calling TecnicosMeApi->apiVversionTecnicosMePut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **updateTechnicianBody** | [**UpdateTechnicianBody**](UpdateTechnicianBody.md)|  | 

### Return type

[**TechnicianResponse**](TechnicianResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

