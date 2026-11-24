# knock_api.api.FinalQuoteApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionAjustesIdDecisionPost**](FinalQuoteApi.md#apivversionajustesiddecisionpost) | **POST** /api/v{version}/ajustes/{id}/decision | AJU-02: el cliente dueño aprueba o rechaza el ajuste; el precio cambia solo si aprueba.
[**apiVversionCotizacionesIdAjustePrecioPost**](FinalQuoteApi.md#apivversioncotizacionesidajustepreciopost) | **POST** /api/v{version}/cotizaciones/{id}/ajuste-precio | AJU-01: el técnico de una cotización aceptada propone un monto mayor al tope, con motivo (un solo ajuste pendiente por cotización).
[**apiVversionVisitasIdAjustesPendientesGet**](FinalQuoteApi.md#apivversionvisitasidajustespendientesget) | **GET** /api/v{version}/visitas/{id}/ajustes-pendientes | Lectura de los ajustes pendientes y vigentes de la visita (spec 063); sin ajustes responde 200 con la lista vacía.
[**apiVversionVisitasIdCotizacionFinalDecisionPost**](FinalQuoteApi.md#apivversionvisitasidcotizacionfinaldecisionpost) | **POST** /api/v{version}/visitas/{id}/cotizacion-final/decision | COT-07: el cliente dueño aprueba o rechaza la cotización final. La decisión es definitiva.
[**apiVversionVisitasIdCotizacionFinalGet**](FinalQuoteApi.md#apivversionvisitasidcotizacionfinalget) | **GET** /api/v{version}/visitas/{id}/cotizacion-final | Lectura de la cotización final (spec 063): el cliente dueño y el técnico de la visita; cualquier otra persona recibe el mismo 404.
[**apiVversionVisitasIdCotizacionFinalPost**](FinalQuoteApi.md#apivversionvisitasidcotizacionfinalpost) | **POST** /api/v{version}/visitas/{id}/cotizacion-final | COT-06: el técnico de la visita envía la cotización final (una sola por visita, con la visita en curso).


# **apiVversionAjustesIdDecisionPost**
> AdjustmentDecisionResponse apiVversionAjustesIdDecisionPost(id, version, decisionBody)

AJU-02: el cliente dueño aprueba o rechaza el ajuste; el precio cambia solo si aprueba.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = FinalQuoteApi();
final id = id_example; // String | 
final version = version_example; // String | 
final decisionBody = DecisionBody(); // DecisionBody | 

try {
    final result = api_instance.apiVversionAjustesIdDecisionPost(id, version, decisionBody);
    print(result);
} catch (e) {
    print('Exception when calling FinalQuoteApi->apiVversionAjustesIdDecisionPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 
 **decisionBody** | [**DecisionBody**](DecisionBody.md)|  | 

### Return type

[**AdjustmentDecisionResponse**](AdjustmentDecisionResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionCotizacionesIdAjustePrecioPost**
> AdjustmentResponse apiVversionCotizacionesIdAjustePrecioPost(id, version, adjustmentBody)

AJU-01: el técnico de una cotización aceptada propone un monto mayor al tope, con motivo (un solo ajuste pendiente por cotización).

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = FinalQuoteApi();
final id = id_example; // String | 
final version = version_example; // String | 
final adjustmentBody = AdjustmentBody(); // AdjustmentBody | 

try {
    final result = api_instance.apiVversionCotizacionesIdAjustePrecioPost(id, version, adjustmentBody);
    print(result);
} catch (e) {
    print('Exception when calling FinalQuoteApi->apiVversionCotizacionesIdAjustePrecioPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 
 **adjustmentBody** | [**AdjustmentBody**](AdjustmentBody.md)|  | 

### Return type

[**AdjustmentResponse**](AdjustmentResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionVisitasIdAjustesPendientesGet**
> PendingAdjustmentsResponse apiVversionVisitasIdAjustesPendientesGet(id, version)

Lectura de los ajustes pendientes y vigentes de la visita (spec 063); sin ajustes responde 200 con la lista vacía.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = FinalQuoteApi();
final id = id_example; // String | 
final version = version_example; // String | 

try {
    final result = api_instance.apiVversionVisitasIdAjustesPendientesGet(id, version);
    print(result);
} catch (e) {
    print('Exception when calling FinalQuoteApi->apiVversionVisitasIdAjustesPendientesGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 

### Return type

[**PendingAdjustmentsResponse**](PendingAdjustmentsResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionVisitasIdCotizacionFinalDecisionPost**
> FinalQuoteDecisionResponse apiVversionVisitasIdCotizacionFinalDecisionPost(id, version, decisionBody)

COT-07: el cliente dueño aprueba o rechaza la cotización final. La decisión es definitiva.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = FinalQuoteApi();
final id = id_example; // String | 
final version = version_example; // String | 
final decisionBody = DecisionBody(); // DecisionBody | 

try {
    final result = api_instance.apiVversionVisitasIdCotizacionFinalDecisionPost(id, version, decisionBody);
    print(result);
} catch (e) {
    print('Exception when calling FinalQuoteApi->apiVversionVisitasIdCotizacionFinalDecisionPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 
 **decisionBody** | [**DecisionBody**](DecisionBody.md)|  | 

### Return type

[**FinalQuoteDecisionResponse**](FinalQuoteDecisionResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionVisitasIdCotizacionFinalGet**
> FinalQuoteReadResponse apiVversionVisitasIdCotizacionFinalGet(id, version)

Lectura de la cotización final (spec 063): el cliente dueño y el técnico de la visita; cualquier otra persona recibe el mismo 404.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = FinalQuoteApi();
final id = id_example; // String | 
final version = version_example; // String | 

try {
    final result = api_instance.apiVversionVisitasIdCotizacionFinalGet(id, version);
    print(result);
} catch (e) {
    print('Exception when calling FinalQuoteApi->apiVversionVisitasIdCotizacionFinalGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 

### Return type

[**FinalQuoteReadResponse**](FinalQuoteReadResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionVisitasIdCotizacionFinalPost**
> FinalQuoteResponse apiVversionVisitasIdCotizacionFinalPost(id, version, finalQuoteBody)

COT-06: el técnico de la visita envía la cotización final (una sola por visita, con la visita en curso).

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = FinalQuoteApi();
final id = id_example; // String | 
final version = version_example; // String | 
final finalQuoteBody = FinalQuoteBody(); // FinalQuoteBody | 

try {
    final result = api_instance.apiVversionVisitasIdCotizacionFinalPost(id, version, finalQuoteBody);
    print(result);
} catch (e) {
    print('Exception when calling FinalQuoteApi->apiVversionVisitasIdCotizacionFinalPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 
 **finalQuoteBody** | [**FinalQuoteBody**](FinalQuoteBody.md)|  | 

### Return type

[**FinalQuoteResponse**](FinalQuoteResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

