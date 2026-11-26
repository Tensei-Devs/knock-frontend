import 'package:app/features/actividad/actividad.dart'
    show solicitudesRealesActivasProvider;
import 'package:app/features/maqueta/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Una pantalla de la maqueta: con sesión y API muestra [real] bajo [titulo];
/// sin ellas, la pantalla de [ejemplo] (spec 045, enmienda 1).
class PantallaSegunSesion extends ConsumerWidget {
  const PantallaSegunSesion({
    super.key,
    required this.titulo,
    required this.real,
    required this.ejemplo,
  });

  final String titulo;
  final Widget real;
  final Widget Function(BuildContext) ejemplo;

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(solicitudesRealesActivasProvider)
      ? Pg(title: titulo, body: real)
      : ejemplo(context);
}
