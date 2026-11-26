# knock_api.api.AdminReportesApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionAdminReportesGet**](AdminReportesApi.md#apivversionadminreportesget) | **GET** /api/v{version}/admin/reportes | REP-04: la cola por gravedad (crítica primero) y antigüedad, con cursor. Muestra motivo y texto, nunca teléfono ni dirección.
[**apiVversionAdminReportesIdDecisionPost**](AdminReportesApi.md#apivversionadminreportesiddecisionpost) | **POST** /api/v{version}/admin/reportes/{id}/decision | REP-05: asigna la gravedad con motivo; la respuesta se deriva de ella. 404 `report_not_found`; 409 `report_already_decided`; 503 `audit_unavailable`.


# **apiVversionAdminReportesGet**
> ReportQueuePage apiVversionAdminReportesGet(version, gravedad, estado, desde, hasta, cursor, limite)

REP-04: la cola por gravedad (crítica primero) y antigüedad, con cursor. Muestra motivo y texto, nunca teléfono ni dirección.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = AdminReportesApi();
final version = version_example; // String | 
final gravedad = gravedad_example; // String | 
final estado = estado_example; // String | abierto and en_apelacion by default.
final desde = 2013-10-20T19:20:30+01:00; // DateTime | 
final hasta = 2013-10-20T19:20:30+01:00; // DateTime | 
final cursor = cursor_example; // String | Opaque cursor returned as nextCursor by the previous page.
final limite = 56; // int | Page size, 1 to 50. Defaults to 20.

try {
    final result = api_instance.apiVversionAdminReportesGet(version, gravedad, estado, desde, hasta, cursor, limite);
    print(result);
} catch (e) {
    print('Exception when calling AdminReportesApi->apiVversionAdminReportesGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **gravedad** | **String**|  | [optional] 
 **estado** | **String**| abierto and en_apelacion by default. | [optional] 
 **desde** | **DateTime**|  | [optional] 
 **hasta** | **DateTime**|  | [optional] 
 **cursor** | **String**| Opaque cursor returned as nextCursor by the previous page. | [optional] 
 **limite** | **int**| Page size, 1 to 50. Defaults to 20. | [optional] 

### Return type

[**ReportQueuePage**](ReportQueuePage.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionAdminReportesIdDecisionPost**
> ReportDecisionResult apiVversionAdminReportesIdDecisionPost(id, version, reportDecisionBody)

REP-05: asigna la gravedad con motivo; la respuesta se deriva de ella. 404 `report_not_found`; 409 `report_already_decided`; 503 `audit_unavailable`.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = AdminReportesApi();
final id = id_example; // String | 
final version = version_example; // String | 
final reportDecisionBody = ReportDecisionBody(); // ReportDecisionBody | 

try {
    final result = api_instance.apiVversionAdminReportesIdDecisionPost(id, version, reportDecisionBody);
    print(result);
} catch (e) {
    print('Exception when calling AdminReportesApi->apiVversionAdminReportesIdDecisionPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 
 **reportDecisionBody** | [**ReportDecisionBody**](ReportDecisionBody.md)|  | 

### Return type

[**ReportDecisionResult**](ReportDecisionResult.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

