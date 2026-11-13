import 'dart:async';

import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// El código de 4 dígitos en cuatro recuadros (spec 016, CA-01, CA-08 y
/// CA-14). «Ocultar código» lo tapa sin borrarlo; el lector lo anuncia
/// dígito por dígito y nunca depende solo del color.
class CodigoVisita extends StatefulWidget {
  const CodigoVisita({required this.codigo, super.key});

  final String codigo;

  @override
  State<CodigoVisita> createState() => _CodigoVisitaState();
}

class _CodigoVisitaState extends State<CodigoVisita> {
  var _oculto = false;

  void _alternar() {
    setState(() => _oculto = !_oculto);
    final textos = AppLocalizations.of(context);
    if (_oculto) {
      unawaited(
        SemanticsService.sendAnnouncement(
          View.of(context),
          textos.visitaCodigoOculto,
          Directionality.of(context),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final tema = Theme.of(context);
    final digitos = widget.codigo.split('');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(textos.visitaCodigoTitulo, style: tema.textTheme.titleMedium),
        const SizedBox(height: 8),
        Semantics(
          // «4, 7, 1, 2»: dígito por dígito, no «cuatro mil…» (CA-14).
          label: _oculto
              ? textos.visitaCodigoOculto
              : textos.visitaCodigoEtiqueta(digitos.join(', ')),
          excludeSemantics: true,
          child: Wrap(
            runSpacing: 8,
            children: [
              for (final digito in digitos)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(
                    width: 56,
                    height: 64,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _oculto
                          ? tema.colorScheme.onSurface
                          : tema.colorScheme.surfaceContainerHighest,
                      border: Border.all(color: tema.colorScheme.outline),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _oculto ? '•' : digito,
                      style: tema.textTheme.headlineMedium?.copyWith(
                        color: _oculto
                            ? tema.colorScheme.surface
                            : tema.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: _alternar,
          icon: Icon(
            _oculto ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          ),
          label: Text(
            _oculto ? textos.visitaMostrarCodigo : textos.visitaOcultarCodigo,
          ),
        ),
      ],
    );
  }
}
