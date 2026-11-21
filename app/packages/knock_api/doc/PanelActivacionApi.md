# knock_api.api.PanelActivacionApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionPanelActivacionPost**](PanelActivacionApi.md#apivversionpanelactivacionpost) | **POST** /api/v{version}/panel/activacion | Consume el enlace y entrega el secreto una sola vez. 410 `activation_invalid` con el mismo cuerpo para cualquier enlace inservible.


# **apiVversionPanelActivacionPost**
> PanelActivacionResponse apiVversionPanelActivacionPost(version, panelActivacionRequest)

Consume el enlace y entrega el secreto una sola vez. 410 `activation_invalid` con el mismo cuerpo para cualquier enlace inservible.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = PanelActivacionApi();
final version = version_example; // String | 
final panelActivacionRequest = PanelActivacionRequest(); // PanelActivacionRequest | 

try {
    final result = api_instance.apiVversionPanelActivacionPost(version, panelActivacionRequest);
    print(result);
} catch (e) {
    print('Exception when calling PanelActivacionApi->apiVversionPanelActivacionPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **panelActivacionRequest** | [**PanelActivacionRequest**](PanelActivacionRequest.md)|  | 

### Return type

[**PanelActivacionResponse**](PanelActivacionResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

