# knock_api.api.FotosVerificacionApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionMeVerificacionIdFotosTipoConfirmarPost**](FotosVerificacionApi.md#apivversionmeverificacionidfotostipoconfirmarpost) | **POST** /api/v{version}/me/verificacion/{id}/fotos/{tipo}/confirmar | 


# **apiVversionMeVerificacionIdFotosTipoConfirmarPost**
> PhotoConfirmedResponse apiVversionMeVerificacionIdFotosTipoConfirmarPost(id, tipo, version)



### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = FotosVerificacionApi();
final id = id_example; // String | 
final tipo = tipo_example; // String | 
final version = version_example; // String | 

try {
    final result = api_instance.apiVversionMeVerificacionIdFotosTipoConfirmarPost(id, tipo, version);
    print(result);
} catch (e) {
    print('Exception when calling FotosVerificacionApi->apiVversionMeVerificacionIdFotosTipoConfirmarPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **tipo** | **String**|  | 
 **version** | **String**|  | 

### Return type

[**PhotoConfirmedResponse**](PhotoConfirmedResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

