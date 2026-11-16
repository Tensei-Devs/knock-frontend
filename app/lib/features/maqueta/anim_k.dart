import 'dart:async';
import 'dart:io' show Platform;

import 'package:app/features/maqueta/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Capa de animaciones y microinteracciones de la maqueta. Todo es aditivo y
/// respeta «reducir movimiento» del sistema (`MediaQuery.disableAnimations`).

/// Bajo `flutter test` no hay animaciones infinitas (rompen `pumpAndSettle`).
final bool _enPruebas = Platform.environment['FLUTTER_TEST'] == 'true';

bool sinMovimiento(BuildContext c) => _enPruebas || (MediaQuery.maybeOf(c)?.disableAnimations ?? false);

// ---------------------------------------------------------------- háptica
void hapticoLigero() => unawaited(HapticFeedback.lightImpact().catchError((Object _) {}));
void hapticoExito() => unawaited(HapticFeedback.mediumImpact().catchError((Object _) {}));
void hapticoSeleccion() => unawaited(HapticFeedback.selectionClick().catchError((Object _) {}));

// ---------------------------------------------------------------- pulsación
/// Escala suave al tocar. No intercepta los gestos del hijo.
class Pulsa extends StatefulWidget {
  const Pulsa({super.key, required this.child, this.activo = true, this.escala = 0.97});
  final Widget child;
  final bool activo;
  final double escala;
  @override
  State<Pulsa> createState() => _PulsaState();
}

class _PulsaState extends State<Pulsa> {
  bool _abajo = false;
  void _set(bool v) {
    if (_abajo != v && mounted) setState(() => _abajo = v);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.activo || sinMovimiento(context)) return widget.child;
    return Listener(
      onPointerDown: (_) => _set(true),
      onPointerUp: (_) => _set(false),
      onPointerCancel: (_) => _set(false),
      child: AnimatedScale(
        scale: _abajo ? widget.escala : 1,
        duration: Duration(milliseconds: _abajo ? 80 : 160),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

// ---------------------------------------------------------------- entrada escalonada
/// Aparece con fade y un deslizamiento corto; [i] escalona (máx. 8 pasos).
class Aparece extends StatefulWidget {
  const Aparece({super.key, required this.child, this.i = 0});
  final Widget child;
  final int i;
  @override
  State<Aparece> createState() => _ApareceState();
}

class _ApareceState extends State<Aparece> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 360));
  Timer? _t;
  bool _inicio = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_inicio) return;
    _inicio = true;
    if (sinMovimiento(context)) {
      _c.value = 1;
      return;
    }
    final d = 45 * (widget.i > 8 ? 8 : widget.i);
    if (d == 0) {
      unawaited(_c.forward());
    } else {
      _t = Timer(Duration(milliseconds: d), () {
        if (mounted) unawaited(_c.forward());
      });
    }
  }

  @override
  void dispose() {
    _t?.cancel();
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final a = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);
    return FadeTransition(
      opacity: a,
      child: AnimatedBuilder(
        animation: a,
        builder: (c, ch) => Transform.translate(offset: Offset(0, 14 * (1 - a.value)), child: ch),
        child: widget.child,
      ),
    );
  }
}

/// Aplica [Aparece] escalonado a cada elemento de una lista de widgets.
List<Widget> escalona(List<Widget> l) => [for (var i = 0; i < l.length; i++) Aparece(i: i, child: l[i])];

// ---------------------------------------------------------------- transición de página
class TransicionKnock extends PageTransitionsBuilder {
  const TransicionKnock();
  @override
  Widget buildTransitions<R>(PageRoute<R> route, BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    if (sinMovimiento(context)) return child;
    final a = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic, reverseCurve: Curves.easeInCubic);
    return FadeTransition(
      opacity: a,
      child: SlideTransition(position: Tween(begin: const Offset(0.06, 0), end: Offset.zero).animate(a), child: child),
    );
  }
}

const pageTransitionsKnock = PageTransitionsTheme(builders: {
  TargetPlatform.android: TransicionKnock(),
  TargetPlatform.iOS: TransicionKnock(),
  TargetPlatform.fuchsia: TransicionKnock(),
  TargetPlatform.linux: TransicionKnock(),
  TargetPlatform.macOS: TransicionKnock(),
  TargetPlatform.windows: TransicionKnock(),
});

// ---------------------------------------------------------------- shimmer
/// Brillo que recorre a sus hijos (esqueletos). Sin movimiento: tono fijo.
class ShimmerK extends StatefulWidget {
  const ShimmerK({super.key, required this.child});
  final Widget child;
  @override
  State<ShimmerK> createState() => _ShimmerKState();
}

class _ShimmerKState extends State<ShimmerK> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
  bool _on = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final quieto = sinMovimiento(context);
    if (quieto && _on) {
      _c.stop();
      _on = false;
    } else if (!quieto && !_on) {
      unawaited(_c.repeat());
      _on = true;
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final k = kc(context);
    final base = k.line;
    final hi = k.dark ? const Color(0xFF4A423B) : const Color(0xFFF8F1E4);
    return AnimatedBuilder(
      animation: _c,
      child: widget.child,
      builder: (c, ch) => ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (r) {
          final x = -1.0 + 3.0 * _c.value;
          return LinearGradient(
            begin: Alignment(x - 1, -0.3),
            end: Alignment(x, 0.3),
            colors: [base, hi, base],
            stops: const [0.25, 0.5, 0.75],
          ).createShader(r);
        },
        child: ch,
      ),
    );
  }
}

