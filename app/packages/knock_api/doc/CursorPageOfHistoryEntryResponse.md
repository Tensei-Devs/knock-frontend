# knock_api.model.CursorPageOfHistoryEntryResponse

## Load the model package
```dart
import 'package:knock_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**items** | [**List<HistoryEntryResponse>**](HistoryEntryResponse.md) | Elementos de la página, como máximo int PageLimit.Max. | [default to const []]
**nextCursor** | **String** | Cursor opaco para pedir la página siguiente, o `null` si no hay más. | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


