# knock_api.api.InternalNotFinishedReportsApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionInternoReportesNoTerminadosPost**](InternalNotFinishedReportsApi.md#apivversioninternoreportesnoterminadospost) | **POST** /api/v{version}/interno/reportes-no-terminados | 


# **apiVversionInternoReportesNoTerminadosPost**
> apiVversionInternoReportesNoTerminadosPost(version, notFinishedReportEventBody)



### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = InternalNotFinishedReportsApi();
final version = version_example; // String | 
final notFinishedReportEventBody = NotFinishedReportEventBody(); // NotFinishedReportEventBody | 

try {
    api_instance.apiVversionInternoReportesNoTerminadosPost(version, notFinishedReportEventBody);
} catch (e) {
    print('Exception when calling InternalNotFinishedReportsApi->apiVversionInternoReportesNoTerminadosPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **notFinishedReportEventBody** | [**NotFinishedReportEventBody**](NotFinishedReportEventBody.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

