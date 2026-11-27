import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// La [fecha] como la escribe la app en el idioma de la pantalla [en].
String fechaEsperada(WidgetTester tester, Type en, DateTime fecha) =>
    MaterialLocalizations.of(tester.element(find.byType(en)))
        .formatMediumDate(fecha);
