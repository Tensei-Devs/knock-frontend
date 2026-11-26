# knock_api.api.AdminReviewsApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionAdminOpinionesIdMostrarPost**](AdminReviewsApi.md#apivversionadminopinionesidmostrarpost) | **POST** /api/v{version}/admin/opiniones/{id}/mostrar | Vuelve a mostrar la opinión. Sobre una visible responde 200 sin cambios.
[**apiVversionAdminOpinionesIdOcultarPost**](AdminReviewsApi.md#apivversionadminopinionesidocultarpost) | **POST** /api/v{version}/admin/opiniones/{id}/ocultar | Oculta la opinión con un motivo de 8 a 300 caracteres. Repetirlo responde 200 sin cambios.


# **apiVversionAdminOpinionesIdMostrarPost**
> apiVversionAdminOpinionesIdMostrarPost(id, version)

Vuelve a mostrar la opinión. Sobre una visible responde 200 sin cambios.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = AdminReviewsApi();
final id = id_example; // String | 
final version = version_example; // String | 

try {
    api_instance.apiVversionAdminOpinionesIdMostrarPost(id, version);
} catch (e) {
    print('Exception when calling AdminReviewsApi->apiVversionAdminOpinionesIdMostrarPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionAdminOpinionesIdOcultarPost**
> apiVversionAdminOpinionesIdOcultarPost(id, version, hideReviewBody)

Oculta la opinión con un motivo de 8 a 300 caracteres. Repetirlo responde 200 sin cambios.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = AdminReviewsApi();
final id = id_example; // String | 
final version = version_example; // String | 
final hideReviewBody = HideReviewBody(); // HideReviewBody | 

try {
    api_instance.apiVversionAdminOpinionesIdOcultarPost(id, version, hideReviewBody);
} catch (e) {
    print('Exception when calling AdminReviewsApi->apiVversionAdminOpinionesIdOcultarPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **version** | **String**|  | 
 **hideReviewBody** | [**HideReviewBody**](HideReviewBody.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

