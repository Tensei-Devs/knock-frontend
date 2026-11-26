# knock_api.api.ImagenesApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionImagenesSubidasIdConfirmarPost**](ImagenesApi.md#apivversionimagenessubidasidconfirmarpost) | **POST** /api/v{version}/imagenes/subidas/{id}/confirmar | 
[**apiVversionImagenesSubidasPost**](ImagenesApi.md#apivversionimagenessubidaspost) | **POST** /api/v{version}/imagenes/subidas | 


# **apiVversionImagenesSubidasIdConfirmarPost**
> ImagenConfirmadaResponse apiVversionImagenesSubidasIdConfirmarPost(id, version)



### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = ImagenesApi();
final id = id_example; // String | 
final version = version_example; // String | 

try {
    final result = api_instance.apiVversionImagenesSubidasIdConfirmarPost(id, version);
    print(result);
} catch (e) {
    print('Exception when calling ImagenesApi->apiVversionImagenesSubidasIdConfirmarPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 

### Return type

[**ImagenConfirmadaResponse**](ImagenConfirmadaResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionImagenesSubidasPost**
> SubidaImagenResponse apiVversionImagenesSubidasPost(version, pedirSubidaImagenRequest)



### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = ImagenesApi();
final version = version_example; // String | 
final pedirSubidaImagenRequest = PedirSubidaImagenRequest(); // PedirSubidaImagenRequest | 

try {
    final result = api_instance.apiVversionImagenesSubidasPost(version, pedirSubidaImagenRequest);
    print(result);
} catch (e) {
    print('Exception when calling ImagenesApi->apiVversionImagenesSubidasPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **pedirSubidaImagenRequest** | [**PedirSubidaImagenRequest**](PedirSubidaImagenRequest.md)|  | 

### Return type

[**SubidaImagenResponse**](SubidaImagenResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

