# knock_api.api.VisitScheduleApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionAgendaGet**](VisitScheduleApi.md#apivversionagendaget) | **GET** /api/v{version}/agenda | VIS-02: agenda del técnico entre `desde` y `hasta` (por omisión hoy y 14 días), por fecha y hora, con cursor.
[**apiVversionVisitasIdCancelarPost**](VisitScheduleApi.md#apivversionvisitasidcancelarpost) | **POST** /api/v{version}/visitas/{id}/cancelar | VIS-06: cancela con motivo obligatorio; con menos de 24 horas queda `tardia`.
[**apiVversionVisitasIdClienteAusentePost**](VisitScheduleApi.md#apivversionvisitasidclienteausentepost) | **POST** /api/v{version}/visitas/{id}/cliente-ausente | VIS-07: el técnico registra que el cliente no estaba, dentro de la ventana de la cita y sin penalizar.
[**apiVversionVisitasIdNoTerminadoPost**](VisitScheduleApi.md#apivversionvisitasidnoterminadopost) | **POST** /api/v{version}/visitas/{id}/no-terminado | VIS-10: el cliente reporta que no se terminó, una sola vez y hasta 7 días después.
[**apiVversionVisitasIdPermisoFotosPut**](VisitScheduleApi.md#apivversionvisitasidpermisofotosput) | **PUT** /api/v{version}/visitas/{id}/permiso-fotos | VIS-11: el cliente autoriza o no publicar las fotos del trabajo.
[**apiVversionVisitasIdReprogramarPost**](VisitScheduleApi.md#apivversionvisitasidreprogramarpost) | **POST** /api/v{version}/visitas/{id}/reprogramar | VIS-04: una parte propone otra fecha para la visita.
[**apiVversionVisitasIdReprogramarRespuestaPost**](VisitScheduleApi.md#apivversionvisitasidreprogramarrespuestapost) | **POST** /api/v{version}/visitas/{id}/reprogramar/respuesta | VIS-05: la otra parte confirma o rechaza la propuesta.
[**apiVversionVisitasIdTecnicoAusentePost**](VisitScheduleApi.md#apivversionvisitasidtecnicoausentepost) | **POST** /api/v{version}/visitas/{id}/tecnico-ausente | VIS-12 (spec 064): el cliente dueño reporta que el técnico no llegó, dentro de la ventana de la cita. Sin cuerpo; repetirlo es idempotente.
[**apiVversionVisitasIdTerminarPost**](VisitScheduleApi.md#apivversionvisitasidterminarpost) | **POST** /api/v{version}/visitas/{id}/terminar | VIS-09: el técnico termina la visita en curso con descripción y fotos; no hay confirmación del cliente.


# **apiVversionAgendaGet**
> AgendaResponse apiVversionAgendaGet(version, desde, hasta, cursor, limite)

VIS-02: agenda del técnico entre `desde` y `hasta` (por omisión hoy y 14 días), por fecha y hora, con cursor.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = VisitScheduleApi();
final version = version_example; // String | 
final desde = desde_example; // String | First day of the range, yyyy-MM-dd. Defaults to today.
final hasta = hasta_example; // String | Last day of the range, yyyy-MM-dd. Defaults to 14 days after the first day. The range is 31 days at most.
final cursor = cursor_example; // String | Opaque cursor returned as nextCursor by the previous page.
final limite = 56; // int | Page size, 1 to 50. Defaults to 20.

try {
    final result = api_instance.apiVversionAgendaGet(version, desde, hasta, cursor, limite);
    print(result);
} catch (e) {
    print('Exception when calling VisitScheduleApi->apiVversionAgendaGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **desde** | **String**| First day of the range, yyyy-MM-dd. Defaults to today. | [optional] 
 **hasta** | **String**| Last day of the range, yyyy-MM-dd. Defaults to 14 days after the first day. The range is 31 days at most. | [optional] 
 **cursor** | **String**| Opaque cursor returned as nextCursor by the previous page. | [optional] 
 **limite** | **int**| Page size, 1 to 50. Defaults to 20. | [optional] 

### Return type

[**AgendaResponse**](AgendaResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionVisitasIdCancelarPost**
> CancelVisitResponse apiVversionVisitasIdCancelarPost(id, version, cancelVisitBody)

VIS-06: cancela con motivo obligatorio; con menos de 24 horas queda `tardia`.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = VisitScheduleApi();
final id = id_example; // String | 
final version = version_example; // String | 
final cancelVisitBody = CancelVisitBody(); // CancelVisitBody | 

try {
    final result = api_instance.apiVversionVisitasIdCancelarPost(id, version, cancelVisitBody);
    print(result);
} catch (e) {
    print('Exception when calling VisitScheduleApi->apiVversionVisitasIdCancelarPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 
 **cancelVisitBody** | [**CancelVisitBody**](CancelVisitBody.md)|  | 

### Return type

[**CancelVisitResponse**](CancelVisitResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionVisitasIdClienteAusentePost**
> ClientAbsentResponse apiVversionVisitasIdClienteAusentePost(id, version)

VIS-07: el técnico registra que el cliente no estaba, dentro de la ventana de la cita y sin penalizar.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = VisitScheduleApi();
final id = id_example; // String | 
final version = version_example; // String | 

try {
    final result = api_instance.apiVversionVisitasIdClienteAusentePost(id, version);
    print(result);
} catch (e) {
    print('Exception when calling VisitScheduleApi->apiVversionVisitasIdClienteAusentePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 

### Return type

[**ClientAbsentResponse**](ClientAbsentResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionVisitasIdNoTerminadoPost**
> NotFinishedResponse apiVversionVisitasIdNoTerminadoPost(id, version, notFinishedBody)

VIS-10: el cliente reporta que no se terminó, una sola vez y hasta 7 días después.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = VisitScheduleApi();
final id = id_example; // String | 
final version = version_example; // String | 
final notFinishedBody = NotFinishedBody(); // NotFinishedBody | 

try {
    final result = api_instance.apiVversionVisitasIdNoTerminadoPost(id, version, notFinishedBody);
    print(result);
} catch (e) {
    print('Exception when calling VisitScheduleApi->apiVversionVisitasIdNoTerminadoPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 
 **notFinishedBody** | [**NotFinishedBody**](NotFinishedBody.md)|  | 

### Return type

[**NotFinishedResponse**](NotFinishedResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionVisitasIdPermisoFotosPut**
> PhotoPermissionResponse apiVversionVisitasIdPermisoFotosPut(id, version, photoPermissionBody)

VIS-11: el cliente autoriza o no publicar las fotos del trabajo.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = VisitScheduleApi();
final id = id_example; // String | 
final version = version_example; // String | 
final photoPermissionBody = PhotoPermissionBody(); // PhotoPermissionBody | 

try {
    final result = api_instance.apiVversionVisitasIdPermisoFotosPut(id, version, photoPermissionBody);
    print(result);
} catch (e) {
    print('Exception when calling VisitScheduleApi->apiVversionVisitasIdPermisoFotosPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 
 **photoPermissionBody** | [**PhotoPermissionBody**](PhotoPermissionBody.md)|  | 

### Return type

[**PhotoPermissionResponse**](PhotoPermissionResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionVisitasIdReprogramarPost**
> RescheduleProposalResponse apiVversionVisitasIdReprogramarPost(id, version, rescheduleBody)

VIS-04: una parte propone otra fecha para la visita.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = VisitScheduleApi();
final id = id_example; // String | 
final version = version_example; // String | 
final rescheduleBody = RescheduleBody(); // RescheduleBody | 

try {
    final result = api_instance.apiVversionVisitasIdReprogramarPost(id, version, rescheduleBody);
    print(result);
} catch (e) {
    print('Exception when calling VisitScheduleApi->apiVversionVisitasIdReprogramarPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 
 **rescheduleBody** | [**RescheduleBody**](RescheduleBody.md)|  | 

### Return type

[**RescheduleProposalResponse**](RescheduleProposalResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionVisitasIdReprogramarRespuestaPost**
> RescheduleReplyResponse apiVversionVisitasIdReprogramarRespuestaPost(id, version, rescheduleReplyBody)

VIS-05: la otra parte confirma o rechaza la propuesta.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = VisitScheduleApi();
final id = id_example; // String | 
final version = version_example; // String | 
final rescheduleReplyBody = RescheduleReplyBody(); // RescheduleReplyBody | 

try {
    final result = api_instance.apiVversionVisitasIdReprogramarRespuestaPost(id, version, rescheduleReplyBody);
    print(result);
} catch (e) {
    print('Exception when calling VisitScheduleApi->apiVversionVisitasIdReprogramarRespuestaPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 
 **rescheduleReplyBody** | [**RescheduleReplyBody**](RescheduleReplyBody.md)|  | 

### Return type

[**RescheduleReplyResponse**](RescheduleReplyResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionVisitasIdTecnicoAusentePost**
> TechnicianAbsentResponse apiVversionVisitasIdTecnicoAusentePost(id, version)

VIS-12 (spec 064): el cliente dueño reporta que el técnico no llegó, dentro de la ventana de la cita. Sin cuerpo; repetirlo es idempotente.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = VisitScheduleApi();
final id = id_example; // String | 
final version = version_example; // String | 

try {
    final result = api_instance.apiVversionVisitasIdTecnicoAusentePost(id, version);
    print(result);
} catch (e) {
    print('Exception when calling VisitScheduleApi->apiVversionVisitasIdTecnicoAusentePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 

### Return type

[**TechnicianAbsentResponse**](TechnicianAbsentResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionVisitasIdTerminarPost**
> FinishVisitResponse apiVversionVisitasIdTerminarPost(id, version, finishVisitBody)

VIS-09: el técnico termina la visita en curso con descripción y fotos; no hay confirmación del cliente.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = VisitScheduleApi();
final id = id_example; // String | 
final version = version_example; // String | 
final finishVisitBody = FinishVisitBody(); // FinishVisitBody | 

try {
    final result = api_instance.apiVversionVisitasIdTerminarPost(id, version, finishVisitBody);
    print(result);
} catch (e) {
    print('Exception when calling VisitScheduleApi->apiVversionVisitasIdTerminarPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 
 **finishVisitBody** | [**FinishVisitBody**](FinishVisitBody.md)|  | 

### Return type

[**FinishVisitResponse**](FinishVisitResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

