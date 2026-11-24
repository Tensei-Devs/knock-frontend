# knock_api.model.FinishVisitBody

## Load the model package
```dart
import 'package:knock_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**descripcion** | **String** | De 8 a 500 caracteres. | 
**recomendacion** | **String** | Opcional, hasta 300 caracteres. | 
**fotos** | **List<String>** | De 1 a 5 identificadores de archivo (`archivoId`, 32 hexadecimales), sin repetidos; sin foto o con más de 5 responde 422 `errors.fotos`. | [default to const []]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


