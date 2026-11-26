# knock_api.api.InternalTradeChangedApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionInternoCambiosDeOficioPost**](InternalTradeChangedApi.md#apivversioninternocambiosdeoficiopost) | **POST** /api/v{version}/interno/cambios-de-oficio | 


# **apiVversionInternoCambiosDeOficioPost**
> apiVversionInternoCambiosDeOficioPost(version, tradeChangedEventBody)



### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = InternalTradeChangedApi();
final version = version_example; // String | 
final tradeChangedEventBody = TradeChangedEventBody(); // TradeChangedEventBody | 

try {
    api_instance.apiVversionInternoCambiosDeOficioPost(version, tradeChangedEventBody);
} catch (e) {
    print('Exception when calling InternalTradeChangedApi->apiVversionInternoCambiosDeOficioPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String**|  | 
 **tradeChangedEventBody** | [**TradeChangedEventBody**](TradeChangedEventBody.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

