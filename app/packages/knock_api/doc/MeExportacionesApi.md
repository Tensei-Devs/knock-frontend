# knock_api.api.MeExportacionesApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionMeExportacionesPost**](MeExportacionesApi.md#apivversionmeexportacionespost) | **POST** /api/v{version}/me/exportaciones | USR-06. Pide la descarga de todos los datos propios; se entrega en 48 horas. Una sola en curso por persona.


# **apiVversionMeExportacionesPost**
> apiVversionMeExportacionesPost(version)

USR-06. Pide la descarga de todos los datos propios; se entrega en 48 horas. Una sola en curso por persona.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = MeExportacionesApi();
final version = version_example; // String | 

try {
    api_instance.apiVversionMeExportacionesPost(version);
} catch (e) {
    print('Exception when calling MeExportacionesApi->apiVversionMeExportacionesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

