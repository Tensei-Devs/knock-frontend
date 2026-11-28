# knock_api.api.ConversacionesApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionConversacionesGet**](ConversacionesApi.md#apivversionconversacionesget) | **GET** /api/v{version}/conversaciones | Las conversaciones de la persona, de la más reciente a la más antigua, con paginación por cursor (1 a 20) y el total de no leídos.
[**apiVversionConversacionesIdGet**](ConversacionesApi.md#apivversionconversacionesidget) | **GET** /api/v{version}/conversaciones/{id} | Una conversación, solo para sus dos participantes; para cualquier otra persona, 404.
[**apiVversionConversacionesNoLeidasGet**](ConversacionesApi.md#apivversionconversacionesnoleidasget) | **GET** /api/v{version}/conversaciones/no-leidas | La suma de los no leídos de la persona en todas sus conversaciones.
[**apiVversionConversacionesPost**](ConversacionesApi.md#apivversionconversacionespost) | **POST** /api/v{version}/conversaciones | Crea la conversación del par (solicitud, técnico) o devuelve la que ya existe: 201 la primera vez y 200 después. 409 `conversation_closed` si está cerrada; 20 por hora por persona.


# **apiVversionConversacionesGet**
> ConversacionPage apiVversionConversacionesGet(version, cursor, limit)

Las conversaciones de la persona, de la más reciente a la más antigua, con paginación por cursor (1 a 20) y el total de no leídos.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = ConversacionesApi();
final version = version_example; // String | 
final cursor = cursor_example; // String | Opaque cursor returned as nextCursor by the previous page.
final limit = 56; // int | Page size, 1 to 20. Defaults to 20.

try {
    final result = api_instance.apiVversionConversacionesGet(version, cursor, limit);
    print(result);
} catch (e) {
    print('Exception when calling ConversacionesApi->apiVversionConversacionesGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **cursor** | **String**| Opaque cursor returned as nextCursor by the previous page. | [optional] 
 **limit** | **int**| Page size, 1 to 20. Defaults to 20. | [optional] 

### Return type

[**ConversacionPage**](ConversacionPage.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionConversacionesIdGet**
> ConversacionView apiVversionConversacionesIdGet(id, version)

Una conversación, solo para sus dos participantes; para cualquier otra persona, 404.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = ConversacionesApi();
final id = id_example; // String | 
final version = version_example; // String | 

try {
    final result = api_instance.apiVversionConversacionesIdGet(id, version);
    print(result);
} catch (e) {
    print('Exception when calling ConversacionesApi->apiVversionConversacionesIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 

### Return type

[**ConversacionView**](ConversacionView.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionConversacionesNoLeidasGet**
> NoLeidasView apiVversionConversacionesNoLeidasGet(version)

La suma de los no leídos de la persona en todas sus conversaciones.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = ConversacionesApi();
final version = version_example; // String | 

try {
    final result = api_instance.apiVversionConversacionesNoLeidasGet(version);
    print(result);
} catch (e) {
    print('Exception when calling ConversacionesApi->apiVversionConversacionesNoLeidasGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 

### Return type

[**NoLeidasView**](NoLeidasView.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionConversacionesPost**
> ConversacionView apiVversionConversacionesPost(version, crearConversacionBody)

Crea la conversación del par (solicitud, técnico) o devuelve la que ya existe: 201 la primera vez y 200 después. 409 `conversation_closed` si está cerrada; 20 por hora por persona.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = ConversacionesApi();
final version = version_example; // String | 
final crearConversacionBody = CrearConversacionBody(); // CrearConversacionBody | 

try {
    final result = api_instance.apiVversionConversacionesPost(version, crearConversacionBody);
    print(result);
} catch (e) {
    print('Exception when calling ConversacionesApi->apiVversionConversacionesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **crearConversacionBody** | [**CrearConversacionBody**](CrearConversacionBody.md)|  | 

### Return type

[**ConversacionView**](ConversacionView.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

