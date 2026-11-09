import 'package:app/core/permisos/explicacion_permiso.dart';
import 'package:app/core/permisos/gestor_permisos.dart';
import 'package:app/features/inicio/zona_providers.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Elige la zona con la ubicación o, si se niega, con el código postal
/// (spec 012, R-06 y R-07).
///
/// Antes de pedir la ubicación explica para qué se usa. Si la persona dice
/// «Ahora no», la deniega o apaga el servicio, el campo del código postal
/// aparece y la app sigue funcionando.
class SelectorDeZona extends ConsumerStatefulWidget {
  const SelectorDeZona({required this.alUbicar, super.key});

  /// Recibe las coordenadas una sola vez; no se guardan.
  final void Function(double latitud, double longitud) alUbicar;

  @override
  ConsumerState<SelectorDeZona> createState() => _SelectorDeZonaState();
}

class _SelectorDeZonaState extends ConsumerState<SelectorDeZona> {
  final _codigo = TextEditingController();
  bool _invalido = false;
  bool _prefiereCodigo = false;

  @override
  void dispose() {
    _codigo.dispose();
    super.dispose();
  }

  Future<void> _usarUbicacion() async {
    if (!await explicarPermiso(context, PermisoApp.ubicacion)) {
      if (mounted) setState(() => _prefiereCodigo = true);
      return;
    }
    await ref
        .read(zonaControllerProvider.notifier)
        .usarUbicacion(alUbicar: widget.alUbicar);
  }

  void _confirmarCodigo() {
    final valido = ref
        .read(zonaControllerProvider.notifier)
        .usarCodigoPostal(_codigo.text);
    setState(() => _invalido = !valido);
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final estado = ref.watch(zonaControllerProvider);
    final pideCodigo = _prefiereCodigo || estado is ZonaPideCodigoPostal;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilledButton.icon(
            onPressed: _usarUbicacion,
            icon: const Icon(Icons.my_location),
            label: Text(textos.zonaUsarUbicacion),
          ),
          if (pideCodigo) ...[
            const SizedBox(height: 16),
            if (estado is ZonaPideCodigoPostal)
              Text(textos.zonaPideCodigoPostal),
            const SizedBox(height: 8),
            TextField(
              controller: _codigo,
              keyboardType: TextInputType.number,
              maxLength: 5,
              decoration: InputDecoration(
                labelText: textos.zonaCodigoPostal,
                errorText: _invalido ? textos.zonaCodigoPostalInvalido : null,
              ),
              onSubmitted: (_) => _confirmarCodigo(),
            ),
            FilledButton(
              onPressed: _confirmarCodigo,
              child: Text(textos.zonaContinuar),
            ),
          ],
        ],
      ),
    );
  }
}
