import 'dart:async';
import 'dart:io';

import 'package:app/features/maqueta/anim_k.dart';
import 'package:app/features/maqueta/carga_k.dart';
import 'package:app/features/maqueta/datos.dart';
import 'package:app/features/maqueta/en_dict.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ---------------------------------------------------------------- idioma

/// Idioma activo de los textos de la maqueta (los fuente están en español).
bool idiomaIngles = false;

/// Traduce un texto fuente en español con el diccionario de la maqueta
/// (`js/i18n/en.js`). Lo que no esté traducido se muestra en español.
const _extraEn = <String, String>{
  '¡Pronto estaremos cerca de ti!': 'We’ll be near you soon!',
  'Por el momento, Knock todavía no está disponible en tu zona, pero estamos trabajando para llegar pronto. Si quieres estar al tanto de nuestra llegada y conocer las novedades, síguenos en nuestras redes sociales.':
      'For now, Knock isn’t available in your area yet, but we’re working to get there soon. If you’d like to know when we arrive and hear our news, follow us on social media.',
  'Explorar de todos modos': 'Explore anyway',
  'Entendido': 'Got it',
  'Zonas disponibles': 'Available areas',
  'Knock está disponible en estas colonias de Tula de Allende. Elige una para explorar expertos de ejemplo.': 'Knock is available in these neighborhoods of Tula de Allende. Pick one to explore sample pros.',
  'Mostrar más o menos la lista': 'Show more or less of the list',
};

String tr(String s) {
  if (!idiomaIngles || s.trim().isEmpty) return s;
  final t = s.trim();
  String? hit(String x) {
    final d = _extraEn[x] ?? diccionarioEn[x];
    if (d != null) return d;
    for (final (re, rep) in patronesEn) {
      final m = re.firstMatch(x);
      if (m != null) {
        return rep.replaceAllMapped(RegExp(r'\$(\d)'), (g) => m.group(int.parse(g.group(1)!)) ?? '');
      }
    }
    return null;
  }

  final h = hit(t);
  if (h != null) return s.replaceFirst(t, h);
  if (t.contains(' · ')) {
    var changed = false;
    final parts = t.split(' · ').map((p) {
      final r = hit(p);
      if (r != null) changed = true;
      return r ?? p;
    }).toList();
    if (changed) return s.replaceFirst(t, parts.join(' · '));
  }
  return s;
}

// ---------------------------------------------------------------- colores

class KC {
  KC(this.dark);
  factory KC.of(BuildContext c) => KC(Theme.of(c).brightness == Brightness.dark);
  final bool dark;
  Color get ink => dark ? const Color(0xFFF6EEE3) : const Color(0xFF231A15);
  Color get ink2 => dark ? const Color(0xFFDCD0C2) : const Color(0xFF4A3C33);
  Color get mut => dark ? const Color(0xFFB5A798) : const Color(0xFF6B5D52);
  Color get navy => dark ? const Color(0xFF8FC4D6) : const Color(0xFF1C3A4C);
  Color get navyBg => dark ? const Color(0xFF2A5568) : const Color(0xFF1C3A4C);
  Color get navySoft => dark ? const Color(0xFF1D3440) : const Color(0xFFE1ECEF);
  Color get surface => dark ? const Color(0xFF1E1B18) : const Color(0xFFFFFFFF);
  Color get bg => dark ? const Color(0xFF14110F) : const Color(0xFFFBF5E9);
  Color get surface2 => dark ? const Color(0xFF26211D) : const Color(0xFFFBF5E9);
  Color get line => dark ? const Color(0xFF3A332D) : const Color(0xFFEDE3D2);
  Color get line2 => dark ? const Color(0xFF302A25) : const Color(0xFFEDE3D2);
  Color get amber => const Color(0xFFE9682D);
  Color get amberSoft => dark ? const Color(0xFF3B2415) : const Color(0xFFFDE8DC);
  Color get amberInk => dark ? const Color(0xFFFFC9A6) : const Color(0xFF8F3510);
  Color get green => dark ? const Color(0xFF10B981) : const Color(0xFF059669);
  Color get greenSoft => dark ? const Color(0xFF10342A) : const Color(0xFFD1FAE5);
  Color get greenInk => dark ? const Color(0xFF7BE3BD) : const Color(0xFF065F46);
  Color get red => dark ? const Color(0xFFF87171) : const Color(0xFFB91C1C);
  Color get redSoft => dark ? const Color(0xFF3A1717) : const Color(0xFFFEE2E2);
  Color get redInk => dark ? const Color(0xFFFECACA) : const Color(0xFF7F1D1D);
  Color get disabledBg => dark ? const Color(0xFF302A25) : const Color(0xFFEDE3D2);
  Color get disabledFg => const Color(0xFF948779);
}

KC kc(BuildContext c) => KC.of(c);

