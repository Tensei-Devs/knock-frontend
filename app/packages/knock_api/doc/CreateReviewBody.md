# knock_api.model.CreateReviewBody

## Load the model package
```dart
import 'package:knock_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**calificacion** | **int** | Entero de 1 a 5. | 
**partes** | [**ReviewParts**](ReviewParts.md) | Cada parte de 1 a 5. | 
**comentario** | **String** | Hasta 500 caracteres. | 
**fotos** | **List<String>** | De 0 a 3 identificadores de archivo (`archivoId`, 32 hexadecimales), sin repetidos, moderadas; más de 3 responde 422 `errors.fotos`. | [default to const []]
**guardarTecnicoConfianza** | **bool** | Opcional: suma al técnico a los de confianza. | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


