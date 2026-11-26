# knock_api.api.MePreferenciasAvisosApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionMePreferenciasAvisosGet**](MePreferenciasAvisosApi.md#apivversionmepreferenciasavisosget) | **GET** /api/v{version}/me/preferencias-avisos | Un interruptor por tipo; sin cambios guardados, todos activos salvo promociones; seguridad siempre activa y no apagable.
[**apiVversionMePreferenciasAvisosPut**](MePreferenciasAvisosApi.md#apivversionmepreferenciasavisosput) | **PUT** /api/v{version}/me/preferencias-avisos | Cambia los interruptores indicados y devuelve las preferencias vigentes. Los avisos de seguridad no se pueden apagar (422).


# **apiVversionMePreferenciasAvisosGet**
> NoticePreferencesResponse apiVversionMePreferenciasAvisosGet(version)

Un interruptor por tipo; sin cambios guardados, todos activos salvo promociones; seguridad siempre activa y no apagable.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = MePreferenciasAvisosApi();
final version = version_example; // String | 

try {
    final result = api_instance.apiVversionMePreferenciasAvisosGet(version);
    print(result);
} catch (e) {
    print('Exception when calling MePreferenciasAvisosApi->apiVversionMePreferenciasAvisosGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 

### Return type

[**NoticePreferencesResponse**](NoticePreferencesResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiVversionMePreferenciasAvisosPut**
> NoticePreferencesResponse apiVversionMePreferenciasAvisosPut(version, updateNoticePreferencesRequest)

Cambia los interruptores indicados y devuelve las preferencias vigentes. Los avisos de seguridad no se pueden apagar (422).

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = MePreferenciasAvisosApi();
final version = version_example; // String | 
final updateNoticePreferencesRequest = UpdateNoticePreferencesRequest(); // UpdateNoticePreferencesRequest | 

try {
    final result = api_instance.apiVversionMePreferenciasAvisosPut(version, updateNoticePreferencesRequest);
    print(result);
} catch (e) {
    print('Exception when calling MePreferenciasAvisosApi->apiVversionMePreferenciasAvisosPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **updateNoticePreferencesRequest** | [**UpdateNoticePreferencesRequest**](UpdateNoticePreferencesRequest.md)|  | 

### Return type

[**NoticePreferencesResponse**](NoticePreferencesResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