// ---------------------------------------------------------------- texto

TextStyle _ts(BuildContext c, double size, FontWeight w, {Color? color, double? height}) =>
    TextStyle(fontSize: size, fontWeight: w, color: color ?? kc(c).ink, height: height ?? 1.35, fontFamily: 'Nunito');

class T extends StatelessWidget {
  const T(this.s, {super.key, this.size = 16, this.w = FontWeight.w400, this.color, this.align, this.maxLines, this.italic = false});
  final String s;
  final double size;
  final FontWeight w;
  final Color? color;
  final TextAlign? align;
  final int? maxLines;
  final bool italic;
  @override
  Widget build(BuildContext context) => Text(
    tr(s),
    textAlign: align,
    maxLines: maxLines,
    overflow: maxLines != null ? TextOverflow.ellipsis : null,
    style: _ts(context, size, w, color: color).copyWith(fontStyle: italic ? FontStyle.italic : null),
  );
}

Widget h1(String s, {TextAlign? a}) => Builder(builder: (c) => T(s, size: 26, w: FontWeight.w900, align: a));
Widget h2(String s, {TextAlign? a}) => T(s, size: 20, w: FontWeight.w900, align: a);
Widget h3(String s, {TextAlign? a}) => T(s, size: 17, w: FontWeight.w900, align: a);
Widget bT(String s, {TextAlign? a, Color? color}) => T(s, w: FontWeight.w800, align: a, color: color);
Widget tT(String s, {TextAlign? a}) => T(s, align: a);

/// Texto atenuado y en negrita (`.s.mut.b`).
Widget sMut(String s, {TextAlign? a, double size = 14, Color? color}) =>
    Builder(builder: (c) => T(s, size: size, w: FontWeight.w700, color: color ?? kc(c).mut, align: a));
Widget mutT(String s, {TextAlign? a}) => Builder(builder: (c) => T(s, color: kc(c).mut, align: a));
Widget labT(String s) => T(s, size: 15, w: FontWeight.w900);

// ---------------------------------------------------------------- gaps

const g4 = SizedBox(height: 4, width: 4);
const g6 = SizedBox(height: 6, width: 6);
const g8 = SizedBox(height: 8, width: 8);
const g10 = SizedBox(height: 10, width: 10);
const g12 = SizedBox(height: 12, width: 12);
const g14 = SizedBox(height: 14, width: 14);
const g16 = SizedBox(height: 16, width: 16);
const g20 = SizedBox(height: 20, width: 20);

Widget stack(List<Widget> c, {double gap = 16, CrossAxisAlignment ca = CrossAxisAlignment.stretch}) =>
    Column(crossAxisAlignment: ca, mainAxisSize: MainAxisSize.min, spacing: gap, children: c);

Widget rowW(List<Widget> c, {double gap = 12, CrossAxisAlignment ca = CrossAxisAlignment.center, MainAxisAlignment ma = MainAxisAlignment.start}) =>
    Row(crossAxisAlignment: ca, mainAxisAlignment: ma, spacing: gap, children: c);

// ---------------------------------------------------------------- iconos

/// Iconos de la maqueta mapeados a Material.
IconData icn(String n) => switch (n) {
  'home' => Icons.home_outlined,
  'search' => Icons.search,
  'jobs' => Icons.work_outline,
  'chat' => Icons.chat_bubble_outline,
  'user' => Icons.person_outline,
  'back' => Icons.chevron_left,
  'chev' => Icons.chevron_right,
  'down' => Icons.expand_more,
  'up' => Icons.expand_less,
  'arrow' => Icons.arrow_forward,
  'car' => Icons.directions_car_outlined,
  'drop' => Icons.water_drop_outlined,
  'bolt' => Icons.bolt,
  'shield' => Icons.verified_user_outlined,
  'shieldo' => Icons.shield_outlined,
  'star' => Icons.star_border,
  'pin' => Icons.place_outlined,
  'clock' => Icons.schedule,
  'cal' => Icons.calendar_today_outlined,
  'heart' => Icons.favorite_border,
  'camera' => Icons.photo_camera_outlined,
  'phone' => Icons.phone_outlined,
  'bell' => Icons.notifications_none,
  'check' => Icons.check,
  'x' => Icons.close,
  'map' => Icons.map_outlined,
  'list' => Icons.format_list_bulleted,
  'filter' => Icons.tune,
  'plus' => Icons.add,
  'minus' => Icons.remove,
  'locate' => Icons.my_location,
  'help' => Icons.help_outline,
  'share' => Icons.ios_share,
  'flag' => Icons.flag_outlined,
  'send' => Icons.send,
  'more' => Icons.more_vert,
  'gear' => Icons.settings_outlined,
  'trash' => Icons.delete_outline,
  'doc' => Icons.description_outlined,
  'wifi' => Icons.wifi_off,
  'eye' => Icons.visibility_outlined,
  'house' => Icons.house_outlined,
  'store' => Icons.storefront_outlined,
  'lock' => Icons.lock_outline,
  'idcard' => Icons.badge_outlined,
  'selfie' => Icons.face,
  'sparkle' => Icons.auto_awesome,
  'wrench' => Icons.build_outlined,
  'logout' => Icons.logout,
  'swap' => Icons.swap_horiz,
  'download' => Icons.file_download_outlined,
  'edit' => Icons.edit_outlined,
  'award' => Icons.workspace_premium_outlined,
  'play' => Icons.play_arrow,
  'sun' => Icons.light_mode_outlined,
  'moon' => Icons.dark_mode_outlined,
  'route' => Icons.alt_route,
  _ => Icons.circle_outlined,
};

