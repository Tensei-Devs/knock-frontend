# knock_api.model.CursorPageOfHistoryItemResponse

## Load the model package
```dart
import 'package:knock_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**items** | [**List<HistoryItemResponse>**](HistoryItemResponse.md) | Elementos de la página, como máximo int PageLimit.Max. | [default to const []]
**nextCursor** | **String** | Cursor opaco para pedir la página siguiente, o `null` si no hay más. | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


