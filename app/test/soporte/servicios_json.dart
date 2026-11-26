// Servicios ficticios de la spec 037.
Map<String, Object?> servicioJson(
  String id, {
  String? nombre,
  Object precio = 250,
}) => {
  'id': id,
  'nombre': nombre ?? 'Servicio $id',
  'detalle': null,
  'precioReferencia': precio,
  'oficio': 'plo',
};