// ---------------------------------------------------------------- botones

enum Bk { pri, sec, dark, danger, ghost }

class BtnK extends StatelessWidget {
  const BtnK(this.label, this.onTap, {super.key, this.kind = Bk.pri, this.sm = false, this.icon, this.auto = false, this.enabled = true, this.busy = false});
  final String label;
  final VoidCallback? onTap;
  final Bk kind;
  final bool sm, auto, enabled, busy;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    final k = kc(context);
    final on = enabled && onTap != null && !busy;
    Color bg, fg;
    BorderSide? side;
    switch (kind) {
      case Bk.pri:
        bg = k.amber; fg = const Color(0xFF231A15);
      case Bk.sec:
        bg = k.surface; fg = k.navy; side = BorderSide(color: k.navy, width: 2);
      case Bk.dark:
        bg = k.navyBg; fg = Colors.white;
      case Bk.danger:
        bg = k.red; fg = Colors.white;
      case Bk.ghost:
        bg = Colors.transparent; fg = k.navy;
    }
    if (!on) {
      bg = kind == Bk.ghost ? Colors.transparent : k.disabledBg;
      fg = k.disabledFg;
      side = null;
    }
    final h = kind == Bk.ghost ? 48.0 : (sm ? 46.0 : 56.0);
    final child = Material(
      color: bg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(sm ? 23 : 28), side: side ?? BorderSide.none),
      child: InkWell(
        customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(sm ? 23 : 28)),
        onTap: on ? () {
          if (kind != Bk.ghost) hapticoLigero();
          onTap!();
        } : null,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: h),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: sm ? 16 : 22, vertical: 8),
            child: Row(
              mainAxisSize: auto ? MainAxisSize.min : MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8,
              children: [
                if (busy) SizedBox(width: sm ? 16 : 20, height: sm ? 16 : 20, child: CircularProgressIndicator(strokeWidth: 2.5, color: fg)) else if (icon != null) Icon(icn(icon!), size: sm ? 18 : 22, color: fg),
                Flexible(
                  child: Text(tr(label), textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w900, fontSize: sm ? 15 : 17, color: fg)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    return Pulsa(activo: on, child: child);
  }
}

class LinkK extends StatelessWidget {
  const LinkK(this.label, this.onTap, {super.key, this.size = 15});
  final String label;
  final VoidCallback onTap;
  final double size;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Text(tr(label), style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w800, fontSize: size, color: kc(context).navy, decoration: TextDecoration.underline)),
    ),
  );
}

// ---------------------------------------------------------------- componentes

class CardK extends StatelessWidget {
  const CardK({super.key, required this.child, this.onTap, this.pad = const EdgeInsets.all(16), this.outline});
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets pad;
  final Color? outline;
  @override
  Widget build(BuildContext context) {
    final k = kc(context);
    return Pulsa(activo: onTap != null, escala: 0.985, child: DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [BoxShadow(color: Color(0x0F1E3A5F), offset: Offset(0, 1), blurRadius: 3), BoxShadow(color: Color(0x0D1E3A5F), offset: Offset(0, 4), blurRadius: 14)],
      ),
      child: Material(
        color: k.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22), side: outline != null ? BorderSide(color: outline!, width: 2.5) : BorderSide.none),
        clipBehavior: Clip.antiAlias,
        child: InkWell(onTap: onTap, child: Padding(padding: pad, child: SizedBox(width: double.infinity, child: child))),
      ),
    ));
  }
}

