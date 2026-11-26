# knock_api.api.TrabajoApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionTecnicosMeTrabajoGet**](TrabajoApi.md#apivversiontecnicosmetrabajoget) | **GET** /api/v{version}/tecnicos/me/trabajo | 


# **apiVversionTecnicosMeTrabajoGet**
> TrabajoResponse apiVversionTecnicosMeTrabajoGet(version, cursorTerminadas, limit)



### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = TrabajoApi();
final version = version_example; // String | 
final cursorTerminadas = cursorTerminadas_example; // String | 
final limit = 56; // int | 

try {
    final result = api_instance.apiVversionTecnicosMeTrabajoGet(version, cursorTerminadas, limit);
    print(result);
} catch (e) {
    print('Exception when calling TrabajoApi->apiVversionTecnicosMeTrabajoGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **cursorTerminadas** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**TrabajoResponse**](TrabajoResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

