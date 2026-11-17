# knock_api.api.ArrivalApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionVisitasIdLlegadaPost**](ArrivalApi.md#apivversionvisitasidllegadapost) | **POST** /api/v{version}/visitas/{id}/llegada | El técnico elegido confirma que llegó. Código incorrecto: 422 `wrong_code` con `intentosRestantes`; al tercero la visita queda bloqueada. Estados no válidos responden 409 con `outside_window`, `code_used`, `code_expired`, `visit_locked`, `visit_cancelled`, `visit_not_active` o `visit_without_code`.


# **apiVversionVisitasIdLlegadaPost**
> VisitResponse apiVversionVisitasIdLlegadaPost(id, version, arrivalBody)

El técnico elegido confirma que llegó. Código incorrecto: 422 `wrong_code` con `intentosRestantes`; al tercero la visita queda bloqueada. Estados no válidos responden 409 con `outside_window`, `code_used`, `code_expired`, `visit_locked`, `visit_cancelled`, `visit_not_active` o `visit_without_code`.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = ArrivalApi();
final id = id_example; // String | 
final version = version_example; // String | 
final arrivalBody = ArrivalBody(); // ArrivalBody | 

try {
    final result = api_instance.apiVversionVisitasIdLlegadaPost(id, version, arrivalBody);
    print(result);
} catch (e) {
    print('Exception when calling ArrivalApi->apiVversionVisitasIdLlegadaPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 
 **arrivalBody** | [**ArrivalBody**](ArrivalBody.md)|  | 

### Return type

[**VisitResponse**](VisitResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

