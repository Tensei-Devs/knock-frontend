# knock_api.api.InternalEventsApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionInternoEventosPost**](InternalEventsApi.md#apivversioninternoeventospost) | **POST** /api/v{version}/interno/eventos | 


# **apiVversionInternoEventosPost**
> apiVversionInternoEventosPost(version, accountEventBody)



### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = InternalEventsApi();
final version = version_example; // String | 
final accountEventBody = AccountEventBody(); // AccountEventBody | 

try {
    api_instance.apiVversionInternoEventosPost(version, accountEventBody);
} catch (e) {
    print('Exception when calling InternalEventsApi->apiVversionInternoEventosPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **accountEventBody** | [**AccountEventBody**](AccountEventBody.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