class Pill extends StatelessWidget {
  const Pill(this.s, {super.key, this.kind = 'navy', this.icon, this.size = 13, this.bg, this.fg});
  final String s, kind;
  final String? icon;
  final double size;
  final Color? bg, fg;
  @override
  Widget build(BuildContext context) {
    final k = kc(context);
    final (b, f) = switch (kind) {
      'green' => (k.greenSoft, k.greenInk),
      'amber' => (k.amberSoft, k.amberInk),
      'gray' => (k.surface2, k.mut),
      'red' => (k.redSoft, k.red),
      _ => (k.navySoft, k.navy),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg ?? b, borderRadius: BorderRadius.circular(999)),
      child: Row(mainAxisSize: MainAxisSize.min, spacing: 5, children: [
        if (icon != null) Icon(icn(icon!), size: 15, color: fg ?? f),
        Text(tr(s), style: TextStyle(fontFamily: 'Nunito', fontSize: size, fontWeight: FontWeight.w900, color: fg ?? f)),
      ]),
    );
  }
}

class NoteK extends StatelessWidget {
  const NoteK(this.kind, this.icon, this.text, {super.key, this.child, this.bold});
  final String kind, icon;
  final String text;
  final Widget? child;
  final String? bold;
  @override
  Widget build(BuildContext context) {
    final k = kc(context);
    final (b, f) = switch (kind) {
      'green' => (k.greenSoft, k.greenInk),
      'amber' => (k.amberSoft, k.amberInk),
      'red' => (k.redSoft, k.redInk),
      _ => (k.navySoft, k.navy),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(color: b, borderRadius: BorderRadius.circular(16)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, spacing: 12, children: [
        Padding(padding: const EdgeInsets.only(top: 1), child: Icon(icn(icon), size: 22, color: f)),
        Expanded(child: child ?? rich(text, size: 15, color: f)),
      ]),
    );
  }
}

/// Texto con **negritas** (en la maqueta, etiquetas `<b>`).
Widget rich(String s, {double size = 16, Color? color, FontWeight w = FontWeight.w700, TextAlign? align}) => Builder(builder: (c) {
  final base = _ts(c, size, w, color: color);
  final src = tr(s);
  final parts = src.split('**');
  return Text.rich(
    TextSpan(children: [for (var i = 0; i < parts.length; i++) TextSpan(text: parts[i], style: i.isOdd ? base.copyWith(fontWeight: FontWeight.w900) : base)]),
    textAlign: align,
    style: base,
  );
});

class Av extends StatelessWidget {
  const Av({super.key, required this.ini, required this.color, this.size = 52, this.verified = false, this.photo});
  final String ini;
  final Color color;
  final double size;
  final bool verified;
  final String? photo;
  factory Av.prov(Prov p, {double size = 52, bool verified = true}) => Av(ini: p.ini, color: p.color, size: size, verified: verified && p.ver, photo: p.photoPath);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(clipBehavior: Clip.none, children: [
        Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle, image: photo != null ? DecorationImage(image: FileImage(File(photo!)), fit: BoxFit.cover) : null),
          child: photo != null ? null : Text(ini, style: TextStyle(fontFamily: 'Nunito', fontSize: size * .34, fontWeight: FontWeight.w900, color: Colors.white)),
        ),
        if (verified)
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(color: kc(context).green, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2.5)),
              child: const Icon(Icons.check, size: 12, color: Colors.white),
            ),
          ),
      ]),
    );
  }
}

class Stars extends StatelessWidget {
  const Stars(this.n, {super.key, this.size = 16});
  final int n;
  final double size;
  @override
  Widget build(BuildContext context) {
    final k = kc(context);
    return Semantics(
      label: '$n de 5 estrellas',
      child: Row(mainAxisSize: MainAxisSize.min, children: [for (var i = 1; i <= 5; i++) Text('★', style: TextStyle(fontSize: size, color: i <= n ? k.amber : k.line2))]),
    );
  }
}

Widget rateW(Prov o, {double size = 14}) => Builder(builder: (c) {
  final k = kc(c);
  if (o.n == 0) return T('Nuevo', size: size, w: FontWeight.w700, color: k.mut);
  return Row(mainAxisSize: MainAxisSize.min, children: [
    Text('★ ', style: TextStyle(fontSize: size, color: k.amber)),
    Text(o.rate.toStringAsFixed(1), style: TextStyle(fontFamily: 'Nunito', fontSize: size, fontWeight: FontWeight.w800, color: k.ink)),
  ]);
});

String whereTxt(Prov o) => o.taller ? 'Vas a su taller' : 'Va a tu casa';

class ChipK extends StatelessWidget {
  const ChipK(this.label, {super.key, this.on = false, this.onTap, this.icon, this.work = false});
  final String label;
  final bool on, work;
  final VoidCallback? onTap;
  final String? icon;
  @override
  Widget build(BuildContext context) {
    final k = kc(context);
    final Color bg = on ? (work ? k.amber : k.navyBg) : k.surface;
    final Color fg = on ? (work ? const Color(0xFF231A15) : Colors.white) : (work ? k.amberInk : k.ink);
    final Color bd = on ? (work ? k.amber : k.navy) : (work ? k.amber : k.line);
    return Pulsa(activo: onTap != null, child: Material(
      color: bg,
      shape: StadiumBorder(side: BorderSide(color: bd, width: 1.5)),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(mainAxisSize: MainAxisSize.min, spacing: 6, children: [
              if (icon != null) Icon(icn(icon!), size: 18, color: fg),
              Text(tr(label), style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w800, fontSize: 15, color: fg)),
            ]),
          ),
        ),
      ),
    ));
  }
}

