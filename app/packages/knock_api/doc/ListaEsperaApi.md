# knock_api.api.ListaEsperaApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionZonasListaEsperaPost**](ListaEsperaApi.md#apivversionzonaslistaesperapost) | **POST** /api/v{version}/zonas/lista-espera | 


# **apiVversionZonasListaEsperaPost**
> WaitlistResponse apiVversionZonasListaEsperaPost(version, waitlistRequest)



### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = ListaEsperaApi();
final version = version_example; // String | 
final waitlistRequest = WaitlistRequest(); // WaitlistRequest | 

try {
    final result = api_instance.apiVversionZonasListaEsperaPost(version, waitlistRequest);
    print(result);
} catch (e) {
    print('Exception when calling ListaEsperaApi->apiVversionZonasListaEsperaPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **waitlistRequest** | [**WaitlistRequest**](WaitlistRequest.md)|  | 

### Return type

[**WaitlistResponse**](WaitlistResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

