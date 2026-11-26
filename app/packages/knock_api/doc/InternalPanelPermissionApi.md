# knock_api.api.InternalPanelPermissionApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionInternoPermisosDelPanelPost**](InternalPanelPermissionApi.md#apivversioninternopermisosdelpanelpost) | **POST** /api/v{version}/interno/permisos-del-panel | 


# **apiVversionInternoPermisosDelPanelPost**
> PanelPermissionCheckResponse apiVversionInternoPermisosDelPanelPost(version, panelPermissionCheckBody)



### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = InternalPanelPermissionApi();
final version = version_example; // String | 
final panelPermissionCheckBody = PanelPermissionCheckBody(); // PanelPermissionCheckBody | 

try {
    final result = api_instance.apiVversionInternoPermisosDelPanelPost(version, panelPermissionCheckBody);
    print(result);
} catch (e) {
    print('Exception when calling InternalPanelPermissionApi->apiVversionInternoPermisosDelPanelPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **panelPermissionCheckBody** | [**PanelPermissionCheckBody**](PanelPermissionCheckBody.md)|  | 

### Return type

[**PanelPermissionCheckResponse**](PanelPermissionCheckResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

