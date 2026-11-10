// Spec 002 (KNOCK-216), CA-02: todo error de la API llega como mensaje en
// español (y en inglés con el idioma inglés), sin detalles técnicos.
import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/l10n/generado/app_localizations_en.dart';
import 'package:app/l10n/generado/app_localizations_es.dart';
import 'package:flutter_test/flutter_test.dart';

const _fallos = <Failure>[
  DatosInvalidosFailure(),
  ServicioNoDisponibleFailure(),
  ApiNoConfiguradaFailure(),
  NoAutorizadoFailure(),
  CuentaSuspendidaFailure(),
  AccesoDenegadoFailure(),
  ConflictoFailure(),
  DatosRechazadosFailure(),
  DemasiadosIntentosFailure(),
];

void main() {
  final es = AppLocalizationsEs();
  final en = AppLocalizationsEn();

  test(
    'CA-002-02 cada Failure tiene mensaje en español, distinto y legible',
    () {
      final mensajes = [for (final f in _fallos) mensajeDeError(es, f)];
      expect(mensajes.toSet(), hasLength(_fallos.length));
      for (final m in mensajes) {
        expect(m, isNotEmpty);
        expect(m, isNot(contains('Failure')));
        expect(m, isNot(contains('Exception')));
        expect(m, isNot(contains('http')));
        expect(m, isNot(contains(RegExp(r'\b\d{3}\b'))));
      }
    },
  );

  test('CA-002-02 el mismo error en inglés sale en inglés', () {
    for (final f in _fallos) {
      expect(mensajeDeError(en, f), isNot(mensajeDeError(es, f)));
    }
  });

  test('CA-002-02 un error inesperado no muestra detalles técnicos', () {
    final m = mensajeDeError(
      es,
      StateError('SELECT * FROM cuentas; token=abc123'),
    );
    expect(m, es.errorInesperado);
    expect(m, isNot(contains('abc123')));
  });
}
