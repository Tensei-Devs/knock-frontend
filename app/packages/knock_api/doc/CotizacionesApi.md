# knock_api.api.CotizacionesApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionSolicitudesIdCotizacionesPost**](CotizacionesApi.md#apivversionsolicitudesidcotizacionespost) | **POST** /api/v{version}/solicitudes/{id}/cotizaciones | 


# **apiVversionSolicitudesIdCotizacionesPost**
> QuoteResponse apiVversionSolicitudesIdCotizacionesPost(id, version, quoteRequest)



### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = CotizacionesApi();
final id = id_example; // String | 
final version = version_example; // String | 
final quoteRequest = QuoteRequest(); // QuoteRequest | 

try {
    final result = api_instance.apiVversionSolicitudesIdCotizacionesPost(id, version, quoteRequest);
    print(result);
} catch (e) {
    print('Exception when calling CotizacionesApi->apiVversionSolicitudesIdCotizacionesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 
 **quoteRequest** | [**QuoteRequest**](QuoteRequest.md)|  | 

### Return type

[**QuoteResponse**](QuoteResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

