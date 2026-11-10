import 'package:app/core/tema/colores.dart';
import 'package:app/core/tema/tokens.dart';
import 'package:app/core/widgets/estado_knock.dart';
import 'package:app/core/widgets/fila_knock.dart';
import 'package:app/core/widgets/pantalla_titulada.dart';
import 'package:app/features/oficios/domain/modalidad.dart';
import 'package:app/features/oficios/domain/oficio.dart';
import 'package:app/features/oficios/presentation/oficios_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Lista de oficios con sus cuatro estados: cargando, datos, vacío y error con
/// Reintentar (TT-PRU-02). Textos literales en español hasta que TT-MOB-02 los
/// pase a ARB.
class OficiosScreen extends ConsumerWidget {
  const OficiosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(oficiosControllerProvider);
    // «Cargando» va primero: tras Reintentar el estado conserva el error
    // anterior mientras vuelve a pedir, y se debe ver la carga.
    final Widget cuerpo;
    if (estado.isLoading) {
      cuerpo = const _Cargando();
    } else if (estado.hasError) {
      cuerpo = _ConError(
        alReintentar: ref.read(oficiosControllerProvider.notifier).reintentar,
      );
    } else if (estado.requireValue.isEmpty) {
      cuerpo = const _Vacio();
    } else if (ref.watch(oficiosSinConexionProvider)) {
      cuerpo = Column(
        children: [
          _AvisoSinConexion(
            alReintentar: ref
                .read(oficiosControllerProvider.notifier)
                .reintentar,
          ),
          Expanded(child: _Lista(oficios: estado.requireValue)),
        ],
      );
    } else {
      cuerpo = _Lista(oficios: estado.requireValue);
    }
    return PantallaTitulada(titulo: 'Oficios', cuerpo: cuerpo);
  }
}

/// Franja sobre la lista cuando se muestra lo guardado por falta de conexión
/// (spec 010). Textos literales como el resto de la pantalla (TT-MOB-02).
class _AvisoSinConexion extends StatelessWidget {
  const _AvisoSinConexion({required this.alReintentar});

  final VoidCallback alReintentar;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    // `.note.n-amber`: fondo naranja suave con su texto validado (4.5:1).
    return MaterialBanner(
      backgroundColor: c.amberSoft,
      contentTextStyle: Theme.of(context).textTheme.bodyLarge
          ?.copyWith(color: c.sobreAmberSoft, fontWeight: FontWeight.w700),
      dividerColor: Colors.transparent,
      leading: Icon(Icons.cloud_off_outlined, color: c.sobreAmberSoft),
      content: const Text('Sin conexión. Se muestra lo último guardado.'),
      actions: [
        TextButton(
          onPressed: alReintentar,
          style: TextButton.styleFrom(foregroundColor: c.sobreAmberSoft),
          child: const Text('Reintentar'),
        ),
      ],
    );
  }
}

class _Cargando extends StatelessWidget {
  const _Cargando();

  @override
  Widget build(BuildContext context) => const Center(
    child: CircularProgressIndicator(semanticsLabel: 'Cargando oficios'),
  );
}

class _Vacio extends StatelessWidget {
  const _Vacio();

  @override
  Widget build(BuildContext context) => const EstadoKnock(
    icono: Icons.handyman_outlined,
    titulo: 'Todavía no hay oficios disponibles',
  );
}

class _ConError extends StatelessWidget {
  const _ConError({required this.alReintentar});

  final VoidCallback alReintentar;

  @override
  Widget build(BuildContext context) => EstadoKnock(
    icono: Icons.cloud_off_outlined,
    titulo: 'No pudimos cargar los oficios',
    accion: FilledButton(
      onPressed: alReintentar,
      child: const Text('Reintentar'),
    ),
  );
}

class _Lista extends StatelessWidget {
  const _Lista({required this.oficios});

  final List<Oficio> oficios;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(Espaciado.cuerpo),
    children: [
      GrupoDeFilas(
        filas: [for (final oficio in oficios) _FilaOficio(oficio: oficio)],
      ),
    ],
  );
}

class _FilaOficio extends StatelessWidget {
  const _FilaOficio({required this.oficio});

  final Oficio oficio;

  @override
  Widget build(BuildContext context) {
    final modalidad = oficio.modalidad;
    final texto = _textoDeModalidad(modalidad);
    return FilaKnock(
      icono: _iconoDeModalidad(modalidad),
      etiquetaIcono: texto,
      titulo: oficio.nombre,
      detalle: texto,
    );
  }
}

IconData _iconoDeModalidad(Modalidad modalidad) {
  if (modalidad.esDomicilio) {
    return Icons.home_repair_service_outlined;
  }
  if (modalidad.esTaller) {
    return Icons.build_outlined;
  }
  return Icons.category_outlined;
}

String _textoDeModalidad(Modalidad modalidad) {
  if (modalidad.esDomicilio) {
    return 'A domicilio';
  }
  if (modalidad.esTaller) {
    return 'En taller';
  }
  return modalidad.valor;
}
