# knock_api.api.InternalOpinionModeratedApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionInternoOpinionesModeradasPost**](InternalOpinionModeratedApi.md#apivversioninternoopinionesmoderadaspost) | **POST** /api/v{version}/interno/opiniones-moderadas | 


# **apiVversionInternoOpinionesModeradasPost**
> apiVversionInternoOpinionesModeradasPost(version, opinionModeratedEventBody)



### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = InternalOpinionModeratedApi();
final version = version_example; // String | 
final opinionModeratedEventBody = OpinionModeratedEventBody(); // OpinionModeratedEventBody | 

try {
    api_instance.apiVversionInternoOpinionesModeradasPost(version, opinionModeratedEventBody);
} catch (e) {
    print('Exception when calling InternalOpinionModeratedApi->apiVversionInternoOpinionesModeradasPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **opinionModeratedEventBody** | [**OpinionModeratedEventBody**](OpinionModeratedEventBody.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