Widget chipsWrap(List<Widget> c) => Wrap(spacing: 8, runSpacing: 8, children: c);
Widget chipsScroll(List<Widget> c, {double pad = 20}) => SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  padding: EdgeInsets.symmetric(horizontal: pad, vertical: 2),
  child: Row(spacing: 8, children: c),
);

class ChoiceK extends StatelessWidget {
  const ChoiceK({super.key, required this.on, required this.onTap, required this.title, this.sub, this.leading, this.check = false, this.trailing, this.minH = 72, this.body});
  final Widget? body;
  final bool on, check;
  final VoidCallback onTap;
  final String title;
  final String? sub;
  final Widget? leading, trailing;
  final double minH;
  @override
  Widget build(BuildContext context) {
    final k = kc(context);
    Widget mark;
    if (check) {
      mark = Container(width: 26, height: 26, decoration: BoxDecoration(color: on ? k.navyBg : Colors.transparent, borderRadius: BorderRadius.circular(8), border: Border.all(color: on ? k.navy : k.mut, width: 2)), child: on ? const Icon(Icons.check, size: 18, color: Colors.white) : null);
    } else {
      mark = Container(width: 26, height: 26, alignment: Alignment.center, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: on ? k.navy : k.mut, width: 2)), child: on ? Container(width: 12, height: 12, decoration: BoxDecoration(shape: BoxShape.circle, color: k.navyBg)) : null);
    }
    return Pulsa(escala: 0.985, child: Material(
      color: k.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: on ? k.navy : k.line, width: 2)),
      child: InkWell(
        customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onTap: () {
          hapticoSeleccion();
          onTap();
        },
        child: Container(
          constraints: BoxConstraints(minHeight: minH),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: on ? BoxDecoration(color: k.surface2, borderRadius: BorderRadius.circular(14)) : null,
          child: Row(spacing: 14, children: [
            if (check) mark,
            if (leading != null) leading!,
            if (!check && leading == null && trailing == null) mark,
            Expanded(child: body ?? Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: 2, children: [T(title, w: FontWeight.w900), if (sub != null) sMut(sub!)])),
            if (trailing != null) trailing!,
            if (leading != null && !check && trailing == null) mark,
          ]),
        ),
      ),
));
  }
}

class GroupK extends StatelessWidget {
  const GroupK(this.rows, {super.key});
  final List<Widget> rows;
  @override
  Widget build(BuildContext context) {
    final k = kc(context);
    return Material(
      color: k.surface,
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: Column(children: [for (var i = 0; i < rows.length; i++) ...[if (i > 0) Divider(height: 1, thickness: 1, color: k.line2), rows[i]]]),
    );
  }
}

class LiK extends StatelessWidget {
  const LiK(this.icon, this.label, {super.key, this.sub, this.onTap, this.extra, this.iconBg, this.iconFg, this.chev = true});
  final String icon, label;
  final String? sub;
  final VoidCallback? onTap;
  final Widget? extra;
  final Color? iconBg, iconFg;
  final bool chev;
  @override
  Widget build(BuildContext context) {
    final k = kc(context);
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 62),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(spacing: 14, children: [
            Container(width: 40, height: 40, decoration: BoxDecoration(color: iconBg ?? k.navySoft, borderRadius: BorderRadius.circular(12)), child: Icon(icn(icon), color: iconFg ?? k.navy)),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: 2, children: [T(label, w: FontWeight.w800), if (sub != null && sub!.isNotEmpty) sMut(sub!, size: 13.5)])),
            if (extra != null) extra!,
            if (onTap != null && chev) Icon(Icons.chevron_right, color: const Color(0xFFA39789)),
          ]),
        ),
      ),
    );
  }
}

/// Estilo para filas de peligro (`background:var(--red-soft);color:var(--red)`).
LiK liDanger(BuildContext c, String icon, String label, VoidCallback onTap, {String? sub}) =>
    LiK(icon, label, sub: sub, onTap: onTap, iconBg: kc(c).redSoft, iconFg: kc(c).red);

class FoldK extends StatefulWidget {
  const FoldK({super.key, required this.k, required this.title, this.summary, required this.child, this.open0 = false, this.icon});
  final String k, title;
  final String? summary, icon;
  final Widget child;
  final bool open0;
  @override
  State<FoldK> createState() => _FoldKState();
}

