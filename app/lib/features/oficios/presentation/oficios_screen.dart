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
  Widget build(BuildContext context) => MaterialBanner(
    leading: const Icon(Icons.cloud_off_outlined),
    content: const Text('Sin conexión. Se muestra lo último guardado.'),
    actions: [
      TextButton(
        onPressed: alReintentar,
        style: TextButton.styleFrom(minimumSize: const Size(64, 48)),
        child: const Text('Reintentar'),
      ),
    ],
  );
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
  Widget build(BuildContext context) => const Center(
    child: Padding(
      padding: EdgeInsets.all(24),
      child: Text(
        'Todavía no hay oficios disponibles',
        textAlign: TextAlign.center,
      ),
    ),
  );
}

class _ConError extends StatelessWidget {
  const _ConError({required this.alReintentar});

  final VoidCallback alReintentar;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'No pudimos cargar los oficios',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: alReintentar,
            style: FilledButton.styleFrom(minimumSize: const Size(64, 48)),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    ),
  );
}

class _Lista extends StatelessWidget {
  const _Lista({required this.oficios});

  final List<Oficio> oficios;

  @override
  Widget build(BuildContext context) => ListView.builder(
    itemCount: oficios.length,
    itemBuilder: (context, indice) => _FilaOficio(oficio: oficios[indice]),
  );
}

class _FilaOficio extends StatelessWidget {
  const _FilaOficio({required this.oficio});

  final Oficio oficio;

  @override
  Widget build(BuildContext context) {
    final modalidad = oficio.modalidad;
    final texto = _textoDeModalidad(modalidad);
    return ListTile(
      leading: Icon(_iconoDeModalidad(modalidad), semanticLabel: texto),
      title: Text(oficio.nombre),
      subtitle: Text(texto),
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
