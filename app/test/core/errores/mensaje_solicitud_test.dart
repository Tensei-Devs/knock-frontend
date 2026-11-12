import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/l10n/generado/app_localizations_en.dart';
import 'package:app/l10n/generado/app_localizations_es.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final es = AppLocalizationsEs();
  final en = AppLocalizationsEn();

  test('CA_015_22 el contenido rechazado y la moderación caída tienen su '
      'mensaje exacto', () {
    expect(
      mensajeDeError(
        es,
        const SolicitudRechazadaFailure(
          MotivoSolicitudRechazada.contenidoRechazado,
        ),
      ),
      'Tu descripción no se pudo publicar. Revísala y quita datos personales '
      'o palabras ofensivas.',
    );
    expect(
      mensajeDeError(
        es,
        const SolicitudRechazadaFailure(
          MotivoSolicitudRechazada.moderacionNoDisponible,
        ),
      ),
      'No pudimos revisar tu descripción en este momento. Intenta de nuevo en '
      'unos minutos.',
    );
  });

  test('CA_015_13 un 404 dice que la solicitud ya no está disponible', () {
    expect(
      mensajeDeError(es, const NoEncontradoFailure()),
      'Esta solicitud ya no está disponible.',
    );
    expect(
      mensajeDeError(en, const NoEncontradoFailure()),
      'This request is no longer available.',
    );
  });

  test('CA_015_01 cada motivo de rechazo tiene un mensaje distinto', () {
    final mensajes = {
      for (final m in MotivoSolicitudRechazada.values)
        mensajeDeError(es, SolicitudRechazadaFailure(m)),
    };
    expect(mensajes, hasLength(MotivoSolicitudRechazada.values.length));
    expect(
      mensajeDeError(es, const SolicitudVencidaFailure()),
      'Esta solicitud venció. Puedes pedir una nueva.',
    );
  });
}
