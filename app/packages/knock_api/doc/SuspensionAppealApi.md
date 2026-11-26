# knock_api.api.SuspensionAppealApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionSuspensionApelacionGet**](SuspensionAppealApi.md#apivversionsuspensionapelacionget) | **GET** /api/v{version}/suspension/apelacion | Estado de la apelación (R-09). 200 con estado y fechas; 401; 404 uniforme; 429.
[**apiVversionSuspensionApelacionPost**](SuspensionAppealApi.md#apivversionsuspensionapelacionpost) | **POST** /api/v{version}/suspension/apelacion | Presenta la apelación de la suspensión vigente (R-01 a R-05). 200 con el estado; 401, 404 uniforme, 409 `appeal_not_allowed`.


# **apiVversionSuspensionApelacionGet**
> SuspensionAppealView apiVversionSuspensionApelacionGet(version)

Estado de la apelación (R-09). 200 con estado y fechas; 401; 404 uniforme; 429.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = SuspensionAppealApi();
final version = version_example; // String | 

try {
    final result = api_instance.apiVversionSuspensionApelacionGet(version);
    print(result);
} catch (e) {
    print('Exception when calling SuspensionAppealApi->apiVversionSuspensionApelacionGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 

### Return type

[**SuspensionAppealView**](SuspensionAppealView.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionSuspensionApelacionPost**
> SuspensionAppealView apiVversionSuspensionApelacionPost(version, suspensionAppealBody)

Presenta la apelación de la suspensión vigente (R-01 a R-05). 200 con el estado; 401, 404 uniforme, 409 `appeal_not_allowed`.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = SuspensionAppealApi();
final version = version_example; // String | 
final suspensionAppealBody = SuspensionAppealBody(); // SuspensionAppealBody | 

try {
    final result = api_instance.apiVversionSuspensionApelacionPost(version, suspensionAppealBody);
    print(result);
} catch (e) {
    print('Exception when calling SuspensionAppealApi->apiVversionSuspensionApelacionPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **suspensionAppealBody** | [**SuspensionAppealBody**](SuspensionAppealBody.md)|  | 

### Return type

[**SuspensionAppealView**](SuspensionAppealView.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

