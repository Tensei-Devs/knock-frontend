# knock_api.api.MeConsentimientosApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionMeConsentimientosGet**](MeConsentimientosApi.md#apivversionmeconsentimientosget) | **GET** /api/v{version}/me/consentimientos | USR-07. Lista los consentimientos con su versión y fecha.
[**apiVversionMeConsentimientosPut**](MeConsentimientosApi.md#apivversionmeconsentimientosput) | **PUT** /api/v{version}/me/consentimientos | USR-08. Activa o retira un consentimiento opcional (promociones, encuestas, recomendaciones); surte efecto de inmediato.


# **apiVversionMeConsentimientosGet**
> List<ConsentResponse> apiVversionMeConsentimientosGet(version)

USR-07. Lista los consentimientos con su versión y fecha.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = MeConsentimientosApi();
final version = version_example; // String | 

try {
    final result = api_instance.apiVversionMeConsentimientosGet(version);
    print(result);
} catch (e) {
    print('Exception when calling MeConsentimientosApi->apiVversionMeConsentimientosGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 

### Return type

[**List<ConsentResponse>**](ConsentResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionMeConsentimientosPut**
> ConsentResponse apiVversionMeConsentimientosPut(version, updateConsentRequest)

USR-08. Activa o retira un consentimiento opcional (promociones, encuestas, recomendaciones); surte efecto de inmediato.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = MeConsentimientosApi();
final version = version_example; // String | 
final updateConsentRequest = UpdateConsentRequest(); // UpdateConsentRequest | 

try {
    final result = api_instance.apiVversionMeConsentimientosPut(version, updateConsentRequest);
    print(result);
} catch (e) {
    print('Exception when calling MeConsentimientosApi->apiVversionMeConsentimientosPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **updateConsentRequest** | [**UpdateConsentRequest**](UpdateConsentRequest.md)|  | 

### Return type

[**ConsentResponse**](ConsentResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

