# knock_api.api.InternalNotFinishedReportApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionInternoVisitasVisitaIdReporteNoTerminadoGet**](InternalNotFinishedReportApi.md#apivversioninternovisitasvisitaidreportenoterminadoget) | **GET** /api/v{version}/interno/visitas/{visitaId}/reporte-no-terminado | 


# **apiVversionInternoVisitasVisitaIdReporteNoTerminadoGet**
> NotFinishedReportResponse apiVversionInternoVisitasVisitaIdReporteNoTerminadoGet(visitaId, version)



### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = InternalNotFinishedReportApi();
final visitaId = visitaId_example; // String | 
final version = version_example; // String | 

try {
    final result = api_instance.apiVversionInternoVisitasVisitaIdReporteNoTerminadoGet(visitaId, version);
    print(result);
} catch (e) {
    print('Exception when calling InternalNotFinishedReportApi->apiVversionInternoVisitasVisitaIdReporteNoTerminadoGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **visitaId** | **String**|  | 
 **version** | **String**|  | 

### Return type

[**NotFinishedReportResponse**](NotFinishedReportResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

