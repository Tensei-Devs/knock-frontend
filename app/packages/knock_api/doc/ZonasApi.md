# knock_api.api.ZonasApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionZonasCpCpGet**](ZonasApi.md#apivversionzonascpcpget) | **GET** /api/v{version}/zonas/cp/{cp} | 


# **apiVversionZonasCpCpGet**
> ZonaResponse apiVversionZonasCpCpGet(cp, version, ifNoneMatch)



### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = ZonasApi();
final cp = cp_example; // String | 
final version = version_example; // String | 
final ifNoneMatch = ifNoneMatch_example; // String | 

try {
    final result = api_instance.apiVversionZonasCpCpGet(cp, version, ifNoneMatch);
    print(result);
} catch (e) {
    print('Exception when calling ZonasApi->apiVversionZonasCpCpGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cp** | **String**|  | 
 **version** | **String**|  | 
 **ifNoneMatch** | **String**|  | [optional] 

### Return type

[**ZonaResponse**](ZonaResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

