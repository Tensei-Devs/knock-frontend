# knock_api.api.InternalTechnicianHiddenApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionInternoTecnicosOcultadosPost**](InternalTechnicianHiddenApi.md#apivversioninternotecnicosocultadospost) | **POST** /api/v{version}/interno/tecnicos-ocultados | 


# **apiVversionInternoTecnicosOcultadosPost**
> apiVversionInternoTecnicosOcultadosPost(version, technicianHiddenEventBody)



### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = InternalTechnicianHiddenApi();
final version = version_example; // String | 
final technicianHiddenEventBody = TechnicianHiddenEventBody(); // TechnicianHiddenEventBody | 

try {
    api_instance.apiVversionInternoTecnicosOcultadosPost(version, technicianHiddenEventBody);
} catch (e) {
    print('Exception when calling InternalTechnicianHiddenApi->apiVversionInternoTecnicosOcultadosPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **technicianHiddenEventBody** | [**TechnicianHiddenEventBody**](TechnicianHiddenEventBody.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

