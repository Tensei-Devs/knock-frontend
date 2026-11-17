# knock_api.api.RefreshApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionAuthRefreshPost**](RefreshApi.md#apivversionauthrefreshpost) | **POST** /api/v{version}/auth/refresh | Cambia un token de renovación por un par nuevo (spec 016). Cualquier rechazo responde el mismo 401 sin motivo.


# **apiVversionAuthRefreshPost**
> RefreshResponse apiVversionAuthRefreshPost(version, refreshRequest)

Cambia un token de renovación por un par nuevo (spec 016). Cualquier rechazo responde el mismo 401 sin motivo.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = RefreshApi();
final version = version_example; // String | 
final refreshRequest = RefreshRequest(); // RefreshRequest | 

try {
    final result = api_instance.apiVversionAuthRefreshPost(version, refreshRequest);
    print(result);
} catch (e) {
    print('Exception when calling RefreshApi->apiVversionAuthRefreshPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **refreshRequest** | [**RefreshRequest**](RefreshRequest.md)|  | 

### Return type

[**RefreshResponse**](RefreshResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

