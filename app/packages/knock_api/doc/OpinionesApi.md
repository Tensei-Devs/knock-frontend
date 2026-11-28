# knock_api.api.OpinionesApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionOpinionesIdRespuestaPost**](OpinionesApi.md#apivversionopinionesidrespuestapost) | **POST** /api/v{version}/opiniones/{id}/respuesta | OPI-03: el técnico calificado responde una sola vez a una opinión suya.
[**apiVversionTecnicosIdOpinionesGet**](OpinionesApi.md#apivversiontecnicosidopinionesget) | **GET** /api/v{version}/tecnicos/{id}/opiniones | OPI-01: opiniones publicadas de un técnico visible con su distribución por estrellas, de la más nueva a la más vieja, por cursor.
[**apiVversionVisitasIdOpinionPost**](OpinionesApi.md#apivversionvisitasidopinionpost) | **POST** /api/v{version}/visitas/{id}/opinion | OPI-02: el cliente de una visita terminada la califica una sola vez, hasta 30 días después.


# **apiVversionOpinionesIdRespuestaPost**
> apiVversionOpinionesIdRespuestaPost(id, version, answerReviewBody)

OPI-03: el técnico calificado responde una sola vez a una opinión suya.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = OpinionesApi();
final id = id_example; // String | 
final version = version_example; // String | 
final answerReviewBody = AnswerReviewBody(); // AnswerReviewBody | 

try {
    api_instance.apiVversionOpinionesIdRespuestaPost(id, version, answerReviewBody);
} catch (e) {
    print('Exception when calling OpinionesApi->apiVversionOpinionesIdRespuestaPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 
 **answerReviewBody** | [**AnswerReviewBody**](AnswerReviewBody.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionTecnicosIdOpinionesGet**
> ReviewPage apiVversionTecnicosIdOpinionesGet(id, version, cursor, limite)

OPI-01: opiniones publicadas de un técnico visible con su distribución por estrellas, de la más nueva a la más vieja, por cursor.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = OpinionesApi();
final id = id_example; // String | 
final version = version_example; // String | 
final cursor = cursor_example; // String | 
final limite = 56; // int | 

try {
    final result = api_instance.apiVversionTecnicosIdOpinionesGet(id, version, cursor, limite);
    print(result);
} catch (e) {
    print('Exception when calling OpinionesApi->apiVversionTecnicosIdOpinionesGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 
 **cursor** | **String**|  | [optional] 
 **limite** | **int**|  | [optional] 

### Return type

[**ReviewPage**](ReviewPage.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionVisitasIdOpinionPost**
> CreatedReview apiVversionVisitasIdOpinionPost(id, version, createReviewBody)

OPI-02: el cliente de una visita terminada la califica una sola vez, hasta 30 días después.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = OpinionesApi();
final id = id_example; // String | 
final version = version_example; // String | 
final createReviewBody = CreateReviewBody(); // CreateReviewBody | 

try {
    final result = api_instance.apiVversionVisitasIdOpinionPost(id, version, createReviewBody);
    print(result);
} catch (e) {
    print('Exception when calling OpinionesApi->apiVversionVisitasIdOpinionPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 
 **createReviewBody** | [**CreateReviewBody**](CreateReviewBody.md)|  | 

### Return type

[**CreatedReview**](CreatedReview.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

