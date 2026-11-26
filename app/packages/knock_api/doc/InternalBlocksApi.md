# knock_api.api.InternalBlocksApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionInternoBloqueosPost**](InternalBlocksApi.md#apivversioninternobloqueospost) | **POST** /api/v{version}/interno/bloqueos | 


# **apiVversionInternoBloqueosPost**
> apiVversionInternoBloqueosPost(version, blockEventBody)



### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = InternalBlocksApi();
final version = version_example; // String | 
final blockEventBody = BlockEventBody(); // BlockEventBody | 

try {
    api_instance.apiVversionInternoBloqueosPost(version, blockEventBody);
} catch (e) {
    print('Exception when calling InternalBlocksApi->apiVversionInternoBloqueosPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **blockEventBody** | [**BlockEventBody**](BlockEventBody.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