/// Bloque de un esqueleto (el color lo pinta [ShimmerK]).
class BoneK extends StatelessWidget {
  const BoneK({super.key, this.w, this.h = 14, this.r = 8, this.circle = false});
  final double? w;
  final double h, r;
  final bool circle;
  @override
  Widget build(BuildContext context) => Container(
    width: circle ? h : w,
    height: h,
    decoration: BoxDecoration(color: kc(context).line, borderRadius: circle ? null : BorderRadius.circular(r), shape: circle ? BoxShape.circle : BoxShape.rectangle),
  );
}

/// Esqueleto de una lista de tarjetas (expertos, actividad, mensajes...).
class EsqueletoLista extends StatelessWidget {
  const EsqueletoLista({super.key, this.n = 4, this.fila = false});
  final int n;

  /// `true`: filas con avatar (mensajes, opiniones). `false`: tarjetas.
  final bool fila;
  @override
  Widget build(BuildContext context) {
    Widget item() => Container(
      padding: const EdgeInsets.all(16),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, spacing: 14, children: [
        BoneK(h: fila ? 48 : 56, circle: true),
        const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: 9, children: [
          BoneK(w: 150, h: 16),
          BoneK(h: 12),
          BoneK(w: 90, h: 12),
        ])),
      ]),
    );
    return Semantics(
      label: tr('Cargando'),
      child: ShimmerK(child: Column(spacing: 12, children: [for (var i = 0; i < n; i++) item()])),
    );
  }
}

/// Muestra un esqueleto unos instantes la primera vez que se abre [clave] en la
/// sesión y después el contenido. Con movimiento reducido salta el esqueleto.
final _vistas = <String>{};

class CargaInicial extends StatefulWidget {
  const CargaInicial({super.key, required this.clave, required this.esqueleto, required this.child, this.ms = 520});
  final String clave;
  final Widget esqueleto;
  final Widget child;
  final int ms;
  @override
  State<CargaInicial> createState() => _CargaInicialState();
}

class _CargaInicialState extends State<CargaInicial> {
  bool _listo = false;
  bool _init = false;
  Timer? _t;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_init) return;
    _init = true;
    if (_vistas.contains(widget.clave) || sinMovimiento(context)) {
      _listo = true;
    } else {
      _vistas.add(widget.clave);
      _t = Timer(Duration(milliseconds: widget.ms), () {
        if (mounted) setState(() => _listo = true);
      });
    }
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
    duration: const Duration(milliseconds: 250),
    child: _listo ? KeyedSubtree(key: const ValueKey('c'), child: widget.child) : KeyedSubtree(key: const ValueKey('e'), child: widget.esqueleto),
  );
}

// ---------------------------------------------------------------- insignia con pulso
/// Pulso breve cuando cambia [valor] (insignias de la barra inferior).
class PulsoInsignia extends StatefulWidget {
  const PulsoInsignia({super.key, required this.valor, required this.child});
  final int valor;
  final Widget child;
  @override
  State<PulsoInsignia> createState() => _PulsoInsigniaState();
}

class _PulsoInsigniaState extends State<PulsoInsignia> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 520));
  bool _primera = true;

  @override
  void initState() {
    super.initState();
    _c.value = 1;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_primera) {
      _primera = false;
      if (!sinMovimiento(context)) unawaited(_c.forward(from: 0));
    }
  }

  @override
  void didUpdateWidget(PulsoInsignia o) {
    super.didUpdateWidget(o);
    if (o.valor != widget.valor && !sinMovimiento(context)) unawaited(_c.forward(from: 0));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _c,
    child: widget.child,
    builder: (c, ch) {
      final t = _c.value;
      final s = t >= 1 ? 1.0 : 1 + 0.5 * (t < .35 ? Curves.easeOut.transform(t / .35) : 1 - Curves.easeInOut.transform((t - .35) / .65));
      return Transform.scale(scale: s, child: ch);
    },
  );
}

/// Esqueleto de Reputación: tarjeta de nivel, estadísticas y opiniones.
class EsqueletoReputacion extends StatelessWidget {
  const EsqueletoReputacion({super.key});
  @override
  Widget build(BuildContext context) => Semantics(
    label: tr('Cargando'),
    child: const ShimmerK(
      child: Column(spacing: 18, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        BoneK(h: 130, r: 22),
        Row(spacing: 8, children: [Expanded(child: BoneK(h: 62, r: 14)), Expanded(child: BoneK(h: 62, r: 14))]),
        Row(spacing: 8, children: [Expanded(child: BoneK(h: 62, r: 14)), Expanded(child: BoneK(h: 62, r: 14))]),
        EsqueletoLista(n: 2, fila: true),
      ]),
    ),
  );
}
