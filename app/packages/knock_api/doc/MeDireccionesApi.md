# knock_api.api.MeDireccionesApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionMeDireccionesGet**](MeDireccionesApi.md#apivversionmedireccionesget) | **GET** /api/v{version}/me/direcciones | Lista las direcciones de quien llama, la más reciente primero. Sin paginar: una persona tiene pocas.
[**apiVversionMeDireccionesIdDelete**](MeDireccionesApi.md#apivversionmedireccionesiddelete) | **DELETE** /api/v{version}/me/direcciones/{id} | Elimina una dirección propia. Una dirección ajena responde 404 igual que una que no existe (R-14).
[**apiVversionMeDireccionesIdPut**](MeDireccionesApi.md#apivversionmedireccionesidput) | **PUT** /api/v{version}/me/direcciones/{id} | Edita los campos enviados de una dirección propia. Una dirección ajena responde 404 igual que una que no existe (R-14).
[**apiVversionMeDireccionesPost**](MeDireccionesApi.md#apivversionmedireccionespost) | **POST** /api/v{version}/me/direcciones | Guarda una dirección nueva. Un valor inválido responde 422 con `errors.&lt;campo&gt;` sin repetirlo; una colonia que no está en el catálogo, 422 en `errors.colonia`.


# **apiVversionMeDireccionesGet**
> List<AddressResponse> apiVversionMeDireccionesGet(version)

Lista las direcciones de quien llama, la más reciente primero. Sin paginar: una persona tiene pocas.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = MeDireccionesApi();
final version = version_example; // String | 

try {
    final result = api_instance.apiVversionMeDireccionesGet(version);
    print(result);
} catch (e) {
    print('Exception when calling MeDireccionesApi->apiVversionMeDireccionesGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 

### Return type

[**List<AddressResponse>**](AddressResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionMeDireccionesIdDelete**
> apiVversionMeDireccionesIdDelete(id, version)

Elimina una dirección propia. Una dirección ajena responde 404 igual que una que no existe (R-14).

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = MeDireccionesApi();
final id = id_example; // String | 
final version = version_example; // String | 

try {
    api_instance.apiVversionMeDireccionesIdDelete(id, version);
} catch (e) {
    print('Exception when calling MeDireccionesApi->apiVversionMeDireccionesIdDelete: $e\n');
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

# **apiVversionMeDireccionesIdPut**
> AddressResponse apiVversionMeDireccionesIdPut(id, version, updateAddressRequest)

Edita los campos enviados de una dirección propia. Una dirección ajena responde 404 igual que una que no existe (R-14).

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = MeDireccionesApi();
final id = id_example; // String | 
final version = version_example; // String | 
final updateAddressRequest = UpdateAddressRequest(); // UpdateAddressRequest | 

try {
    final result = api_instance.apiVversionMeDireccionesIdPut(id, version, updateAddressRequest);
    print(result);
} catch (e) {
    print('Exception when calling MeDireccionesApi->apiVversionMeDireccionesIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 
 **updateAddressRequest** | [**UpdateAddressRequest**](UpdateAddressRequest.md)|  | 

### Return type

[**AddressResponse**](AddressResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionMeDireccionesPost**
> AddressResponse apiVversionMeDireccionesPost(version, createAddressRequest)

Guarda una dirección nueva. Un valor inválido responde 422 con `errors.&lt;campo&gt;` sin repetirlo; una colonia que no está en el catálogo, 422 en `errors.colonia`.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = MeDireccionesApi();
final version = version_example; // String | 
final createAddressRequest = CreateAddressRequest(); // CreateAddressRequest | 

try {
    final result = api_instance.apiVversionMeDireccionesPost(version, createAddressRequest);
    print(result);
} catch (e) {
    print('Exception when calling MeDireccionesApi->apiVversionMeDireccionesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **createAddressRequest** | [**CreateAddressRequest**](CreateAddressRequest.md)|  | 

### Return type

[**AddressResponse**](AddressResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

