# knock_api.api.MePendientesApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionMePendientesGet**](MePendientesApi.md#apivversionmependientesget) | **GET** /api/v{version}/me/pendientes | USR-09. Lista lo que hay pendiente antes de eliminar la cuenta: citas y cotizaciones abiertas (solo conteos e identificadores propios, máximo 50).


# **apiVversionMePendientesGet**
> PendingResponse apiVversionMePendientesGet(version)

USR-09. Lista lo que hay pendiente antes de eliminar la cuenta: citas y cotizaciones abiertas (solo conteos e identificadores propios, máximo 50).

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = MePendientesApi();
final version = version_example; // String | 

try {
    final result = api_instance.apiVversionMePendientesGet(version);
    print(result);
} catch (e) {
    print('Exception when calling MePendientesApi->apiVversionMePendientesGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 

### Return type

[**PendingResponse**](PendingResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

