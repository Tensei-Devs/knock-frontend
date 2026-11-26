# knock_api.api.MarketReferenceApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionCotizacionesReferenciaMercadoGet**](MarketReferenceApi.md#apivversioncotizacionesreferenciamercadoget) | **GET** /api/v{version}/cotizaciones/referencia-mercado | 


# **apiVversionCotizacionesReferenciaMercadoGet**
> MarketReference apiVversionCotizacionesReferenciaMercadoGet(version, oficio, tipoTrabajo)



### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = MarketReferenceApi();
final version = version_example; // String | 
final oficio = oficio_example; // String | 
final tipoTrabajo = tipoTrabajo_example; // String | 

try {
    final result = api_instance.apiVversionCotizacionesReferenciaMercadoGet(version, oficio, tipoTrabajo);
    print(result);
} catch (e) {
    print('Exception when calling MarketReferenceApi->apiVversionCotizacionesReferenciaMercadoGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **oficio** | **String**|  | [optional] 
 **tipoTrabajo** | **String**|  | [optional] 

### Return type

[**MarketReference**](MarketReference.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

