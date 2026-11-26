# knock_api.api.ExplorarApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionExplorarGet**](ExplorarApi.md#apivversionexplorarget) | **GET** /api/v{version}/explorar | Bloques de Explorar (máximo 10 elementos cada uno). Sin sesión, solo los públicos; con sesión suma trabajos reales y cerca de ti.


# **apiVversionExplorarGet**
> ExploreResponse apiVversionExplorarGet(version, filtro, colonia)

Bloques de Explorar (máximo 10 elementos cada uno). Sin sesión, solo los públicos; con sesión suma trabajos reales y cerca de ti.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = ExplorarApi();
final version = version_example; // String | 
final filtro = filtro_example; // String | 
final colonia = colonia_example; // String | 

try {
    final result = api_instance.apiVversionExplorarGet(version, filtro, colonia);
    print(result);
} catch (e) {
    print('Exception when calling ExplorarApi->apiVversionExplorarGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **filtro** | **String**|  | [optional] 
 **colonia** | **String**|  | [optional] 

### Return type

[**ExploreResponse**](ExploreResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

