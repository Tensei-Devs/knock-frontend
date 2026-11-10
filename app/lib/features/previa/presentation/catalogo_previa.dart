import 'package:app/core/tema/colores.dart';
import 'package:app/core/tema/tokens.dart';
import 'package:app/core/widgets/estado_knock.dart';
import 'package:app/core/widgets/fila_knock.dart';
import 'package:app/features/oficios/oficios.dart';
import 'package:app/features/oficios/presentation/oficios_controller.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Catálogo de oficios dentro de la previa (spec 027, R-06): usa el mismo
/// controlador y repositorio que Explorar (`GET /api/v1/oficios`, caché y
/// `ETag`) y no lleva sesión. Estados: cargando, vacío, error con
/// «Reintentar», sin conexión (con lo guardado) y datos. [clave] filtra por
/// oficio (`null` muestra todos).
class CatalogoPrevia extends ConsumerWidget {
  const CatalogoPrevia({this.clave, super.key});

  final String? clave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = AppLocalizations.of(context);
    final estado = ref.watch(oficiosControllerProvider);
    final controlador = ref.read(oficiosControllerProvider.notifier);
    // «Cargando» va primero: tras Reintentar el estado conserva el error
    // anterior mientras vuelve a pedir, y se debe ver la carga.
    if (estado.isLoading) {
      return Padding(
        padding: const EdgeInsets.all(Espaciado.cuerpo),
        child: Center(
          child: CircularProgressIndicator(
            semanticsLabel: textos.previaCargando,
          ),
        ),
      );
    }
    if (estado.hasError) {
      return EstadoKnock(
        icono: Icons.cloud_off_outlined,
        titulo: textos.previaErrorTitulo,
        accion: FilledButton(
          onPressed: controlador.reintentar,
          child: Text(textos.previaReintentar),
        ),
      );
    }
    final todos = estado.requireValue;
    if (todos.isEmpty) {
      return EstadoKnock(
        icono: Icons.handyman_outlined,
        titulo: textos.previaVacioTitulo,
      );
    }
    final visibles = clave == null
        ? todos
        : [
            for (final oficio in todos)
              if (oficio.clave == clave) oficio,
          ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (ref.watch(oficiosSinConexionProvider))
          _AvisoSinConexion(alReintentar: controlador.reintentar),
        GrupoDeFilas(
          filas: [for (final oficio in visibles) _FilaOficio(oficio: oficio)],
        ),
      ],
    );
  }
}

class _AvisoSinConexion extends StatelessWidget {
  const _AvisoSinConexion({required this.alReintentar});

  final VoidCallback alReintentar;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final c = context.colores;
    return Padding(
      padding: const EdgeInsets.only(bottom: Espaciado.bloqueChico),
      child: MaterialBanner(
        backgroundColor: c.amberSoft,
        contentTextStyle: Theme.of(context).textTheme.bodyLarge
            ?.copyWith(color: c.sobreAmberSoft, fontWeight: FontWeight.w700),
        dividerColor: Colors.transparent,
        leading: Icon(Icons.cloud_off_outlined, color: c.sobreAmberSoft),
        content: Text(textos.previaSinConexion),
        actions: [
          TextButton(
            onPressed: alReintentar,
            style: TextButton.styleFrom(foregroundColor: c.sobreAmberSoft),
            child: Text(textos.previaReintentar),
          ),
        ],
      ),
    );
  }
}

class _FilaOficio extends StatelessWidget {
  const _FilaOficio({required this.oficio});

  final Oficio oficio;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final modalidad = oficio.modalidad;
    final texto = modalidad.esDomicilio
        ? textos.previaModalidadDomicilio
        : modalidad.esTaller
        ? textos.previaModalidadTaller
        : modalidad.valor;
    return FilaKnock(
      icono: modalidad.esDomicilio
          ? Icons.home_repair_service_outlined
          : modalidad.esTaller
          ? Icons.build_outlined
          : Icons.category_outlined,
      etiquetaIcono: texto,
      titulo: oficio.nombre,
      detalle: texto,
      mostrarFlecha: false,
    );
  }
}
