# knock_api.api.MyQuotesApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionTecnicosMeCotizacionesGet**](MyQuotesApi.md#apivversiontecnicosmecotizacionesget) | **GET** /api/v{version}/tecnicos/me/cotizaciones | 


# **apiVversionTecnicosMeCotizacionesGet**
> MyQuotePage apiVversionTecnicosMeCotizacionesGet(version, estado, cursor, limite)



### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = MyQuotesApi();
final version = version_example; // String | 
final estado = estado_example; // String | 
final cursor = cursor_example; // String | 
final limite = limite_example; // String | 

try {
    final result = api_instance.apiVversionTecnicosMeCotizacionesGet(version, estado, cursor, limite);
    print(result);
} catch (e) {
    print('Exception when calling MyQuotesApi->apiVversionTecnicosMeCotizacionesGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **estado** | **String**|  | [optional] 
 **cursor** | **String**|  | [optional] 
 **limite** | **String**|  | [optional] 

### Return type

[**MyQuotePage**](MyQuotePage.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

