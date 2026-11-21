# knock_api.api.MeEliminacionApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionMeEliminacionCancelarPost**](MeEliminacionApi.md#apivversionmeeliminacioncancelarpost) | **POST** /api/v{version}/me/eliminacion/cancelar | USR-11. Cancela la eliminación durante los 7 días de gracia.
[**apiVversionMeEliminacionPost**](MeEliminacionApi.md#apivversionmeeliminacionpost) | **POST** /api/v{version}/me/eliminacion | USR-10. Programa la eliminación con 7 días de gracia y cancela de inmediato las solicitudes abiertas y las cotizaciones pendientes. Se confirma con el texto `ELIMINAR`; con una sesión de más de 24 horas pide además el token de Firebase.


# **apiVversionMeEliminacionCancelarPost**
> apiVversionMeEliminacionCancelarPost(version)

USR-11. Cancela la eliminación durante los 7 días de gracia.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = MeEliminacionApi();
final version = version_example; // String | 

try {
    api_instance.apiVversionMeEliminacionCancelarPost(version);
} catch (e) {
    print('Exception when calling MeEliminacionApi->apiVversionMeEliminacionCancelarPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionMeEliminacionPost**
> DeletionScheduledResponse apiVversionMeEliminacionPost(version, deleteAccountRequest)

USR-10. Programa la eliminación con 7 días de gracia y cancela de inmediato las solicitudes abiertas y las cotizaciones pendientes. Se confirma con el texto `ELIMINAR`; con una sesión de más de 24 horas pide además el token de Firebase.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = MeEliminacionApi();
final version = version_example; // String | 
final deleteAccountRequest = DeleteAccountRequest(); // DeleteAccountRequest | 

try {
    final result = api_instance.apiVversionMeEliminacionPost(version, deleteAccountRequest);
    print(result);
} catch (e) {
    print('Exception when calling MeEliminacionApi->apiVversionMeEliminacionPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **deleteAccountRequest** | [**DeleteAccountRequest**](DeleteAccountRequest.md)|  | 

### Return type

[**DeletionScheduledResponse**](DeletionScheduledResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

