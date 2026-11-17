# knock_api.api.ColoniaExistsApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionColoniasExisteGet**](ColoniaExistsApi.md#apivversioncoloniasexisteget) | **GET** /api/v{version}/colonias/existe | 200 en ambos casos; el nombre se compara sin mayúsculas ni acentos y no se registra. El 422 lo da `ValidationFilter` antes de esta acción.


# **apiVversionColoniasExisteGet**
> NeighborhoodExistsResponse apiVversionColoniasExisteGet(nombre, version)

200 en ambos casos; el nombre se compara sin mayúsculas ni acentos y no se registra. El 422 lo da `ValidationFilter` antes de esta acción.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = ColoniaExistsApi();
final nombre = nombre_example; // String | Name of the colonia. Letters, digits, spaces and . , ' ’ ( ) / # - ; up to 80 characters. Exactly one value. Case and accents are ignored.
final version = version_example; // String | 

try {
    final result = api_instance.apiVversionColoniasExisteGet(nombre, version);
    print(result);
} catch (e) {
    print('Exception when calling ColoniaExistsApi->apiVversionColoniasExisteGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **nombre** | **String**| Name of the colonia. Letters, digits, spaces and . , ' ’ ( ) / # - ; up to 80 characters. Exactly one value. Case and accents are ignored. | 
 **version** | **String**|  | 

### Return type

[**NeighborhoodExistsResponse**](NeighborhoodExistsResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

