import 'package:app/core/errores/failure.dart';
import 'package:app/features/actividad/data/solicitud_repository_simulado.dart';
import 'package:app/features/actividad/domain/franja.dart';
import 'package:app/features/actividad/domain/solicitud.dart';
import 'package:flutter_test/flutter_test.dart';

SolicitudNueva _nueva({String? direccion}) => SolicitudNueva(
  oficioClave: 'ele',
  descripcion: 'Se botó la luz',
  fotos: const ['archivo-1'],
  dia: DateTime(2026, 11, 12),
  franja: Franja.manana,
  coloniaId: 'col-1',
  direccion: direccion,
);

void main() {
  test('CA_015_01 crear devuelve la solicitud en estado enviada', () async {
    final repo = SolicitudRepositorySimulado();
    final creada = await repo.crear(_nueva());
    expect(creada.estado, EstadoSolicitud.enviada);
    expect(creada.oficioClave, 'ele');
    expect((await repo.obtener(creada.id)).id, creada.id);
  });

  test('CA_015_13 una solicitud que no existe da 404 sin más detalle', () {
    final repo = SolicitudRepositorySimulado();
    expect(repo.obtener('ajena'), throwsA(isA<NoEncontradoFailure>()));
  });

  test('CA_015_01 subir una foto da un archivoId distinto cada vez', () async {
    final repo = SolicitudRepositorySimulado();
    final a = await repo.subirFoto('a.jpg');
    final b = await repo.subirFoto('b.jpg');
    expect(a, isNot(b));
  });
}
