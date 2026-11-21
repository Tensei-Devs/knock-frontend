# knock_api.model.RegisterTechnicianBody

## Load the model package
```dart
import 'package:knock_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**nombre** | **String** | Nombre y apellido que ven los clientes: de 2 a 80 letras, espacios, punto, apóstrofo o guion. | 
**oficios** | **List<String>** | Una o más claves de oficios activos del catálogo, sin repetir y sin máximo propio (D-07). | [default to const []]
**otroOficio** | **String** | Texto libre opcional («Otro oficio»), de hasta 60 caracteres; no recibe solicitudes. | 
**atencion** | **String** | Una de `taller`, `domicilio` o `ambos`. | 
**direccionTaller** | **String** | De 8 a 200 caracteres; obligatoria con taller o ambos y no admitida a domicilio. Se guarda cifrada. | 
**radioKm** | **int** | 3, 5, 8 o 12; obligatorio a domicilio o ambos y no admitido solo en taller. | 
**coloniaId** | **String** | Colonia base del técnico (24 hexadecimales); de ella sale la ubicación aproximada. | 
**perfil** | [**TechnicianProfileBody**](TechnicianProfileBody.md) | Datos opcionales del perfil público. | 
**aceptaTerminos** | **bool** | Debe ser `true`. | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


