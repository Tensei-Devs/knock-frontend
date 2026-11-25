import 'dart:async';

import 'package:app/features/actividad/actividad.dart' as act;
import 'package:app/features/explorar/explorar.dart';
import 'package:app/features/maqueta/datos.dart';
import 'package:app/features/maqueta/nav.dart';
import 'package:app/features/maqueta/solicitudes_reales.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Icono de la maqueta para un oficio del catálogo.
String iconoDeOficio(String id) => id == 'mec'
    ? 'car'
    : id == 'plo'
    ? 'drop'
    : 'bolt';

/// «dd/mm a las hh:mm».
String fechaDeCopia(DateTime d) {
  String dos(int n) => n.toString().padLeft(2, '0');
  return '${dos(d.day)}/${dos(d.month)} a las ${dos(d.hour)}:${dos(d.minute)}';
}

/// Bloques de Explorar con datos reales (spec 036, backend 046 TEC-14):
/// carga, error con Reintentar, vacío y la última copia con su fecha si no hay
/// conexión (CA-45, CA-49). Sin sesión solo llegan los bloques públicos;
/// «Trabajos reales» y «Cerca de ti» aparecen cuando hay sesión. No registra
/// nada (CA-60).
class ExplorarReal extends ConsumerWidget {
  const ExplorarReal({super.key, required this.oficio, required this.alPedir});

  /// Oficio elegido en los chips (`null` es «Todo»).
  final String? oficio;

  /// Abre una solicitud del oficio.
  final void Function(String oficio) alPedir;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtro = FiltroExplorar.deOficio(oficio);
    final estado = ref.watch(explorarProvider(filtro));
    void reintentar() => ref.invalidate(explorarProvider(filtro));
    return estado.when(
      skipLoadingOnRefresh: false,
      loading: () => sMut('Cargando lo que hay cerca de ti…'),
      error: (_, _) => _Aviso(
        'No pudimos cargar Explorar. Revisa tu conexión e inténtalo de nuevo.',
        reintentar,
      ),
      data: (vista) => stack([
        if (vista.esCopia)
          _Aviso(
            'Sin conexión. Es lo que viste el ${fechaDeCopia(vista.copiaDel!)}; puede estar desactualizado.',
            reintentar,
          ),
        if (vista.datos.vacio)
          sMut('Todavía no hay expertos para mostrar aquí.')
        else
          ..._bloques(context, vista.datos),
      ], gap: 26),
    );
  }

  List<Widget> _bloques(BuildContext context, Explorar e) => [
    if (e.serviciosPopulares.isNotEmpty)
      _Seccion(
        'Servicios populares',
        _Fila([
          for (final s in e.serviciosPopulares) _Servicio(s, alPedir: alPedir),
        ]),
      ),
    if (e.trabajosReales case final fotos? when fotos.isNotEmpty)
      _Seccion('Trabajos reales', _Fotos(fotos), sub: 'de expertos de Knock'),
    if (e.cercaDeTi case final cerca? when cerca.isNotEmpty)
      _Seccion('Cerca de ti', _Fila([for (final t in cerca) _Tecnico(t)])),
    if (e.mejorCalificados.isNotEmpty)
      _Seccion(
        'Mejor calificados',
        _Fila([for (final t in e.mejorCalificados) _Tecnico(t)]),
      ),
    if (e.ideas.any((i) => cats.containsKey(i.clave)))
      _Seccion(
        'Ideas para tu casa y tu auto',
        stack([
          for (final i in e.ideas)
            if (cats.containsKey(i.clave))
              CardK(
                child: stack([
                  h3(i.nombre),
                  BtnK(
                    'Pedir cotización',
                    () => alPedir(i.clave),
                    kind: Bk.sec,
                    sm: true,
                  ),
                ], gap: 10),
              ),
        ], gap: 12),
      ),
  ];
}

class _Aviso extends StatelessWidget {
  const _Aviso(this.texto, this.reintentar);

  final String texto;
  final VoidCallback reintentar;

  @override
  Widget build(BuildContext context) => Row(
    spacing: 12,
    children: [
      Expanded(
        child: T(texto, size: 14, w: FontWeight.w800, color: kc(context).red),
      ),
      BtnK('Reintentar', reintentar, kind: Bk.sec, sm: true, auto: true),
    ],
  );
}

