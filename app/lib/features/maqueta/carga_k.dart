import 'dart:async';

import 'package:app/features/maqueta/anim_k.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Animaciones Lottie propias (generadas con tool/lottie_gen).
enum TipoCarga {
  buscando('buscando_mapa', 0.5, true),
  puntos('puntos', 0.0, true),
  exito('exito', 1.0, false),
  escudo('escudo', 0.55, true),
  foto('subiendo_foto', 0.5, true),
  vacioActividad('vacio_actividad', 0.7, true),
  vacioMensajes('vacio_mensajes', 0.3, true),
  vacioBusqueda('vacio_busqueda', 0.3, true);

  const TipoCarga(this.archivo, this.poster, this.repite);
  final String archivo;

  /// Progreso (0..1) que se muestra congelado con «reducir movimiento».
  final double poster;
  final bool repite;
  bool get esperas =>
      this == buscando || this == puntos || this == escudo || this == foto;
}

/// Indicador de carga/estado de Knock: muestra la Lottie del [tipo] y, si el
/// asset falla, cae al indicador anterior (círculo de progreso o icono).
class CargaK extends StatelessWidget {
  const CargaK({
    super.key,
    required this.tipo,
    this.size = 120,
    this.repetir,
    this.color,
  });
  final TipoCarga tipo;
  final double size;
  final bool? repetir;
  final Color? color;

  Widget _respaldo(BuildContext c) {
    final k = kc(c);
    if (tipo.esperas) {
      return SizedBox(
        width: size,
        height: size,
        child: Center(
          child: SizedBox(
            width: size * .35,
            height: size * .35,
            child: CircularProgressIndicator(
              strokeWidth: 3.5,
              color: color ?? k.amber,
            ),
          ),
        ),
      );
    }
    final ic = switch (tipo) {
      TipoCarga.exito => Icons.check_circle,
      TipoCarga.vacioMensajes => Icons.chat_bubble_outline,
      TipoCarga.vacioBusqueda => Icons.search,
      _ => Icons.list_alt,
    };
    return SizedBox(
      width: size,
      height: size,
      child: Icon(ic, size: size * .5, color: color ?? k.amber),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quieto = sinMovimiento(context);
    return Semantics(
      excludeSemantics: true,
      child: SizedBox(
        width: size,
        height: size,
        child: Lottie.asset(
          'assets/lottie/${tipo.archivo}.json',
          width: size,
          height: size,
          fit: BoxFit.contain,
          animate: !quieto,
          repeat: repetir ?? tipo.repite,
          controller: quieto
              ? AlwaysStoppedAnimation<double>(tipo.poster)
              : null,
          errorBuilder: (c, e, s) => _respaldo(c),
        ),
      ),
    );
  }
}

/// Frases que rotan con fundido mientras dura una espera larga.
class MensajesRotativos extends StatefulWidget {
  const MensajesRotativos(
    this.mensajes, {
    super.key,
    this.cada = const Duration(milliseconds: 2800),
    this.size = 15,
    this.color,
  });
  final List<String> mensajes;
  final Duration cada;
  final double size;
  final Color? color;
  @override
  State<MensajesRotativos> createState() => _MensajesRotativosState();
}

class _MensajesRotativosState extends State<MensajesRotativos> {
  int _i = 0;
  Timer? _t;

  @override
  void initState() {
    super.initState();
    if (widget.mensajes.length > 1) {
      _t = Timer.periodic(widget.cada, (_) {
        if (mounted) setState(() => _i = (_i + 1) % widget.mensajes.length);
      });
    }
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quieto = sinMovimiento(context);
    final k = kc(context);
    final texto = widget.mensajes[_i];
    return AnimatedSwitcher(
      duration: quieto ? Duration.zero : const Duration(milliseconds: 600),
      switchInCurve: const Interval(0.5, 1, curve: Curves.easeOut),
      switchOutCurve: const Interval(0.5, 1, curve: Curves.easeIn),
      transitionBuilder: (w, a) => FadeTransition(
        opacity: a,
        child: SlideTransition(
          position: Tween(
            begin: const Offset(0, .25),
            end: Offset.zero,
          ).animate(a),
          child: w,
        ),
      ),
      layoutBuilder: (cur, prev) =>
          Stack(alignment: Alignment.center, children: [...prev, ?cur]),
      child: Padding(
        key: ValueKey(texto),
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: T(
          texto,
          size: widget.size,
          w: FontWeight.w800,
          color: widget.color ?? k.mut,
          align: TextAlign.center,
        ),
      ),
    );
  }
}

/// Mensajes de la espera de cotizaciones.
const mensajesBusqueda = [
  'Buscando expertos cerca de ti…',
  'Revisando disponibilidad…',
  'Ya casi…',
];

/// Check con confeti sobre la pantalla actual (opinión publicada, trabajo
/// terminado...). No bloquea toques; se retira solo. Incluye háptica.
void exitoRapido(BuildContext context) {
  hapticoExito();
  final overlay = Overlay.maybeOf(context, rootOverlay: true);
  if (overlay == null) return;
  late final OverlayEntry e;
  e = OverlayEntry(
    builder: (c) => IgnorePointer(
      child: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: kc(c).surface.withValues(alpha: .94),
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(color: Color(0x33000000), blurRadius: 24),
            ],
          ),
          child: const CargaK(tipo: TipoCarga.exito, size: 170),
        ),
      ),
    ),
  );
  overlay.insert(e);
  Timer(const Duration(milliseconds: 1700), () {
    if (e.mounted) e.remove();
  });
}

/// Encabezado de éxito (Lottie con háptica al aparecer).
class ExitoK extends StatefulWidget {
  const ExitoK({super.key, this.size = 150});
  final double size;
  @override
  State<ExitoK> createState() => _ExitoKState();
}

class _ExitoKState extends State<ExitoK> {
  @override
  void initState() {
    super.initState();
    hapticoExito();
  }

  @override
  Widget build(BuildContext context) =>
      CargaK(tipo: TipoCarga.exito, size: widget.size);
}
