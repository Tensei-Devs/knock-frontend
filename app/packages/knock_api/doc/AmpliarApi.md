# knock_api.api.AmpliarApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionSolicitudesIdAmpliarPost**](AmpliarApi.md#apivversionsolicitudesidampliarpost) | **POST** /api/v{version}/solicitudes/{id}/ampliar | 


# **apiVversionSolicitudesIdAmpliarPost**
> ExtendRequestResponse apiVversionSolicitudesIdAmpliarPost(id, version)



### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = AmpliarApi();
final id = id_example; // String | 
final version = version_example; // String | 

try {
    final result = api_instance.apiVversionSolicitudesIdAmpliarPost(id, version);
    print(result);
} catch (e) {
    print('Exception when calling AmpliarApi->apiVversionSolicitudesIdAmpliarPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 

### Return type

[**ExtendRequestResponse**](ExtendRequestResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

