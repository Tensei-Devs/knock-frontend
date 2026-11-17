# knock_api.api.ColoniasApi

## Load the API package
```dart
import 'package:knock_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiVversionColoniasEnPuntoGet**](ColoniasApi.md#apivversioncoloniasenpuntoget) | **GET** /api/v{version}/colonias/en-punto | Colonia del punto o «fuera de cobertura» (200 en ambos casos). Las coordenadas se convierten en colonia y se descartan: no se guardan, no se registran, no se cachean y no vuelven en la respuesta. El 422 lo da `ValidationFilter` antes de esta acción.


# **apiVversionColoniasEnPuntoGet**
> NeighborhoodAtPointResponse apiVversionColoniasEnPuntoGet(lat, lon, version)

Colonia del punto o «fuera de cobertura» (200 en ambos casos). Las coordenadas se convierten en colonia y se descartan: no se guardan, no se registran, no se cachean y no vuelven en la respuesta. El 422 lo da `ValidationFilter` antes de esta acción.

### Example
```dart
import 'package:knock_api/api.dart';

final api_instance = ColoniasApi();
final lat = lat_example; // String | Latitude in decimal degrees, from -90 to 90, dot as decimal separator, up to 10 decimals. Exactly one value.
final lon = lon_example; // String | Longitude in decimal degrees, from -180 to 180, dot as decimal separator, up to 10 decimals. Exactly one value.
final version = version_example; // String | 

try {
    final result = api_instance.apiVversionColoniasEnPuntoGet(lat, lon, version);
    print(result);
} catch (e) {
    print('Exception when calling ColoniasApi->apiVversionColoniasEnPuntoGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lat** | **String**| Latitude in decimal degrees, from -90 to 90, dot as decimal separator, up to 10 decimals. Exactly one value. | 
 **lon** | **String**| Longitude in decimal degrees, from -180 to 180, dot as decimal separator, up to 10 decimals. Exactly one value. | 
 **version** | **String**|  | 

### Return type

[**NeighborhoodAtPointResponse**](NeighborhoodAtPointResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

