# knock_api.api.MapaApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionMapaTecnicosGet**](MapaApi.md#apivversionmapatecnicosget) | **GET** /api/v{version}/mapa/tecnicos | Técnicos de la zona visible, agrupados por celda según el zoom (hasta 200 grupos). Ninguna coordenada de la petición se guarda ni se registra.


# **apiVversionMapaTecnicosGet**
> MapResponse apiVversionMapaTecnicosGet(version, norte, sur, este, oeste, oficio, zoom)

Técnicos de la zona visible, agrupados por celda según el zoom (hasta 200 grupos). Ninguna coordenada de la petición se guarda ni se registra.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = MapaApi();
final version = version_example; // String | 
final norte = norte_example; // String | 
final sur = sur_example; // String | 
final este = este_example; // String | 
final oeste = oeste_example; // String | 
final oficio = oficio_example; // String | 
final zoom = zoom_example; // String | 

try {
    final result = api_instance.apiVversionMapaTecnicosGet(version, norte, sur, este, oeste, oficio, zoom);
    print(result);
} catch (e) {
    print('Exception when calling MapaApi->apiVversionMapaTecnicosGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **norte** | **String**|  | [optional] 
 **sur** | **String**|  | [optional] 
 **este** | **String**|  | [optional] 
 **oeste** | **String**|  | [optional] 
 **oficio** | **String**|  | [optional] 
 **zoom** | **String**|  | [optional] 

### Return type

[**MapResponse**](MapResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

