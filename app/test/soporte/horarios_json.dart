// Semana ficticia de la spec 036: lunes abierto y el resto cerrado.
Map<String, Object?> semanaJson() => {
  'horarios': [
    for (final dia in const [
      'lunes',
      'martes',
      'miercoles',
      'jueves',
      'viernes',
      'sabado',
      'domingo',
    ])
      {
        'dia': dia,
        'abierto': dia == 'lunes',
        'franjas': [
          if (dia == 'lunes') {'inicio': '10:00', 'fin': '18:00'},
        ],
      },
  ],
};