class _FoldKState extends State<FoldK> {
  @override
  Widget build(BuildContext context) {
    final k = kc(context);
    final open = maq.fold[widget.k] ?? widget.open0;
    return CardK(
      pad: EdgeInsets.zero,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        InkWell(
          onTap: () => setState(() => maq.fold[widget.k] = !open),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 64),
            child: Padding(
              padding: const EdgeInsets.all(14).copyWith(left: 16, right: 16),
              child: Row(spacing: 12, children: [
                if (widget.icon != null) Container(width: 40, height: 40, decoration: BoxDecoration(color: k.navySoft, borderRadius: BorderRadius.circular(12)), child: Icon(icn(widget.icon!), color: k.navy)),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: 2, children: [
                  T(widget.title, size: 17, w: FontWeight.w900),
                  if (widget.summary != null) Text(tr(widget.summary!), maxLines: open ? 3 : 1, overflow: TextOverflow.ellipsis, style: _ts(context, 14, FontWeight.w700, color: k.mut)),
                ])),
                AnimatedRotation(turns: open ? .5 : 0, duration: const Duration(milliseconds: 150), child: Icon(Icons.expand_more, color: k.mut)),
              ]),
            ),
          ),
        ),
        if (open) Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), child: widget.child),
      ]),
    );
  }
}

class Sw extends StatelessWidget {
  const Sw({super.key, required this.on, this.onTap});
  final bool on;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Opacity(
      opacity: onTap == null ? .55 : 1,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 56,
        height: 32,
        padding: const EdgeInsets.all(3),
        alignment: on ? Alignment.centerRight : Alignment.centerLeft,
        decoration: BoxDecoration(color: on ? kc(context).green : const Color(0xFFCFC4B4), borderRadius: BorderRadius.circular(16)),
        child: Container(width: 26, height: 26, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Color(0x40000000), blurRadius: 3, offset: Offset(0, 1))])),
      ),
    ),
  );
}

class Prog extends StatelessWidget {
  const Prog(this.step, this.total, {super.key});
  final int step, total;
  @override
  Widget build(BuildContext context) {
    final k = kc(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: 8, children: [
      T('Paso $step de $total', size: 14, w: FontWeight.w800, color: k.mut),
      ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: step / total, minHeight: 8, backgroundColor: k.line2, color: k.navyBg)),
    ]);
  }
}

/// Estado vacío (`.empty`).
Widget emptyK(String icon, String title, [String? text, Widget? action]) => Builder(builder: (c) {
  final k = kc(c);
  return Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 28),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 340),
        child: Column(mainAxisSize: MainAxisSize.min, spacing: 14, children: [
          switch (icon) {
            'jobs' => const CargaK(tipo: TipoCarga.vacioActividad, size: 130),
            'chat' => const CargaK(tipo: TipoCarga.vacioMensajes, size: 130),
            'search' || 'filter' => const CargaK(tipo: TipoCarga.vacioBusqueda, size: 130),
            _ => Container(width: 96, height: 96, decoration: BoxDecoration(color: k.navySoft, shape: BoxShape.circle), child: Icon(icn(icon), size: 44, color: k.navy)),
          },
          h2(title, a: TextAlign.center),
          if (text != null) mutT(text, a: TextAlign.center),
          ?action,
        ]),
      ),
    ),
  );
});

/// Estado a pantalla completa (`.state`).
Widget stateK(IconData icon, Color bg, Color fg, String title, List<Widget> more) => Center(
  child: SingleChildScrollView(
    padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 28),
    child: Column(mainAxisSize: MainAxisSize.min, spacing: 14, children: [
      Container(width: 110, height: 110, decoration: BoxDecoration(color: bg, shape: BoxShape.circle), child: Icon(icon, size: 52, color: fg)),
      h1(title, a: TextAlign.center),
      ...more,
    ]),
  ),
);

