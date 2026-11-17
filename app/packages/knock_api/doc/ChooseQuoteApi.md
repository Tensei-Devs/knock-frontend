# knock_api.api.ChooseQuoteApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionSolicitudesIdElegirPost**](ChooseQuoteApi.md#apivversionsolicitudesidelegirpost) | **POST** /api/v{version}/solicitudes/{id}/elegir | Elige la cotización de una solicitud propia; la elección y sus efectos ocurren en una sola transacción.


# **apiVversionSolicitudesIdElegirPost**
> Appointment apiVversionSolicitudesIdElegirPost(id, version, chooseQuoteBody)

Elige la cotización de una solicitud propia; la elección y sus efectos ocurren en una sola transacción.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = ChooseQuoteApi();
final id = id_example; // String | 
final version = version_example; // String | 
final chooseQuoteBody = ChooseQuoteBody(); // ChooseQuoteBody | 

try {
    final result = api_instance.apiVversionSolicitudesIdElegirPost(id, version, chooseQuoteBody);
    print(result);
} catch (e) {
    print('Exception when calling ChooseQuoteApi->apiVversionSolicitudesIdElegirPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 
 **chooseQuoteBody** | [**ChooseQuoteBody**](ChooseQuoteBody.md)|  | 

### Return type

[**Appointment**](Appointment.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

