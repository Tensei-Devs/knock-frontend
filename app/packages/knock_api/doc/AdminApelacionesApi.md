# knock_api.api.AdminApelacionesApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionAdminApelacionesIdResolucionPost**](AdminApelacionesApi.md#apivversionadminapelacionesidresolucionpost) | **POST** /api/v{version}/admin/apelaciones/{id}/resolucion | Acepta (reactiva la cuenta) o rechaza la apelación. 404 `appeal_not_found`; 409 `appeal_already_resolved`; 403 `self_review_not_allowed`.


# **apiVversionAdminApelacionesIdResolucionPost**
> AppealResolutionResult apiVversionAdminApelacionesIdResolucionPost(id, version, appealResolutionBody)

Acepta (reactiva la cuenta) o rechaza la apelación. 404 `appeal_not_found`; 409 `appeal_already_resolved`; 403 `self_review_not_allowed`.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = AdminApelacionesApi();
final id = id_example; // String | 
final version = version_example; // String | 
final appealResolutionBody = AppealResolutionBody(); // AppealResolutionBody | 

try {
    final result = api_instance.apiVversionAdminApelacionesIdResolucionPost(id, version, appealResolutionBody);
    print(result);
} catch (e) {
    print('Exception when calling AdminApelacionesApi->apiVversionAdminApelacionesIdResolucionPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 
 **appealResolutionBody** | [**AppealResolutionBody**](AppealResolutionBody.md)|  | 

### Return type

[**AppealResolutionResult**](AppealResolutionResult.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