class FieldK extends StatelessWidget {
  const FieldK({super.key, required this.label, required this.c, this.hint, this.help, this.err, this.keyboard, this.maxLen, this.lines = 1, this.opt = false, this.onChanged, this.onSubmit, this.prefix, this.center = false, this.autofocus = false, this.focus});
  final String label;
  final TextEditingController c;
  final String? hint, help, err;
  final TextInputType? keyboard;
  final int? maxLen, lines;
  final bool opt, center, autofocus;
  final ValueChanged<String>? onChanged, onSubmit;
  final Widget? prefix;
  final FocusNode? focus;
  @override
  Widget build(BuildContext context) {
    final k = kc(context);
    final style = center ? _ts(context, 26, FontWeight.w900) : _ts(context, 17, FontWeight.w700);
    final field = TextField(
      controller: c,
      focusNode: focus,
      autofocus: autofocus,
      keyboardType: keyboard,
      maxLength: maxLen,
      maxLines: lines,
      minLines: lines != null && lines! > 1 ? lines : 1,
      onChanged: onChanged,
      onSubmitted: onSubmit,
      textAlign: center ? TextAlign.center : TextAlign.start,
      style: center ? style.copyWith(letterSpacing: 10) : style,
      decoration: InputDecoration(
        counterText: '',
        hintText: hint == null ? null : tr(hint!),
        hintStyle: _ts(context, center ? 26 : 17, FontWeight.w700, color: k.mut.withAlpha(150)),
        filled: true,
        fillColor: k.surface,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: lines != null && lines! > 1 ? 14 : 16),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: err != null ? k.red : k.line, width: 2)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: err != null ? k.red : k.navy, width: 2)),
      ),
    );
    return Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: 6, children: [
      if (label.isNotEmpty)
        Row(spacing: 6, children: [T(label, size: 15, w: FontWeight.w900), if (opt) T('(opcional)', size: 15, w: FontWeight.w700, color: k.mut)]),
      prefix == null ? field : Row(spacing: 8, children: [prefix!, Expanded(child: field)]),
      if (err != null) Row(spacing: 6, children: [Icon(Icons.close, size: 16, color: k.red), Expanded(child: T(err!, size: 14, w: FontWeight.w800, color: k.red))]),
      if (help != null) sMut(help!),
    ]);
  }
}

class PhoneCc extends StatelessWidget {
  const PhoneCc({super.key});
  @override
  Widget build(BuildContext context) {
    final k = kc(context);
    return Container(height: 56, padding: const EdgeInsets.symmetric(horizontal: 14), alignment: Alignment.center, decoration: BoxDecoration(color: k.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: k.line, width: 2)), child: T('+52', size: 17, w: FontWeight.w800));
  }
}

String fmtPhone(String d) {
  final s = d.replaceAll(RegExp(r'\D'), '');
  if (s.length != 10) return d;
  return '${s.substring(0, 3)} ${s.substring(3, 6)} ${s.substring(6)}';
}

String digits(String s) => s.replaceAll(RegExp(r'\D'), '');

// ---------------------------------------------------------------- foto

class PhotoTile extends StatelessWidget {
  const PhotoTile({super.key, this.label, this.color, this.path, this.onRemove, this.size = 104});
  final String? label, path;
  final Color? color;
  final VoidCallback? onRemove;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.bottomLeft,
      padding: path == null ? const EdgeInsets.all(8) : null,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: path == null ? LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [color ?? const Color(0xFF5B7FA6), (color ?? const Color(0xFF5B7FA6)).withAlpha(0xCC)]) : null,
        image: path != null ? DecorationImage(image: FileImage(File(path!)), fit: BoxFit.cover) : null,
      ),
      child: Stack(children: [
        if (path == null && label != null) Align(alignment: Alignment.bottomLeft, child: Text(tr(label!), style: const TextStyle(fontFamily: 'Nunito', color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13))),
        if (onRemove != null)
          Positioned(top: path == null ? 0 : 6, right: path == null ? 0 : 6, child: GestureDetector(onTap: onRemove, child: Container(width: 28, height: 28, decoration: const BoxDecoration(color: Color(0x73000000), shape: BoxShape.circle), child: const Icon(Icons.close, size: 16, color: Colors.white)))),
      ]),
    );
  }
}

class AddPhoto extends StatelessWidget {
  const AddPhoto({super.key, required this.onTap, this.size = 104});
  final VoidCallback onTap;
  final double size;
  @override
  Widget build(BuildContext context) {
    final k = kc(context);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: k.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFBFB3A2), width: 2)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, spacing: 4, children: [Icon(Icons.photo_camera_outlined, size: 28, color: k.navy), T('Agregar', size: 14, color: k.navy)]),
      ),
    );
  }
}

// ---------------------------------------------------------------- pantalla

/// Estructura de una pantalla de la maqueta: encabezado, cuerpo, pie y CTA.
class Pg extends StatelessWidget {
  const Pg({super.key, this.title = '', this.sub, this.back = true, this.backLabel, this.right, this.body, this.cta, this.foot, this.top, this.fab, this.scroll = true, this.pad = true, this.onBack, this.noHeader = false, this.brand = false, this.padBottom = 24});
  final String title;
  final String? sub, backLabel;
  final bool back, scroll, pad, noHeader, brand;
  final Widget? right, body, cta, foot, top, fab;
  final VoidCallback? onBack;
  final double padBottom;

