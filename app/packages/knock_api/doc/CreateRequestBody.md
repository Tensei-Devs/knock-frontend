# knock_api.model.CreateRequestBody

## Load the model package
```dart
import 'package:knock_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**oficioClave** | **String** | Clave de un oficio activo del catálogo. La modalidad (domicilio o taller) la dicta el oficio. | 
**descripcion** | **String** | De 8 a 500 caracteres; pasa por moderación antes de guardarse. | 
**fotos** | **List<String>** | De 1 a 5 identificadores de archivo (24 hexadecimales), sin repetidos, de archivos ya confirmados del mismo usuario. | [default to const []]
**dia** | **String** | Fecha `YYYY-MM-DD` en la zona America/Mexico_City, de hoy a hoy + 5 días. | 
**franja** | **String** | Una de `manana`, `tarde` o `noche`. | 
**coloniaId** | **String** | Identificador (24 hexadecimales) de una colonia del catálogo. | 
**direccion** | **String** | De 8 a 200 caracteres; obligatoria en modalidad domicilio y no admitida en taller. Se guarda cifrada. | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


