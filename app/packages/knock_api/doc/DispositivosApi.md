# knock_api.api.DispositivosApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionDispositivosIdDelete**](DispositivosApi.md#apivversiondispositivosiddelete) | **DELETE** /api/v{version}/dispositivos/{id} | Borra el dispositivo de la persona (spec 037, R-02): 204 también si ya no existe o es de otra persona.
[**apiVversionDispositivosPost**](DispositivosApi.md#apivversiondispositivospost) | **POST** /api/v{version}/dispositivos | Registra el token de notificaciones del dispositivo (spec 037, R-01): 201 la primera vez, 200 si ya estaba. 409 `device_conflict` si otra persona lo registró a la vez; 503 `devices_unavailable` con el registro de dispositivos apagado (sin llaves de cifrado); 20 por hora por persona.


# **apiVversionDispositivosIdDelete**
> apiVversionDispositivosIdDelete(id, version)

Borra el dispositivo de la persona (spec 037, R-02): 204 también si ya no existe o es de otra persona.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = DispositivosApi();
final id = id_example; // String | 
final version = version_example; // String | 

try {
    api_instance.apiVversionDispositivosIdDelete(id, version);
} catch (e) {
    print('Exception when calling DispositivosApi->apiVversionDispositivosIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionDispositivosPost**
> IdDispositivo apiVversionDispositivosPost(version, registroDispositivo)

Registra el token de notificaciones del dispositivo (spec 037, R-01): 201 la primera vez, 200 si ya estaba. 409 `device_conflict` si otra persona lo registró a la vez; 503 `devices_unavailable` con el registro de dispositivos apagado (sin llaves de cifrado); 20 por hora por persona.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = DispositivosApi();
final version = version_example; // String | 
final registroDispositivo = RegistroDispositivo(); // RegistroDispositivo | 

try {
    final result = api_instance.apiVversionDispositivosPost(version, registroDispositivo);
    print(result);
} catch (e) {
    print('Exception when calling DispositivosApi->apiVversionDispositivosPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **registroDispositivo** | [**RegistroDispositivo**](RegistroDispositivo.md)|  | 

### Return type

[**IdDispositivo**](IdDispositivo.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

