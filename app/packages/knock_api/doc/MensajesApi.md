# knock_api.api.MensajesApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionConversacionesIdMensajesPost**](MensajesApi.md#apivversionconversacionesidmensajespost) | **POST** /api/v{version}/conversaciones/{id}/mensajes | Envía un mensaje: oculta datos de contacto antes de elegir, lo modera y lo guarda; luego lo entrega en vivo.


# **apiVversionConversacionesIdMensajesPost**
> MensajeResponse apiVversionConversacionesIdMensajesPost(id, version, enviarMensajeRequest)

Envía un mensaje: oculta datos de contacto antes de elegir, lo modera y lo guarda; luego lo entrega en vivo.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = MensajesApi();
final id = id_example; // String | 
final version = version_example; // String | 
final enviarMensajeRequest = EnviarMensajeRequest(); // EnviarMensajeRequest | 

try {
    final result = api_instance.apiVversionConversacionesIdMensajesPost(id, version, enviarMensajeRequest);
    print(result);
} catch (e) {
    print('Exception when calling MensajesApi->apiVversionConversacionesIdMensajesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 
 **enviarMensajeRequest** | [**EnviarMensajeRequest**](EnviarMensajeRequest.md)|  | 

### Return type

[**MensajeResponse**](MensajeResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

