# knock_api.api.AsistenteApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionAsistenteBitacoraSolicitudIdGet**](AsistenteApi.md#apivversionasistentebitacorasolicitudidget) | **GET** /api/v{version}/asistente/bitacora/{solicitudId} | ASI-06: lee la bitácora propia; la de otro técnico responde 404 `log_not_found`.
[**apiVversionAsistenteBitacoraSolicitudIdPut**](AsistenteApi.md#apivversionasistentebitacorasolicitudidput) | **PUT** /api/v{version}/asistente/bitacora/{solicitudId} | ASI-05: guarda o reemplaza la bitácora del técnico (201 al crear, 200 al reemplazar).
[**apiVversionAsistenteBorradorCotizacionPost**](AsistenteApi.md#apivversionasistenteborradorcotizacionpost) | **POST** /api/v{version}/asistente/borrador-cotizacion | ASI-03: borrador editable de cotización; nunca se envía ni se guarda como cotización.
[**apiVversionAsistenteConversacionesPost**](AsistenteApi.md#apivversionasistenteconversacionespost) | **POST** /api/v{version}/asistente/conversaciones | ASI-01: un turno con el asistente Knock (cliente o técnico).
[**apiVversionAsistenteRangoPrecioGet**](AsistenteApi.md#apivversionasistenterangoprecioget) | **GET** /api/v{version}/asistente/rango-precio | ASI-04: rango de precio de la referencia de mercado (spec 048), en caché de 1 hora.
[**apiVversionAsistenteResumenChatPost**](AsistenteApi.md#apivversionasistenteresumenchatpost) | **POST** /api/v{version}/asistente/resumen-chat | ASI-02: resumen de una conversación en la que el técnico participa.


# **apiVversionAsistenteBitacoraSolicitudIdGet**
> BitacoraResponse apiVversionAsistenteBitacoraSolicitudIdGet(solicitudId, version)

ASI-06: lee la bitácora propia; la de otro técnico responde 404 `log_not_found`.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = AsistenteApi();
final solicitudId = solicitudId_example; // String | 
final version = version_example; // String | 

try {
    final result = api_instance.apiVversionAsistenteBitacoraSolicitudIdGet(solicitudId, version);
    print(result);
} catch (e) {
    print('Exception when calling AsistenteApi->apiVversionAsistenteBitacoraSolicitudIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **solicitudId** | **String**|  | 
 **version** | **String**|  | 

### Return type

[**BitacoraResponse**](BitacoraResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionAsistenteBitacoraSolicitudIdPut**
> BitacoraResponse apiVversionAsistenteBitacoraSolicitudIdPut(solicitudId, version, bitacoraBody)

ASI-05: guarda o reemplaza la bitácora del técnico (201 al crear, 200 al reemplazar).

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = AsistenteApi();
final solicitudId = solicitudId_example; // String | 
final version = version_example; // String | 
final bitacoraBody = BitacoraBody(); // BitacoraBody | 

try {
    final result = api_instance.apiVversionAsistenteBitacoraSolicitudIdPut(solicitudId, version, bitacoraBody);
    print(result);
} catch (e) {
    print('Exception when calling AsistenteApi->apiVversionAsistenteBitacoraSolicitudIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **solicitudId** | **String**|  | 
 **version** | **String**|  | 
 **bitacoraBody** | [**BitacoraBody**](BitacoraBody.md)|  | 

### Return type

[**BitacoraResponse**](BitacoraResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionAsistenteBorradorCotizacionPost**
> BorradorCotizacionResponse apiVversionAsistenteBorradorCotizacionPost(version, conversacionBody)

ASI-03: borrador editable de cotización; nunca se envía ni se guarda como cotización.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = AsistenteApi();
final version = version_example; // String | 
final conversacionBody = ConversacionBody(); // ConversacionBody | 

try {
    final result = api_instance.apiVversionAsistenteBorradorCotizacionPost(version, conversacionBody);
    print(result);
} catch (e) {
    print('Exception when calling AsistenteApi->apiVversionAsistenteBorradorCotizacionPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **conversacionBody** | [**ConversacionBody**](ConversacionBody.md)|  | 

### Return type

[**BorradorCotizacionResponse**](BorradorCotizacionResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionAsistenteConversacionesPost**
> TurnoResponse apiVversionAsistenteConversacionesPost(version, turnoBody)

ASI-01: un turno con el asistente Knock (cliente o técnico).

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = AsistenteApi();
final version = version_example; // String | 
final turnoBody = TurnoBody(); // TurnoBody | 

try {
    final result = api_instance.apiVversionAsistenteConversacionesPost(version, turnoBody);
    print(result);
} catch (e) {
    print('Exception when calling AsistenteApi->apiVversionAsistenteConversacionesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **turnoBody** | [**TurnoBody**](TurnoBody.md)|  | 

### Return type

[**TurnoResponse**](TurnoResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionAsistenteRangoPrecioGet**
> RangoPrecioResponse apiVversionAsistenteRangoPrecioGet(version, oficio, tipoTrabajo)

ASI-04: rango de precio de la referencia de mercado (spec 048), en caché de 1 hora.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = AsistenteApi();
final version = version_example; // String | 
final oficio = oficio_example; // String | 
final tipoTrabajo = tipoTrabajo_example; // String | 

try {
    final result = api_instance.apiVversionAsistenteRangoPrecioGet(version, oficio, tipoTrabajo);
    print(result);
} catch (e) {
    print('Exception when calling AsistenteApi->apiVversionAsistenteRangoPrecioGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **oficio** | **String**|  | [optional] 
 **tipoTrabajo** | **String**|  | [optional] 

### Return type

[**RangoPrecioResponse**](RangoPrecioResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionAsistenteResumenChatPost**
> ResumenChatResponse apiVversionAsistenteResumenChatPost(version, conversacionBody)

ASI-02: resumen de una conversación en la que el técnico participa.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = AsistenteApi();
final version = version_example; // String | 
final conversacionBody = ConversacionBody(); // ConversacionBody | 

try {
    final result = api_instance.apiVversionAsistenteResumenChatPost(version, conversacionBody);
    print(result);
} catch (e) {
    print('Exception when calling AsistenteApi->apiVversionAsistenteResumenChatPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **conversacionBody** | [**ConversacionBody**](ConversacionBody.md)|  | 

### Return type

[**ResumenChatResponse**](ResumenChatResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

