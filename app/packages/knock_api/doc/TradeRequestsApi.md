# knock_api.api.TradeRequestsApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionOficiosPedidosPost**](TradeRequestsApi.md#apivversionoficiospedidospost) | **POST** /api/v{version}/oficios-pedidos | Guarda el oficio escrito en «Otro oficio» (OFP-01): 201 con el registro. Repetir el mismo texto (ignorando acentos, mayúsculas y espacios) devuelve el registro existente. Quien no tiene perfil de técnico recibe 404 sin más datos; un cuerpo ilegible, 400; un texto inválido, 422 `errors.texto`.


# **apiVversionOficiosPedidosPost**
> TradeRequestResponse apiVversionOficiosPedidosPost(version, tradeRequestBody)

Guarda el oficio escrito en «Otro oficio» (OFP-01): 201 con el registro. Repetir el mismo texto (ignorando acentos, mayúsculas y espacios) devuelve el registro existente. Quien no tiene perfil de técnico recibe 404 sin más datos; un cuerpo ilegible, 400; un texto inválido, 422 `errors.texto`.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = TradeRequestsApi();
final version = version_example; // String | 
final tradeRequestBody = TradeRequestBody(); // TradeRequestBody | 

try {
    final result = api_instance.apiVversionOficiosPedidosPost(version, tradeRequestBody);
    print(result);
} catch (e) {
    print('Exception when calling TradeRequestsApi->apiVversionOficiosPedidosPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **tradeRequestBody** | [**TradeRequestBody**](TradeRequestBody.md)|  | 

### Return type

[**TradeRequestResponse**](TradeRequestResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

