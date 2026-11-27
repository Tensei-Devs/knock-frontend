import 'dart:async';

import 'package:app/features/entrada/presentation/cuenta_regresiva_controller.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Lo que va bajo el paso del código (HU-001): «Reenviar código», cuando
/// termina la cuenta regresiva, y «Cambiar número».
class PieDeCodigo extends ConsumerWidget {
  const PieDeCodigo({
    required this.cargando,
    required this.reenviar,
    required this.alCambiarNumero,
    super.key,
  });

  final bool cargando;

  /// `true` si el SMS salió: la cuenta vuelve a empezar.
  final Future<bool> Function() reenviar;
  final VoidCallback alCambiarNumero;

  Future<void> _reenviar(WidgetRef ref) async {
    final enviado = await reenviar();
    if (enviado && ref.context.mounted) {
      ref.read(cuentaRegresivaProvider.notifier).reiniciar();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = AppLocalizations.of(context);
    final tema = Theme.of(context);
    final segundos = ref.watch(cuentaRegresivaProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (segundos > 0)
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: Center(
              child: Text(
                textos.entradaReenviarEn(segundos),
                textAlign: TextAlign.center,
                style: tema.textTheme.bodyLarge?.copyWith(
                  color: tema.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          )
        else
          TextButton(
            onPressed: cargando ? null : () => unawaited(_reenviar(ref)),
            child: Text(textos.entradaReenviarCodigo),
          ),
        TextButton(
          onPressed: alCambiarNumero,
          child: Text(textos.entradaCambiarNumero),
        ),
      ],
    );
  }
}