  @override
  Widget build(BuildContext context) {
    final k = kc(context);
    final header = noHeader
        ? null
        : Container(
            constraints: const BoxConstraints(minHeight: 60),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: k.surface, border: Border(bottom: BorderSide(color: k.line2))),
            child: Row(spacing: 8, children: [
              if (back)
                InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: onBack ?? () => context.canPop() ? context.pop() : null,
                  child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.chevron_left, color: k.navy, size: 28), T(backLabel ?? 'Atrás', size: 15, w: FontWeight.w800, color: k.navy)])),
                ),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (title.isNotEmpty) T(title, size: 18, w: FontWeight.w900, maxLines: 1),
                if (sub != null) T(sub!, size: 13, w: FontWeight.w700, color: k.mut, maxLines: 1),
              ])),
              ?right,
            ]),
          );
    return Scaffold(
      backgroundColor: k.bg,
      body: SafeArea(
        bottom: false,
        child: Stack(children: [
          Column(children: [
            ?header,
            ?top,
            Expanded(child: scroll ? SingleChildScrollView(padding: pad ? EdgeInsets.fromLTRB(20, 20, 20, padBottom) : EdgeInsets.zero, child: body) : (body ?? const SizedBox())),
            ?foot,
            if (cta != null)
              Container(
                padding: EdgeInsets.fromLTRB(20, 12, 20, 14 + MediaQuery.of(context).padding.bottom),
                decoration: BoxDecoration(color: k.surface, border: Border(top: BorderSide(color: k.line2))),
                child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, spacing: 8, children: [cta!]),
              ),
          ]),
          ?fab,
        ]),
      ),
    );
  }
}

/// Ayuda bajo un botón deshabilitado (`.cta .help`).
Widget helpT(String s) => sMut(s, a: TextAlign.center, size: 13);

Widget ctaCol(List<Widget> c) => Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, spacing: 8, children: c);

/// Vuelve a construir cuando cambia el estado simulado.
class MaqBuilder extends StatelessWidget {
  const MaqBuilder(this.builder, {super.key});
  final Widget Function(BuildContext) builder;
  @override
  Widget build(BuildContext context) => ListenableBuilder(listenable: maq, builder: (c, _) => builder(c));
}

// ---------------------------------------------------------------- hojas y avisos

Future<R?> hoja<R>(BuildContext context, Widget Function(BuildContext, StateSetter) build, {bool scroll = true}) {
  final k = kc(context);
  return showModalBottomSheet<R>(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: k.surface,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
    builder: (ctx) => ListenableBuilder(
      listenable: maq,
      builder: (ctx, _) => StatefulBuilder(
        builder: (ctx, set) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 22 + MediaQuery.of(ctx).padding.bottom),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, spacing: 16, children: [
              Center(child: Container(width: 44, height: 5, decoration: BoxDecoration(color: k.line, borderRadius: BorderRadius.circular(3)))),
              build(ctx, set),
            ]),
          ),
        ),
      ),
    ),
  );
}

Widget sheetH(BuildContext c, String title, {bool big = false}) => Row(crossAxisAlignment: CrossAxisAlignment.start, spacing: 10, children: [
  Expanded(child: big ? h1(title) : h2(title)),
  InkWell(customBorder: const CircleBorder(), onTap: () => Navigator.of(c).pop(), child: Container(width: 44, height: 44, decoration: BoxDecoration(color: kc(c).surface2, shape: BoxShape.circle), child: Icon(Icons.close, color: kc(c).ink))),
]);

/// Aviso emergente (`toast`) de la maqueta.
void toastK(BuildContext? context, String msg, {String? accion, VoidCallback? alAccion, ScaffoldMessengerState? messenger}) {
  final m = messenger ?? ScaffoldMessenger.of(context!);
  m.hideCurrentSnackBar();
  m.showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: const Color(0xFF231A15),
    margin: const EdgeInsets.fromLTRB(16, 0, 16, 90),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Color(0x1FFFFFFF))),
    duration: const Duration(milliseconds: 3600),
    content: Row(spacing: 12, children: [
      const Icon(Icons.check, color: Color(0xFF6EE7B7)),
      Expanded(child: Text(tr(msg), style: const TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w800, fontSize: 15, color: Colors.white))),
      if (accion != null) TextButton(onPressed: () { m.hideCurrentSnackBar(); alAccion?.call(); }, child: Text(tr(accion), style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w900, fontSize: 15, color: Color(0xFFE9682D)))),
    ]),
  ));
}

/// Escucha los avisos del estado simulado y los muestra.
class AvisosHost extends StatefulWidget {
  const AvisosHost({super.key, required this.child, required this.messengerKey});
  final Widget child;
  final GlobalKey<ScaffoldMessengerState> messengerKey;
  @override
  State<AvisosHost> createState() => _AvisosHostState();
}

class _AvisosHostState extends State<AvisosHost> {
  StreamSubscription<AvisoToast>? _s;
  @override
  void initState() {
    super.initState();
    _s = maq.avisos.stream.listen((a) {
      final m = widget.messengerKey.currentState;
      if (m == null) return;
      toastK(null, a.msg, accion: a.accion, alAccion: a.alAccion, messenger: m);
    });
  }

  @override
  void dispose() {
    _s?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
