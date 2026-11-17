# knock_api.api.VisitasApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionVisitasIdGet**](VisitasApi.md#apivversionvisitasidget) | **GET** /api/v{version}/visitas/{id} | Vista del cliente (con el código cuando corresponde) o del técnico (con la dirección y sin código). Cualquier otra persona recibe 404.


# **apiVversionVisitasIdGet**
> VisitResponse apiVversionVisitasIdGet(id, version)

Vista del cliente (con el código cuando corresponde) o del técnico (con la dirección y sin código). Cualquier otra persona recibe 404.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = VisitasApi();
final id = id_example; // String | 
final version = version_example; // String | 

try {
    final result = api_instance.apiVversionVisitasIdGet(id, version);
    print(result);
} catch (e) {
    print('Exception when calling VisitasApi->apiVversionVisitasIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 

### Return type

[**VisitResponse**](VisitResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