class _Seccion extends StatelessWidget {
  const _Seccion(this.titulo, this.hijo, {this.sub});

  final String titulo;
  final String? sub;
  final Widget hijo;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: 12,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [h2(titulo), if (sub != null) sMut(sub!)],
      ),
      hijo,
    ],
  );
}

class _Fila extends StatelessWidget {
  const _Fila(this.hijos);

  final List<Widget> hijos;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    clipBehavior: Clip.none,
    child: Row(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: hijos,
    ),
  );
}

class _Servicio extends StatelessWidget {
  const _Servicio(this.servicio, {required this.alPedir});

  final ServicioPopular servicio;
  final void Function(String oficio) alPedir;

  @override
  Widget build(BuildContext context) {
    final k = kc(context);
    final c = cats[servicio.clave];
    final fg = c?.fg ?? k.navy;
    final n = servicio.tecnicos;
    final cuantos = n == 1 ? '1 experto' : '$n expertos';
    return Semantics(
      button: c != null,
      label: '${servicio.nombre}, $cuantos',
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: c == null ? null : () => alPedir(servicio.clave),
        child: Container(
          width: 156,
          constraints: const BoxConstraints(minHeight: 120),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: c?.bg ?? k.navySoft,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Container(
                width: 44,
                height: 44,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(165),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icn(iconoDeOficio(servicio.clave)), color: fg),
              ),
              T(servicio.nombre, size: 16, w: FontWeight.w900, color: fg),
              T(cuantos, size: 13, w: FontWeight.w700, color: fg),
            ],
          ),
        ),
      ),
    );
  }
}

class _Fotos extends StatelessWidget {
  const _Fotos(this.fotos);

  final List<FotoTrabajo> fotos;

  @override
  Widget build(BuildContext context) {
    Widget foto(FotoTrabajo f) => Semantics(
      image: true,
      label: 'Foto de un trabajo terminado',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 150,
          margin: const EdgeInsets.only(bottom: 10),
          color: kc(context).navySoft,
          child: Image.network(
            f.url,
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (_, _, _) => const SizedBox.shrink(),
          ),
        ),
      ),
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        for (final columna in [0, 1])
          Expanded(
            child: Column(
              children: [
                for (var i = columna; i < fotos.length; i += 2) foto(fotos[i]),
              ],
            ),
          ),
      ],
    );
  }
}

/// Tarjeta de un técnico real. Abre su perfil con lo que mandó el servidor
/// (el perfil completo llega con TEC-05).
class _Tecnico extends StatelessWidget {
  const _Tecnico(this.tecnico);

  final TecnicoDestacado tecnico;

  String? get _oficio => tecnico.oficios.where(cats.containsKey).firstOrNull;

  void _abrir(BuildContext context, String oficio) {
    final prov = provDeTecnico(
      act.TecnicoResumen(
        id: tecnico.id,
        nombre: tecnico.titulo,
        verificado: tecnico.verificado,
        calificacion: tecnico.calificacion,
      ),
      oficio,
    );
    provs[prov.id] = prov;
    unawaited(context.push(RM.experto(prov.id)));
  }

  @override
  Widget build(BuildContext context) {
    final k = kc(context);
    final oficio = _oficio;
    final oficios = [
      for (final o in tecnico.oficios)
        if (cats[o] case final c?) c.short,
    ].join(', ');
    final calificacion = tecnico.calificacion == null
        ? 'Nuevo'
        : '★ ${tecnico.calificacion!.toStringAsFixed(1)}';
    final anios = tecnico.anios == null ? '' : ' · ${tecnico.anios} años';
    return Semantics(
      button: oficio != null,
      label:
          '${tecnico.titulo}${tecnico.verificado ? ', verificado' : ''}, $calificacion',
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: oficio == null ? null : () => _abrir(context, oficio),
        child: Container(
          width: 176,
          constraints: const BoxConstraints(minHeight: 48),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: k.surface,
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0F1E3A5F),
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Av(
                ini: initials(tecnico.titulo),
                color: const Color(0xFF2A5568),
                verified: tecnico.verificado,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: T(
                  tecnico.titulo,
                  size: 15.5,
                  w: FontWeight.w900,
                  maxLines: 2,
                ),
              ),
              if (oficios.isNotEmpty) sMut(oficios, size: 13),
              sMut('$calificacion$anios', size: 13),
            ],
          ),
        ),
      ),
    );
  }
}
