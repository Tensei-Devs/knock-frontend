import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';

/// Radio de las esquinas de los campos y los botones de entrada.
const double radioDeEntrada = 16;

/// Estructura común de las pantallas de entrada (HU-001): marca de Knock,
/// título, detalle y una tarjeta con el formulario. Sin barra inferior.
///
/// Se desplaza si no cabe (texto al 200 % en pantallas de 320 × 640).
class MarcoDeEntrada extends StatelessWidget {
  const MarcoDeEntrada({
    required this.titulo,
    required this.detalle,
    required this.formulario,
    this.pie = const [],
    super.key,
  });

  final String titulo;
  final String detalle;

  /// Contenido de la tarjeta (campos y botón principal).
  final List<Widget> formulario;

  /// Acciones secundarias bajo la tarjeta.
  final List<Widget> pie;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final esquema = tema.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _Marca(),
                  const SizedBox(height: 32),
                  Semantics(
                    header: true,
                    child: Text(
                      titulo,
                      style: tema.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: esquema.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    detalle,
                    style: tema.textTheme.bodyLarge?.copyWith(
                      color: esquema.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Material(
                    color: esquema.surfaceContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(radioDeEntrada + 8),
                      side: BorderSide(color: esquema.outlineVariant),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: formulario,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...pie,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Logo provisional: una puerta en un cuadro naranja y el nombre de la app.
class _Marca extends StatelessWidget {
  const _Marca();

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final esquema = tema.colorScheme;
    return Row(
      children: [
        ExcludeSemantics(
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: esquema.primary,
              borderRadius: BorderRadius.circular(radioDeEntrada - 2),
            ),
            child: Icon(
              Icons.door_front_door_rounded,
              color: esquema.onPrimary,
              size: 28,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            AppLocalizations.of(context).appTitle,
            style: tema.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: esquema.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

/// Decoración de los campos de entrada: contorno redondeado y mensajes que
/// pueden ocupar varias líneas (texto al 200 %).
InputDecoration decoracionDeEntrada({
  required String etiqueta,
  String? ayuda,
  String? error,
  Widget? prefijo,
}) {
  final borde = OutlineInputBorder(
    borderRadius: BorderRadius.circular(radioDeEntrada),
  );
  return InputDecoration(
    labelText: etiqueta,
    helperText: ayuda,
    helperMaxLines: 3,
    errorText: error,
    errorMaxLines: 3,
    prefixIcon: prefijo,
    border: borde,
    enabledBorder: borde,
  );
}

/// Estilo del botón principal: ancho completo y 56 dp de alto.
ButtonStyle estiloBotonPrincipal(BuildContext context) =>
    FilledButton.styleFrom(
      minimumSize: const Size.fromHeight(56),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radioDeEntrada),
      ),
      textStyle: Theme.of(context).textTheme.titleMedium
          ?.copyWith(fontWeight: FontWeight.w700),
    );

/// Botón principal que, mientras [cargando], se desactiva y muestra un
/// indicador con etiqueta accesible (KNOCK-228).
class BotonPrincipalDeEntrada extends StatelessWidget {
  const BotonPrincipalDeEntrada({
    required this.texto,
    required this.etiquetaCargando,
    required this.cargando,
    required this.onPressed,
    super.key,
  });

  final String texto;
  final String etiquetaCargando;
  final bool cargando;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => FilledButton(
    onPressed: cargando ? null : onPressed,
    style: estiloBotonPrincipal(context),
    child: cargando
        ? Semantics(
            label: etiquetaCargando,
            child: const SizedBox.square(
              dimension: 24,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
          )
        : Text(texto),
  );
}

/// Mensaje de error de la entrada, anunciado por el lector de pantalla.
class MensajeDeErrorDeEntrada extends StatelessWidget {
  const MensajeDeErrorDeEntrada(this.mensaje, {super.key});

  final String mensaje;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Semantics(
      liveRegion: true,
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Text(
          mensaje,
          textAlign: TextAlign.center,
          style: tema.textTheme.bodyLarge?.copyWith(
            color: tema.colorScheme.error,
          ),
        ),
      ),
    );
  }
}
