import 'dart:async';

import 'package:app/core/config/exportacion_de_datos.dart';
import 'package:app/core/enlaces/abridor_de_enlaces.dart';
import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/features/cuenta/cuenta.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// «Descargar mis datos» contra la API (spec 029, USR-06 y USR-06b). Con el
/// interruptor apagado no llama al servidor.
class ExportacionReal extends ConsumerWidget {
  const ExportacionReal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: stack([
        T(l.cuentaDescargarTitulo, w: FontWeight.w800),
        if (!ref.watch(exportacionDeDatosActivaProvider))
          sMut(l.cuentaDescargarNoDisponible)
        else
          ..._estado(context, ref, l),
      ], gap: 8),
    );
  }

  List<Widget> _estado(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l,
  ) {
    final estado = ref.watch(exportacionControllerProvider);
    final control = ref.read(exportacionControllerProvider.notifier);
    if (estado.isLoading) return [sMut(l.cuentaDescargarCargando)];
    final error = estado.error;
    if (error != null) {
      return [
        sMut(mensajeDeError(l, error)),
        BtnK(l.cuentaReintentar, control.reintentar, kind: Bk.sec),
      ];
    }
    Widget pedir() => BtnK(l.cuentaDescargarPedir, () async {
      final falla = await control.pedir();
      maq.toast(switch (falla) {
        null => l.cuentaDescargarPedida,
        ConflictoFailure() => l.cuentaDescargarYaEnCurso,
        _ => mensajeDeError(l, falla),
      });
    }, kind: Bk.sec);
    final exportacion = estado.value;
    return switch (exportacion?.estado) {
      null => [sMut(l.cuentaDescargarSinPedir), pedir()],
      EstadoExportacion.vencida => [sMut(l.cuentaDescargarVencida), pedir()],
      EstadoExportacion.enPreparacion => [
        sMut(l.cuentaDescargarEnPreparacion),
        BtnK(l.cuentaActualizar, control.reintentar, kind: Bk.sec),
      ],
      EstadoExportacion.lista => [
        sMut(
          l.cuentaDescargarLista(fechaDeCuenta(context, exportacion!.venceEn!)),
        ),
        BtnK(l.cuentaDescargarAbrir, () async {
          final abrio = await ref
              .read(abridorDeEnlacesProvider)
              .abrir(exportacion.enlace!);
          if (!abrio) maq.toast(l.cuentaDescargarNoAbrio);
        }, kind: Bk.sec),
      ],
    };
  }
}

/// Fecha en el idioma activo y la hora del teléfono.
String fechaDeCuenta(BuildContext context, DateTime momento) =>
    MaterialLocalizations.of(context).formatMediumDate(momento.toLocal());

/// Nombre y explicación de cada consentimiento que conoce la app.
({String titulo, String? detalle}) textoDeConsentimiento(
  AppLocalizations l,
  String tipo,
) => switch (tipo) {
  'promociones' => (
    titulo: l.cuentaConsentimientoPromociones,
    detalle: l.cuentaConsentimientoPromocionesDetalle,
  ),
  'encuestas' => (
    titulo: l.cuentaConsentimientoEncuestas,
    detalle: l.cuentaConsentimientoEncuestasDetalle,
  ),
  'recomendaciones' => (
    titulo: l.cuentaConsentimientoRecomendaciones,
    detalle: l.cuentaConsentimientoRecomendacionesDetalle,
  ),
  'aviso_privacidad' => (titulo: l.cuentaConsentimientoAviso, detalle: null),
  'terminos' => (titulo: l.cuentaConsentimientoTerminos, detalle: null),
  _ => (titulo: l.cuentaConsentimientoOtro, detalle: null),
};

/// Los consentimientos de la cuenta (USR-07 y USR-08): cuáles son obligatorios
/// lo dice el servidor.
class ConsentimientosReales extends ConsumerWidget {
  const ConsentimientosReales({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final estado = ref.watch(consentimientosControllerProvider);
    final control = ref.read(consentimientosControllerProvider.notifier);
    return estado.when(
      skipLoadingOnRefresh: false,
      loading: () => sMut(l.cuentaConsentimientosCargando),
      error: (error, _) => stack([
        NoteK('red', 'help', mensajeDeError(l, error)),
        BtnK(l.cuentaReintentar, control.reintentar, kind: Bk.sec),
      ], gap: 12),
      data: (lista) => lista.isEmpty
          ? stack([
              sMut(l.cuentaConsentimientosVacio),
              BtnK(l.cuentaReintentar, control.reintentar, kind: Bk.sec),
            ], gap: 12)
          : GroupK([
              for (final c in lista)
                _FilaConsentimiento(
                  c,
                  alTocar: c.obligatorio
                      ? null
                      : () => unawaited(
                          control.cambiar(c.tipo, vigente: !c.vigente).then((
                            falla,
                          ) {
                            if (falla != null) {
                              maq.toast(mensajeDeError(l, falla));
                            }
                          }),
                        ),
                ),
            ]),
    );
  }
}

class _FilaConsentimiento extends StatelessWidget {
  const _FilaConsentimiento(this.consentimiento, {required this.alTocar});

  final Consentimiento consentimiento;
  final VoidCallback? alTocar;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = consentimiento;
    final texto = textoDeConsentimiento(l, c.tipo);
    final detalle = texto.detalle;
    final version = c.version;
    final fecha = c.fecha;
    // Toda la fila es el control: más de 48 dp y un solo nodo semántico.
    return MergeSemantics(
      child: Semantics(
        toggled: c.obligatorio ? null : c.vigente,
        child: InkWell(
          onTap: alTocar,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              spacing: 14,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 2,
                    children: [
                      T(texto.titulo, w: FontWeight.w800),
                      if (detalle != null) sMut(detalle, size: 13.5),
                      if (c.obligatorio)
                        sMut(l.cuentaConsentimientoObligatorio, size: 13.5),
                      if (version != null && fecha != null)
                        sMut(
                          l.cuentaConsentimientoRegistro(
                            version,
                            fechaDeCuenta(context, fecha),
                          ),
                          size: 13.5,
                        ),
                    ],
                  ),
                ),
                if (!c.obligatorio)
                  ExcludeSemantics(
                    child: Sw(on: c.vigente, onTap: alTocar),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
