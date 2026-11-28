import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/features/actividad/actividad.dart'
    show solicitudesRealesActivasProvider;
import 'package:app/features/bandeja_avisos/bandeja_avisos.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void _avisarFalla(BuildContext context, Failure? falla) {
  if (falla == null || !context.mounted) return;
  maq.toast(
    falla is NoEncontradoFailure
        ? 'Ese aviso ya no está disponible.'
        : mensajeDeError(AppLocalizations.of(context), falla),
  );
}

/// Nombre y explicación de cada tipo que conoce la app.
({String titulo, String detalle}) textoDeTipo(String tipo) => switch (tipo) {
  'cotizaciones' => (
    titulo: 'Nuevas cotizaciones',
    detalle: 'Cuando un experto responde tu solicitud',
  ),
  'mensajes' => (
    titulo: 'Mensajes',
    detalle: 'De las personas con las que hablas',
  ),
  'visitas' => (
    titulo: 'Visitas y citas',
    detalle: 'Confirmaciones, cambios y llegada',
  ),
  'solicitudes' => (
    titulo: 'Solicitudes',
    detalle: 'Solicitudes nuevas y sus cambios',
  ),
  'opiniones' => (
    titulo: 'Opiniones y respuestas',
    detalle: 'Cuando opinan o responden',
  ),
  'verificaciones' => (
    titulo: 'Verificación',
    detalle: 'El estado de tu verificación',
  ),
  'seguridad' => (titulo: 'Seguridad', detalle: 'Avisos de tu cuenta'),
  'promociones' => (
    titulo: 'Promociones y novedades',
    detalle: 'Ofertas y noticias de Knock',
  ),
  _ => (titulo: 'Otros avisos', detalle: 'Avisos de Knock'),
};

/// Carga, error con Reintentar y datos (CA-13 y CA-17).
Widget _estados<D>(
  AsyncValue<D> estado, {
  required String cargando,
  required String error,
  required VoidCallback reintentar,
  required Widget Function(D) datos,
}) => estado.when(
  loading: () => sMut(cargando),
  error: (_, _) => stack([
    NoteK('red', 'help', error),
    BtnK('Reintentar', reintentar, kind: Bk.sec),
  ], gap: 12),
  data: datos,
);

/// La bandeja de «Avisos» con datos reales (spec 034, backend 044). Tocar un
/// aviso lo marca como leído; todavía no abre un destino.
class AvisosReales extends ConsumerWidget {
  const AvisosReales({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final control = ref.read(bandejaAvisosControllerProvider.notifier);
    return _estados(
      ref.watch(bandejaAvisosControllerProvider),
      cargando: 'Cargando tus avisos…',
      error: 'No pudimos cargar tus avisos.',
      reintentar: control.reintentar,
      datos: (pagina) => stack([
        if (pagina.items.isEmpty)
          sMut(
            'Sin avisos por ahora. Aquí verás cuando te lleguen cotizaciones o se confirme una visita.',
          )
        else ...[
          if (pagina.items.any((a) => !a.leido))
            LinkK('Marcar leídos', () async {
              final falla = await control.marcarTodos();
              if (context.mounted) _avisarFalla(context, falla);
            }),
          GroupK([
            for (final a in pagina.items)
              _Fila(
                a,
                alTocar: a.leido
                    ? null
                    : () async {
                        final falla = await control.marcarLeido(a.id);
                        if (context.mounted) _avisarFalla(context, falla);
                      },
              ),
          ]),
        ],
        if (pagina.siguiente != null)
          BtnK('Ver más', () async {
            final falla = await control.cargarMas();
            if (context.mounted) _avisarFalla(context, falla);
          }, kind: Bk.ghost),
      ], gap: 12),
    );
  }
}

class _Fila extends StatelessWidget {
  const _Fila(this.aviso, {required this.alTocar});

  final AvisoEnBandeja aviso;
  final VoidCallback? alTocar;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: alTocar,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 14,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2,
              children: [
                T(aviso.titulo, w: FontWeight.w800),
                sMut(aviso.texto, size: 13.5),
              ],
            ),
          ),
          if (!aviso.leido) const Pill('Nuevo', kind: 'amber'),
        ],
      ),
    ),
  );
}

/// «Qué avisos recibir» con datos reales: los interruptores y cuáles se pueden
/// apagar los dice el servidor.
class PreferenciasDeAvisosReales extends ConsumerWidget {
  const PreferenciasDeAvisosReales({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final control = ref.read(preferenciasDeAvisosControllerProvider.notifier);
    return _estados(
      ref.watch(preferenciasDeAvisosControllerProvider),
      cargando: 'Cargando tus preferencias…',
      error: 'No pudimos cargar tus preferencias.',
      reintentar: control.reintentar,
      datos: (preferencias) => GroupK([
        for (final p in preferencias)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              spacing: 14,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 2,
                    children: [
                      T(textoDeTipo(p.tipo).titulo, w: FontWeight.w800),
                      sMut(
                        p.apagable
                            ? textoDeTipo(p.tipo).detalle
                            : 'Siempre activo',
                        size: 13.5,
                      ),
                    ],
                  ),
                ),
                Semantics(
                  label: textoDeTipo(p.tipo).titulo,
                  toggled: p.activo,
                  child: Sw(
                    on: p.activo,
                    onTap: p.apagable
                        ? () => unawaited(
                            control.cambiar(p.tipo, activo: !p.activo).then((
                              falla,
                            ) {
                              if (context.mounted) _avisarFalla(context, falla);
                            }),
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
      ]),
    );
  }
}

/// El punto de la campana y el contador de «Avisos». Con sesión y API salen de
/// `GET /avisos/no-leidos/contador`; mientras carga o si falla no se muestra
/// nada. Sin sesión se queda lo de [ejemplo].
class ContadorDeAvisos extends ConsumerWidget {
  const ContadorDeAvisos({
    super.key,
    required this.marca,
    this.ejemplo = const SizedBox.shrink(),
  });

  /// Cómo se dibuja cuando hay avisos sin leer.
  final Widget Function(AvisosSinLeer) marca;
  final Widget ejemplo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(solicitudesRealesActivasProvider)) return ejemplo;
    final sinLeer = ref.watch(avisosSinLeerControllerProvider).value;
    return sinLeer == null || sinLeer.cantidad == 0
        ? const SizedBox.shrink()
        : marca(sinLeer);
  }
}
