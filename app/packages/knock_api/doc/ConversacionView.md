# knock_api.model.ConversacionView

## Load the model package
```dart
import 'package:knock_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**conversacionId** | **String** |  | 
**solicitudId** | **String** |  | 
**visitaId** | **String** |  | [optional] 
**rol** | **String** |  | 
**contraparte** | [**Contraparte**](Contraparte.md) |  | 
**servicio** | **String** |  | 
**estado** | **String** | Estado de la conversación: abierta o cerrada. | 
**motivoCierre** | **String** | Solo con estado cerrada: request_cancelled, request_expired, other_quote_chosen, dismissed o service_finished. | [optional] 
**contactoVisible** | **bool** |  | 
**avisoSeguridad** | **String** | Texto fijo de seguridad que la app muestra tal cual (cadena no vacía, nunca null). | 
**noLeidos** | **int** |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


