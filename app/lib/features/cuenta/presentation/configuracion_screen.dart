import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/core/preferencias/preferencias_provider.dart';
import 'package:app/core/widgets/pantalla_titulada.dart';
import 'package:app/features/cuenta/presentation/widgets/seccion_avisos.dart';
import 'package:app/l10n/generado/app_localizations.dart';

/// Mi cuenta → Configuración: idioma y tema (HU-052).
///
/// El cambio se aplica al momento y se guarda en el dispositivo; no hay
/// botón Guardar. Siempre tiene datos (los valores actuales del proveedor):
/// no hay carga, vacío ni error (spec §7).
class ConfiguracionScreen extends ConsumerWidget {
  const ConfiguracionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = AppLocalizations.of(context);
    final preferencias = ref.watch(preferenciasProvider);
    final notifier = ref.read(preferenciasProvider.notifier);

    return PantallaTitulada(
      titulo: textos.configuracionTitulo,
      // Columna dentro de un desplazable (no ListView perezoso): con la sección
      // de avisos la lista ya no cabe y todo debe estar construido.
      cuerpo: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Encabezado(textos.configuracionIdioma),
            RadioGroup<Locale>(
              groupValue: preferencias.idioma,
              onChanged: (idioma) {
                if (idioma != null) notifier.cambiarIdioma(idioma);
              },
              child: Column(
                children: [
                  _Opcion(
                    const Locale('es'),
                    textos.configuracionIdiomaEspanol,
                  ),
                  _Opcion(const Locale('en'), textos.configuracionIdiomaIngles),
                ],
              ),
            ),
            _Encabezado(textos.configuracionTema),
            RadioGroup<ThemeMode>(
              groupValue: preferencias.modoTema,
              onChanged: (modo) {
                if (modo != null) notifier.cambiarTema(modo);
              },
              child: Column(
                children: [
                  _Opcion(
                    ThemeMode.system,
                    textos.configuracionTemaAutomatico,
                    detalle: textos.configuracionTemaAutomaticoDetalle,
                  ),
                  _Opcion(ThemeMode.light, textos.configuracionTemaClaro),
                  _Opcion(ThemeMode.dark, textos.configuracionTemaOscuro),
                ],
              ),
            ),
            const SeccionAvisos(),
          ],
        ),
      ),
    );
  }
}

/// Movido desde el menú de prueba de TT-MOB-02 (spec §8 decisión 2).
class _Encabezado extends StatelessWidget {
  const _Encabezado(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
    child: Semantics(
      header: true,
      child: Text(texto, style: Theme.of(context).textTheme.titleSmall),
    ),
  );
}

class _Opcion<T> extends StatelessWidget {
  const _Opcion(this.valor, this.texto, {this.detalle});

  final T valor;
  final String texto;
  final String? detalle;

  @override
  Widget build(BuildContext context) => RadioListTile<T>(
    value: valor,
    title: Text(texto),
    subtitle: detalle == null ? null : Text(detalle!),
  );
}
