# knock_api.api.DescarteApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionSolicitudesIdDescartarPost**](DescarteApi.md#apivversionsolicitudesiddescartarpost) | **POST** /api/v{version}/solicitudes/{id}/descartar | 


# **apiVversionSolicitudesIdDescartarPost**
> apiVversionSolicitudesIdDescartarPost(id, version)



### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = DescarteApi();
final id = id_example; // String | 
final version = version_example; // String | 

try {
    api_instance.apiVversionSolicitudesIdDescartarPost(id, version);
} catch (e) {
    print('Exception when calling DescarteApi->apiVversionSolicitudesIdDescartarPost: $e\n');
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
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

