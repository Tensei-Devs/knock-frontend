import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/features/maqueta/datos.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/solicitudes_reales.dart'
    show coloniaIdDeLaPersona;
import 'package:app/features/maqueta/ui.dart';
import 'package:app/features/tecnico/tecnico.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 404 `technician_not_found`: el técnico «no está disponible» (CA-19, CA-23,
/// CA-27 y CA-03 de la spec 037).
String _textoDeFalla(AppLocalizations l, Object falla) =>
    falla is NoEncontradoFailure
    ? l.tecnicoNoDisponible
    : mensajeDeError(l, falla);

/// Carga, error o sin conexión con Reintentar, y datos con aviso si son una
/// copia (CA-52 y CA-14 de la spec 037).
Widget _estados<T>(
  AppLocalizations l,
  AsyncValue<ConFecha<T>> estado, {
  required VoidCallback reintentar,
  required Widget Function(T) datos,
}) => estado.when(
  loading: () => sMut(l.tecnicoCargando),
  error: (error, _) => stack([
    NoteK('red', 'help', _textoDeFalla(l, error)),
    BtnK(l.tecnicoReintentar, reintentar, kind: Bk.sec),
  ], gap: 8),
  data: (vista) => stack([
    if (vista.copiaDel case final fecha?)
      NoteK('amber', 'help', l.tecnicoCopia(fecha)),
    datos(vista.datos),
  ], gap: 8),
);

String _nombreDeOficio(String clave) => cats[clave]?.short ?? clave;

/// Lo que el servidor dice del técnico (TEC-05). Con [conSesion] suma sus
/// servicios (SRV-01), si llega a la colonia (TEC-06) y las fotos de sus
/// trabajos (TEC-07), que piden sesión.
class PerfilPublicoReal extends ConsumerWidget {
  const PerfilPublicoReal({
    super.key,
    required this.tecnicoId,
    required this.conSesion,
  });

  final String tecnicoId;
  final bool conSesion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return stack([
      _estados(
        l,
        ref.watch(perfilPublicoProvider(tecnicoId)),
        reintentar: () => ref.invalidate(perfilPublicoProvider(tecnicoId)),
        datos: (perfil) => _Resumen(perfil),
      ),
      if (conSesion) ...[
        _Colonia(tecnicoId),
        _Servicios(tecnicoId),
        _Fotos(tecnicoId),
      ],
    ], gap: 12);
  }
}

class _Resumen extends StatelessWidget {
  const _Resumen(this.perfil);

  final PerfilPublico perfil;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final detalle = perfil.detalle;
    final descripcion = detalle?.descripcion ?? perfil.descripcionCorta;
    final atencion = switch (detalle?.atencion) {
      'taller' => l.tecnicoAtiendeTaller,
      'domicilio' => l.tecnicoAtiendeDomicilio,
      'ambos' => l.tecnicoAtiendeAmbos,
      _ => null,
    };
    return CardK(
      child: stack([
        if (perfil.nombreNegocio case final negocio?) bT(negocio),
        sMut(
          [
            ...perfil.oficios.map(_nombreDeOficio),
            if (perfil.calificacion case final c?)
              l.tecnicoCalificacion(c.toStringAsFixed(1)),
            if (perfil.anios case final a?) l.tecnicoAnios(a),
          ].join(' · '),
        ),
        if (descripcion != null) T(descripcion),
        if (atencion != null)
          sMut(
            [
              atencion,
              if (detalle?.radioKm case final km?) l.tecnicoRadio(km),
            ].join(' · '),
          ),
        if (detalle?.disponibleHoy ?? false)
          Pill(l.tecnicoDisponibleHoy, kind: 'green'),
      ], gap: 8),
    );
  }
}

/// Si atiende la colonia de la persona. Sin colonia conocida no se pregunta.
class _Colonia extends ConsumerStatefulWidget {
  const _Colonia(this.tecnicoId);

  final String tecnicoId;

  @override
  ConsumerState<_Colonia> createState() => _ColoniaState();
}

class _ColoniaState extends ConsumerState<_Colonia> {
  late Future<String> _id = coloniaIdDeLaPersona(ref, maq.user);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return FutureBuilder<String>(
      future: _id,
      builder: (context, colonia) {
        if (colonia.error case final error?) {
          if (error is OpcionNoDisponibleFailure) {
            return sMut(l.tecnicoSinColonia);
          }
          return stack([
            NoteK('red', 'help', _textoDeFalla(l, error)),
            BtnK(l.tecnicoReintentar, () {
              setState(() => _id = coloniaIdDeLaPersona(ref, maq.user));
            }, kind: Bk.sec),
          ], gap: 8);
        }
        final id = colonia.data;
        if (id == null) return sMut(l.tecnicoCargando);
        final consulta = llegaAMiColoniaProvider((widget.tecnicoId, id));
        return _estados(
          l,
          ref.watch(consulta),
          reintentar: () => ref.invalidate(consulta),
          datos: (atiende) => NoteK(
            atiende ? 'green' : 'amber',
            'house',
            atiende
                ? l.tecnicoLlega(maq.user.col)
                : l.tecnicoNoLlega(maq.user.col),
          ),
        );
      },
    );
  }
}

class _Servicios extends ConsumerWidget {
  const _Servicios(this.tecnicoId);

  final String tecnicoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return CardK(
      child: stack([
        h3(l.tecnicoServicios),
        _estados(
          l,
          ref.watch(serviciosPublicosProvider(tecnicoId)),
          reintentar: () =>
              ref.invalidate(serviciosPublicosProvider(tecnicoId)),
          datos: (servicios) => stack([
            if (servicios.isEmpty) sMut(l.tecnicoSinServicios),
            for (final s in servicios)
              MergeSemantics(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          T(s.nombre, w: FontWeight.w800),
                          if (s.detalle case final d?) sMut(d, size: 13.5),
                        ],
                      ),
                    ),
                    T(
                      l.tecnicoDesde(money(s.precioReferencia)),
                      w: FontWeight.w900,
                    ),
                  ],
                ),
              ),
            if (servicios.isNotEmpty) sMut(l.tecnicoPreciosDeReferencia),
          ], gap: 10),
        ),
      ], gap: 8),
    );
  }
}

class _Fotos extends ConsumerWidget {
  const _Fotos(this.tecnicoId);

  final String tecnicoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final consulta = fotosDeTrabajosProvider(tecnicoId);
    final control = ref.read(consulta.notifier);
    return CardK(
      child: stack([
        h3(l.tecnicoFotos),
        _estados(
          l,
          ref.watch(consulta),
          reintentar: control.reintentar,
          datos: (pagina) => stack([
            if (pagina.fotos.isEmpty) sMut(l.tecnicoSinFotos),
            if (pagina.fotos.isNotEmpty)
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final f in pagina.fotos)
                    Semantics(
                      image: true,
                      label: l.tecnicoFotoEtiqueta,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          f.url,
                          width: 130,
                          height: 130,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const SizedBox(
                            width: 130,
                            height: 130,
                            child: Icon(Icons.broken_image_outlined),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            if (pagina.siguiente != null)
              BtnK(l.tecnicoVerMasFotos, () async {
                final falla = await control.cargarMas();
                if (falla != null && context.mounted) {
                  maq.toast(_textoDeFalla(l, falla));
                }
              }, kind: Bk.ghost),
          ], gap: 10),
        ),
      ], gap: 8),
    );
  }
}
