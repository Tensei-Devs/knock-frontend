# knock_api.api.ReportesApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionReportesIdApelacionPost**](ReportesApi.md#apivversionreportesidapelacionpost) | **POST** /api/v{version}/reportes/{id}/apelacion | Apela la decisión de un reporte, una sola vez. 200; 403 si no es una de las dos partes; 409 `appeal_not_allowed` sin decisión o con una apelación previa.
[**apiVversionReportesMeGet**](ReportesApi.md#apivversionreportesmeget) | **GET** /api/v{version}/reportes/me | Los reportes que hizo quien llama, del más reciente al más antiguo, con paginación por cursor. Nunca lleva datos de la otra parte.
[**apiVversionReportesPost**](ReportesApi.md#apivversionreportespost) | **POST** /api/v{version}/reportes | Crea un reporte (`abierto`). 201 la primera vez y 200 si ya había uno abierto igual; 422 con `errors.&lt;campo&gt;` si un valor no es válido, si es contra uno mismo o contra alguien que no existe, o `report_content_rejected`; 503 `report_moderation_unavailable` si la moderación no responde. Con motivo de peligro la respuesta lleva el aviso de llamar al 911.


# **apiVversionReportesIdApelacionPost**
> AppealResult apiVversionReportesIdApelacionPost(id, version, appealBody)

Apela la decisión de un reporte, una sola vez. 200; 403 si no es una de las dos partes; 409 `appeal_not_allowed` sin decisión o con una apelación previa.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = ReportesApi();
final id = id_example; // String | 
final version = version_example; // String | 
final appealBody = AppealBody(); // AppealBody | 

try {
    final result = api_instance.apiVversionReportesIdApelacionPost(id, version, appealBody);
    print(result);
} catch (e) {
    print('Exception when calling ReportesApi->apiVversionReportesIdApelacionPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 
 **appealBody** | [**AppealBody**](AppealBody.md)|  | 

### Return type

[**AppealResult**](AppealResult.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionReportesMeGet**
> ReportPage apiVversionReportesMeGet(version, cursor, limite)

Los reportes que hizo quien llama, del más reciente al más antiguo, con paginación por cursor. Nunca lleva datos de la otra parte.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = ReportesApi();
final version = version_example; // String | 
final cursor = cursor_example; // String | Opaque cursor returned as nextCursor by the previous page.
final limite = 56; // int | Page size, 1 to 50. Defaults to 20.

try {
    final result = api_instance.apiVversionReportesMeGet(version, cursor, limite);
    print(result);
} catch (e) {
    print('Exception when calling ReportesApi->apiVversionReportesMeGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **cursor** | **String**| Opaque cursor returned as nextCursor by the previous page. | [optional] 
 **limite** | **int**| Page size, 1 to 50. Defaults to 20. | [optional] 

### Return type

[**ReportPage**](ReportPage.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionReportesPost**
> ReportCreated apiVversionReportesPost(version, createReportBody)

Crea un reporte (`abierto`). 201 la primera vez y 200 si ya había uno abierto igual; 422 con `errors.&lt;campo&gt;` si un valor no es válido, si es contra uno mismo o contra alguien que no existe, o `report_content_rejected`; 503 `report_moderation_unavailable` si la moderación no responde. Con motivo de peligro la respuesta lleva el aviso de llamar al 911.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = ReportesApi();
final version = version_example; // String | 
final createReportBody = CreateReportBody(); // CreateReportBody | 

try {
    final result = api_instance.apiVversionReportesPost(version, createReportBody);
    print(result);
} catch (e) {
    print('Exception when calling ReportesApi->apiVversionReportesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **createReportBody** | [**CreateReportBody**](CreateReportBody.md)|  | 

### Return type

[**ReportCreated**](ReportCreated.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

