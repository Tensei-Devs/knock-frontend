# knock_api.api.AuthApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionAuthFirebasePost**](AuthApi.md#apivversionauthfirebasepost) | **POST** /api/v{version}/auth/firebase | Registro e inicio de sesión en un solo endpoint (spec 015): 201 con cuenta nueva, 200 con cuenta existente.


# **apiVversionAuthFirebasePost**
> SessionResponse apiVversionAuthFirebasePost(version, firebaseExchangeRequest)

Registro e inicio de sesión en un solo endpoint (spec 015): 201 con cuenta nueva, 200 con cuenta existente.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = AuthApi();
final version = version_example; // String | 
final firebaseExchangeRequest = FirebaseExchangeRequest(); // FirebaseExchangeRequest | 

try {
    final result = api_instance.apiVversionAuthFirebasePost(version, firebaseExchangeRequest);
    print(result);
} catch (e) {
    print('Exception when calling AuthApi->apiVversionAuthFirebasePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **firebaseExchangeRequest** | [**FirebaseExchangeRequest**](FirebaseExchangeRequest.md)|  | 

### Return type

[**SessionResponse**](SessionResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

