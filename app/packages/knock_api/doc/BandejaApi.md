# knock_api.api.BandejaApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionTecnicosMeSolicitudesGet**](BandejaApi.md#apivversiontecnicosmesolicitudesget) | **GET** /api/v{version}/tecnicos/me/solicitudes | 


# **apiVversionTecnicosMeSolicitudesGet**
> InboxResponse apiVversionTecnicosMeSolicitudesGet(version, cursor, limit)



### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = BandejaApi();
final version = version_example; // String | 
final cursor = cursor_example; // String | 
final limit = 56; // int | 

try {
    final result = api_instance.apiVversionTecnicosMeSolicitudesGet(version, cursor, limit);
    print(result);
} catch (e) {
    print('Exception when calling BandejaApi->apiVversionTecnicosMeSolicitudesGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **cursor** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] 

### Return type

[**InboxResponse**](InboxResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

