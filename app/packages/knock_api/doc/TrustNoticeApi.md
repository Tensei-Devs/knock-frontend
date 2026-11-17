# knock_api.api.TrustNoticeApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionVisitasIdAvisoPost**](TrustNoticeApi.md#apivversionvisitasidavisopost) | **POST** /api/v{version}/visitas/{id}/aviso | El cliente dueño obtiene el texto para compartir con alguien de confianza. Solo con la visita `confirmada` o `en_curso`.


# **apiVversionVisitasIdAvisoPost**
> TrustNotice apiVversionVisitasIdAvisoPost(id, version)

El cliente dueño obtiene el texto para compartir con alguien de confianza. Solo con la visita `confirmada` o `en_curso`.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = TrustNoticeApi();
final id = id_example; // String | 
final version = version_example; // String | 

try {
    final result = api_instance.apiVversionVisitasIdAvisoPost(id, version);
    print(result);
} catch (e) {
    print('Exception when calling TrustNoticeApi->apiVversionVisitasIdAvisoPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 

### Return type

[**TrustNotice**](TrustNotice.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

