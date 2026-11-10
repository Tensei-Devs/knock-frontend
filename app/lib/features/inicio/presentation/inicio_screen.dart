import 'package:app/core/errores/mensajes_failure.dart';
import 'package:app/core/router/rutas.dart';
import 'package:app/core/tema/tokens.dart';
import 'package:app/core/widgets/fila_knock.dart';
import 'package:app/core/widgets/pantalla_titulada.dart';
import 'package:app/core/widgets/tarjeta_knock.dart';
import 'package:app/features/cuenta/presentation/perfil_controller.dart';
import 'package:app/features/inicio/presentation/colonia_controller.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Pestaña Inicio: saludo, la colonia de la persona (`GET /colonias/en-punto`,
/// real con `KNOCK_API_URL`, simulada sin ella) y acceso a Explorar.
class InicioScreen extends ConsumerWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = AppLocalizations.of(context);
    final nombre = ref.watch(perfilControllerProvider).value?.nombre ?? '';
    return PantallaTitulada(
      titulo: AppLocalizations.of(context).tabInicio,
      cuerpo: ListView(
        padding: const EdgeInsets.all(Espaciado.cuerpo),
        children: [
          Text(
            textos.inicioSaludo,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          if (nombre.isNotEmpty)
            Text(nombre, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: Espaciado.bloque),
          const _TarjetaColonia(),
          const SizedBox(height: Espaciado.bloque),
          GrupoDeFilas(
            filas: [
              FilaKnock(
                icono: Icons.handyman_outlined,
                titulo: textos.inicioExplorarOficios,
                detalle: textos.inicioExplorarOficiosDetalle,
                alTocar: () => context.go(Rutas.oficios),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TarjetaColonia extends ConsumerWidget {
  const _TarjetaColonia();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = AppLocalizations.of(context);
    final estado = ref.watch(coloniaControllerProvider);
    final consultar = ref.read(coloniaControllerProvider.notifier).consultar;
    final (String texto, String? boton) = switch (estado) {
      ColoniaSinPedir() => (textos.inicioZonaSinPedir, textos.inicioVerColonia),
      ColoniaConsultando() => (textos.inicioZonaBuscando, null),
      ColoniaEncontrada(:final colonia) => (
        '${colonia.nombre}, ${colonia.municipio} (C.P. ${colonia.cp})',
        textos.inicioActualizar,
      ),
      ColoniaFueraDeCobertura() => (
        textos.inicioZonaFuera,
        textos.inicioReintentar,
      ),
      ColoniaSinUbicacion() => (
        textos.inicioZonaSinUbicacion,
        textos.inicioReintentar,
      ),
      ColoniaConError(:final falla) => (
        mensajeDeFailure(falla),
        textos.inicioReintentar,
      ),
    };
    return TarjetaKnock(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            textos.inicioZonaTitulo,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (estado is ColoniaConsultando)
            LinearProgressIndicator(semanticsLabel: textos.inicioZonaBuscando),
          Text(texto),
          if (boton != null) ...[
            const SizedBox(height: 8),
            FilledButton(onPressed: consultar, child: Text(boton)),
          ],
        ],
      ),
    );
  }
}
