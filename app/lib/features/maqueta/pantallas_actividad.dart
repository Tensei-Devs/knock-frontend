import 'dart:async';

import 'package:app/features/maqueta/datos.dart';
import 'package:app/features/maqueta/anim_k.dart';
import 'package:app/features/maqueta/carga_k.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/nav.dart';
import 'package:app/features/maqueta/pantallas_buscar.dart';
import 'package:app/features/maqueta/pantallas_solicitud.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

String _catIcon(String id) => id == 'mec'
    ? 'car'
    : id == 'plo'
    ? 'drop'
    : 'bolt';

/// Logo de Knock (icono y letras).
class Marca extends StatelessWidget {
  const Marca({super.key});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    spacing: 8,
    children: [
      SvgPicture.asset('assets/img/knock-icono.svg', height: 32),
      SvgPicture.asset(
        'assets/img/knock-letras.svg',
        height: 20,
        colorFilter: kc(context).dark
            ? const ColorFilter.mode(Color(0xFFF6EEE3), BlendMode.srcIn)
            : null,
      ),
    ],
  );
}

/// Barra superior de las pestañas: el logo y, como en la maqueta (`h1.sr`),
/// el título de la pestaña oculto a la vista pero disponible para lectores
/// de pantalla.
class BarraMarcaK extends StatelessWidget {
  const BarraMarcaK({super.key, required this.title, this.right});
  final String title;
  final Widget? right;
  @override
  Widget build(BuildContext context) {
    final k = kc(context);
    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: k.surface,
        border: Border(bottom: BorderSide(color: k.line2)),
      ),
      child: AppBar(
        automaticallyImplyLeading: false,
        primary: false,
        toolbarHeight: 40,
        titleSpacing: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                const Marca(),
                Semantics(
                  header: true,
                  child: Opacity(
                    opacity: 0,
                    child: Text(tr(title), style: const TextStyle(fontSize: 1)),
                  ),
                ),
              ],
            ),
            ?right,
          ],
        ),
        actions: const [],
      ),
    );
  }
}

/// Pantalla de pestaña: barra con la marca, cuerpo y globo opcional.
class PgTab extends StatelessWidget {
  const PgTab({
    super.key,
    required this.title,
    required this.body,
    this.fab,
    this.top,
    this.right,
    this.scroll = true,
    this.flush = false,
  });
  final bool flush;
  final String title;
  final Widget body;
  final Widget? fab, top, right;
  final bool scroll;
  @override
  Widget build(BuildContext context) {
    final k = kc(context);
    return Scaffold(
      backgroundColor: k.bg,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                BarraMarcaK(title: title, right: right),
                ?top,
                Expanded(
                  child: scroll
                      ? SingleChildScrollView(
                          padding: flush
                              ? const EdgeInsets.only(bottom: 90)
                              : const EdgeInsets.fromLTRB(20, 20, 20, 90),
                          child: body,
                        )
                      : body,
                ),
              ],
            ),
            ?fab,
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------ actividad

class ActividadMaqueta extends StatelessWidget {
  const ActividadMaqueta({super.key});

  @override
  Widget build(BuildContext context) => MaqBuilder((context) {
    final jobs = [
      ...maq.jobs.where(
        (j) => j.status != 'terminado' && j.status != 'cancelado',
      ),
      ...maq.jobs.where(
        (j) => j.status == 'terminado' || j.status == 'cancelado',
      ),
    ];
    var firstPri = true;
    final cards = <Widget>[];
    for (final j in jobs) {
      cards.add(jobCard(context, j, firstPri));
      if (j.status == 'cotizando') firstPri = false;
    }
    return PgTab(
      title: 'Actividad',
      fab: msgFab(context),
      body: jobs.isNotEmpty
          ? CargaInicial(
              clave: 'actividad',
              esqueleto: const EsqueletoLista(n: 3),
              child: stack(escalona(cards), gap: 12),
            )
          : SizedBox(
              height: 420,
              child: emptyK(
                'jobs',
                'Aún no tienes actividad',
                'Cuando pidas una cotización, aquí verás en qué va cada una.',
                BtnK(
                  'Pedir una cotización',
                  () => context.go('/inicio'),
                  auto: true,
                ),
              ),
            ),
    );
  });
}

/// Globo flotante de mensajes (abajo a la derecha, con contador).
Widget msgFab(BuildContext context) {
  if (maq.convIds().isEmpty) return const SizedBox();
  final k = kc(context);
  final u = maq.unreadCount;
  return Positioned(
    right: 16,
    bottom: 16,
    child: Semantics(
      label: '${tr('Mensajes')}${u > 0 ? ', $u ${tr('sin leer')}' : ''}',
      button: true,
      child: GestureDetector(
        onTap: () => context.push(RM.mensajes),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: k.navyBg,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x520F1E32),
                    blurRadius: 20,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                color: Colors.white,
                size: 26,
              ),
            ),
            if (u > 0)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  constraints: const BoxConstraints(minWidth: 22),
                  height: 22,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: k.red,
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(color: k.surface, width: 2),
                  ),
                  child: Text(
                    '$u',
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

Widget jobCard(BuildContext context, Job j, bool pri) {
  final k = kc(context);
  final c = cats[j.cat]!;
  final o = j.pid != null ? provs[j.pid] : null;
  Widget pill = const SizedBox();
  Widget det = const SizedBox();
  Widget action = const SizedBox();
  const day = Duration(days: 1);
  switch (j.status) {
    case 'enviada':
      pill = const Pill('Esperando cotizaciones', kind: 'amber', icon: 'clock');
      det = sMut('Te avisamos en cuanto lleguen.');
      action = stack([
        widenBlock(context, j),
        BtnK(
          'Ver solicitud',
          () => context.push(RM.comparar(j.id)),
          kind: Bk.sec,
          sm: true,
        ),
      ], gap: 10);
    case 'cotizando':
      pill = Pill(
        '${j.quotes.length} cotizaciones listas',
        kind: 'amber',
        icon: 'bell',
      );
      det = Row(
        children: [
          for (var i = 0; i < j.quotes.length; i++)
            Transform.translate(
              offset: Offset(-10.0 * i, 0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Av.prov(
                  provs[j.quotes[i].pid]!,
                  size: 34,
                  verified: false,
                ),
              ),
            ),
        ],
      );
      action = BtnK(
        'Ver y elegir',
        () => context.push(RM.comparar(j.id)),
        kind: pri ? Bk.pri : Bk.sec,
        sm: true,
      );
    case 'visita':
      pill = Pill(
        j.diag ? 'Visita para cotizar' : 'Visita confirmada',
        kind: 'green',
        icon: 'check',
      );
      det = sMut('${j.when} · ${j.time} · ${o!.name}');
      action = stack([
        adjustCard(context, j),
        BtnK(
          'Ver visita y código',
          () => context.push(RM.visita(j.id)),
          kind: Bk.sec,
          sm: true,
        ),
      ], gap: 10);
    case 'cita':
      pill = const Pill('Cita confirmada', kind: 'green', icon: 'check');
      det = sMut('${j.when} · ${j.time} · ${o!.name}');
      action = BtnK(
        'Ver cita y cómo llegar',
        () => context.push(RM.cita(j.id)),
        kind: Bk.sec,
        sm: true,
      );
    case 'cancelado':
      pill = const Pill('Cancelado', kind: 'gray');
      det = sMut(
        j.cancelNote.isEmpty
            ? 'Cancelado al pedir eliminar la cuenta.'
            : j.cancelNote,
      );
    case 'terminado':
      final age = j.doneAt != null
          ? DateTime.now().difference(j.doneAt!)
          : Duration.zero;
      final canRate = j.rated == 0 && (j.doneAt == null || age < day * 30);
      final canReport = j.doneAt != null && age < day * 7 && !j.dispute;
      pill = const Pill('Terminado', kind: 'gray');
      det = sMut('${o!.name} · ${j.date}');
      action = stack([
        if (j.rated > 0) ...[
          Row(
            children: [
              const T('Tu calificación: ', size: 14, w: FontWeight.w800),
              Stars(j.rated, size: 14),
            ],
          ),
          BtnK(
            'Volver a contratar',
            () {
              maq.startReq(cat: j.cat, pid: j.pid);
              unawaited(context.push(RM.solicitar));
            },
            kind: Bk.sec,
            sm: true,
          ),
        ] else if (canRate) ...[
          BtnK(
            'Calificar a ${o.first}',
            () => context.push(RM.calificar(j.id)),
            kind: Bk.sec,
            sm: true,
          ),
          if (j.doneAt != null)
            sMut(
              'Puedes calificarlo hasta el ${longDate(j.doneAt!.add(day * 30))}.',
            ),
        ] else
          sMut('Ya pasaron los 30 días para calificar este servicio.'),
        if (j.dispute)
          Row(
            spacing: 4,
            children: [
              Icon(icn('flag'), size: 15, color: k.amberInk),
              Expanded(
                child: T(
                  'Reportaste que no se terminó · en revisión',
                  size: 14,
                  w: FontWeight.w800,
                  color: k.amberInk,
                ),
              ),
            ],
          )
        else if (canReport) ...[
          BtnK(
            'No se terminó el trabajo',
            () => context.push(RM.reportar(j.id, noTermino: true)),
            kind: Bk.ghost,
            sm: true,
            icon: 'flag',
          ),
          sMut(
            'Puedes reportarlo hasta el ${longDate(j.doneAt!.add(day * 7))}.',
          ),
        ],
      ], gap: 10);
  }
  return CardK(
    child: stack([
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: c.bg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icn(_catIcon(c.id)), color: c.fg),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                h3(j.title),
                sMut('${c.short} · ${c.taller ? 'En taller' : 'A domicilio'}'),
              ],
            ),
          ),
        ],
      ),
      Align(alignment: Alignment.centerLeft, child: pill),
      det,
      jobChat(context, j),
      action,
    ], gap: 10),
  );
}

Widget jobChat(BuildContext context, Job j) {
  final k = kc(context);
  final ids = j.pid != null ? [j.pid!] : j.quotes.map((q) => q.pid).toList();
  String? best;
  Msg? bm;
  var un = 0;
  for (final id in ids) {
    un += maq.unread[id] ?? 0;
    final th = maq.threads[id] ?? [];
    final m = th.where((x) => x.s == 'p').lastOrNull;
    if (m != null && (best == null || (maq.unread[id] ?? 0) > 0)) {
      best = id;
      bm = m;
    }
  }
  if (best == null || bm == null) return const SizedBox();
  final text = bm.t.length > 70 ? '${bm.t.substring(0, 70)}…' : bm.t;
  return InkWell(
    borderRadius: BorderRadius.circular(12),
    onTap: () {
      maq.openChat(best!);
      unawaited(context.push(RM.chat(best)));
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: k.surface2,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Icon(icn('chat'), size: 18, color: k.mut),
          Expanded(
            child: Text(
              '${provs[best]!.first}: ${tr(text)}',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                fontWeight: un > 0 ? FontWeight.w900 : FontWeight.w700,
                color: un > 0 ? k.ink : k.mut,
              ),
            ),
          ),
          if (un > 0) Pill('$un', bg: k.red, fg: Colors.white),
        ],
      ),
    ),
  );
}

Widget adjustCard(BuildContext context, Job j) {
  final a = j.adjust;
  if (a == null || a.status != 'pending') return const SizedBox();
  final k = kc(context);
  final first = provs[j.pid]?.first ?? 'El experto';
  return CardK(
    outline: k.amber,
    child: stack([
      Align(
        alignment: Alignment.centerLeft,
        child: Pill(
          a.kind == 'final' ? 'Cotización final' : 'Cambio de precio',
          kind: 'amber',
          icon: 'bell',
        ),
      ),
      Row(
        spacing: 6,
        children: [
          bT('$first propone'),
          T(money(a.amount), size: 20, w: FontWeight.w900, color: k.navy),
        ],
      ),
      sMut(
        'Antes: ${j.price}${a.kind == 'final' ? '' : ' · tope ${money(a.tope)}'}',
      ),
      T('«${a.why}»'),
      Row(
        spacing: 10,
        children: [
          BtnK(
            'Rechazar',
            () {
              maq.adjNo(j.id);
              context.go('/actividad');
            },
            kind: Bk.ghost,
            auto: true,
          ),
          Expanded(
            child: BtnK(
              'Aprobar ${money(a.amount)}',
              () => maq.adjOk(j.id),
              sm: true,
            ),
          ),
        ],
      ),
      sMut(
        'Si rechazas, cancelamos el trabajo${a.kind == 'final' ? ' y pagas solo la visita.' : ' sin costo.'}',
      ),
    ], gap: 10),
  );
}

// ------------------------------------------------------------ mensajes

class MensajesScreen extends StatelessWidget {
  const MensajesScreen({super.key});
  @override
  Widget build(BuildContext context) => MaqBuilder((context) {
    final k = kc(context);
    final ids = maq.convIds();
    return Pg(
      title: 'Mensajes',
      scroll: false,
      body: ids.isEmpty
          ? emptyK(
              'chat',
              'Sin mensajes',
              'Cuando hables con un experto, la conversación aparece aquí.',
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: CargaInicial(
                clave: 'mensajes',
                esqueleto: const EsqueletoLista(n: 4, fila: true),
                child: GroupK([
                  for (final (i, id) in ids.indexed)
                    Aparece(
                      i: i,
                      child: () {
                        final pr = provs[id]!;
                        final th = maq.threads[id]!;
                        final last = th
                            .where((m) => m.s == 'p' || m.s == 'me')
                            .lastOrNull;
                        final u = maq.unread[id] ?? 0;
                        final job = maq.jobs
                            .where(
                              (j) =>
                                  j.pid == id ||
                                  j.quotes.any((q) => q.pid == id),
                            )
                            .firstOrNull;
                        return InkWell(
                          onTap: () {
                            maq.openChat(id);
                            unawaited(context.push(RM.chat(id)));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              spacing: 14,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Av.prov(pr, size: 48, verified: false),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 2,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: T(
                                              pr.name,
                                              size: 16,
                                              w: FontWeight.w900,
                                            ),
                                          ),
                                          sMut(last?.h ?? '', size: 13.5),
                                        ],
                                      ),
                                      if (job != null)
                                        T(
                                          job.title,
                                          size: 13.5,
                                          w: FontWeight.w700,
                                          color: k.navy,
                                        ),
                                      Text(
                                        last != null
                                            ? '${last.s == 'me' ? '${tr('Tú')}: ' : ''}${tr(last.t)}'
                                            : tr('Conversación nueva'),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 13.5,
                                          fontWeight: u > 0
                                              ? FontWeight.w900
                                              : FontWeight.w700,
                                          color: u > 0 ? k.ink : k.mut,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (u > 0)
                                  Pill('$u', bg: k.red, fg: Colors.white),
                              ],
                            ),
                          ),
                        );
                      }(),
                    ),
                ]),
              ),
            ),
    );
  });
}

// ------------------------------------------------------------ chat

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.id});
  final String id;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _c = TextEditingController();
  final _sc = ScrollController();

  @override
  void initState() {
    super.initState();
    maq.chatAbierto = widget.id;
    maq.unread.remove(widget.id);
    maq.addListener(_onChange);
  }

  void _onChange() {
    maq.unread.remove(widget.id);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_sc.hasClients) _sc.jumpTo(_sc.position.maxScrollExtent);
    });
  }

  @override
  void dispose() {
    maq.removeListener(_onChange);
    maq.chatAbierto = null;
    _c.dispose();
    _sc.dispose();
    super.dispose();
  }

  void _menu(Prov pr) {
    unawaited(
      hoja<void>(
        context,
        (ctx, _) => stack([
          sheetH(ctx, pr.name),
          GroupK([
            LiK(
              'user',
              'Ver su perfil',
              onTap: () {
                Navigator.pop(ctx);
                unawaited(context.push(RM.experto(pr.id)));
              },
            ),
            liDanger(ctx, 'flag', 'Reportar', () {
              Navigator.pop(ctx);
              final j = maq.jobs
                  .where(
                    (x) =>
                        x.pid == pr.id || x.quotes.any((q) => q.pid == pr.id),
                  )
                  .firstOrNull;
              if (j != null) {
                unawaited(context.push(RM.reportar(j.id, pid: pr.id)));
              }
            }, sub: 'Si te pidió dinero por adelantado o algo te preocupa'),
            liDanger(ctx, 'x', 'Bloquear', () {
              Navigator.pop(ctx);
              maq.block(pr.id);
              maq.toast(
                'Bloqueaste a ${pr.first}',
                accion: 'Deshacer',
                alAccion: () => maq.unblock(pr.id),
              );
            }, sub: 'Ya no podrá escribirte'),
          ]),
        ]),
      ),
    );
  }

  void _send(String t) {
    if (t.trim().isEmpty) return;
    _c.clear();
    maq.sendMsg(widget.id, t.trim());
  }

  @override
  Widget build(BuildContext context) => MaqBuilder((context) {
    final k = kc(context);
    final pr = provs[widget.id]!;
    final th = maq.threads[widget.id] ?? [];
    final acc = maq.accepted(pr.id);
    final job = maq.jobs
        .where(
          (j) => j.pid == pr.id && (j.status == 'visita' || j.status == 'cita'),
        )
        .firstOrNull;
    final cj = maq.jobs
        .where((x) => x.quotes.any((q) => q.pid == pr.id))
        .firstOrNull;
    final cq = cj?.quotes.where((q) => q.pid == pr.id).firstOrNull;
    final isClosed = cj != null && (cj.closed[pr.id] ?? false);
    final typing = maq.typing[pr.id] ?? false;
    final presence = typing
        ? Text(
            tr('escribiendo…'),
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: k.greenInk,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 9,
                height: 9,
                margin: const EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: pr.online ? k.green : k.mut,
                ),
              ),
              Flexible(
                child: T(
                  '${pr.online ? 'En línea' : 'Fuera de línea'} · ${job != null ? '${job.status == 'cita' ? 'Cita confirmada' : 'Visita confirmada'} · ${job.time}' : 'responde en ${pr.resp}'}',
                  size: 13,
                  w: FontWeight.w700,
                  color: k.mut,
                  maxLines: 1,
                ),
              ),
            ],
          );
    final top = Column(
      children: [
        Container(
          constraints: const BoxConstraints(minHeight: 60),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: k.surface,
            border: Border(bottom: BorderSide(color: k.line2)),
          ),
          child: Row(
            spacing: 6,
            children: [
              InkWell(
                onTap: () => context.pop(),
                borderRadius: BorderRadius.circular(24),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(Icons.chevron_left, size: 28, color: k.navy),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => context.push(RM.experto(pr.id)),
                  child: Row(
                    spacing: 10,
                    children: [
                      Av.prov(pr, size: 40),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            T(
                              pr.name,
                              size: 16,
                              w: FontWeight.w900,
                              maxLines: 1,
                            ),
                            presence,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _menu(pr),
                icon: Icon(icn('more'), color: k.ink),
                tooltip: tr('Más opciones'),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: k.amberSoft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Icon(icn('shieldo'), size: 18, color: k.amberInk),
              Expanded(
                child: T(
                  'No hagas pagos por adelantado.${acc ? '' : ' Tu número está oculto hasta que elijas una cotización.'} La conversación se guarda en tu cuenta.',
                  size: 14,
                  w: FontWeight.w700,
                  color: k.amberInk,
                ),
              ),
            ],
          ),
        ),
        if (cj != null && cq != null)
          InkWell(
            onTap: () => context.push(
              cj.pid == pr.id
                  ? (cj.status == 'cita' ? RM.cita(cj.id) : RM.visita(cj.id))
                  : RM.comparar(cj.id),
            ),
            child: Container(
              color: k.surface2,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sMut('Solicitud', size: 13),
                        T(
                          '«${cj.title}»',
                          size: 13.5,
                          w: FontWeight.w800,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  T(cq.price, w: FontWeight.w900, color: k.navy),
                  Icon(Icons.chevron_right, size: 18, color: k.mut),
                ],
              ),
            ),
          ),
      ],
    );

    final items = <Widget>[];
    for (final m in th) {
      if (m.s == 'sys') {
        items.add(
          Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .9,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: k.line2,
                borderRadius: BorderRadius.circular(12),
              ),
              child: T(
                m.t,
                size: 13,
                w: FontWeight.w800,
                color: k.mut,
                align: TextAlign.center,
              ),
            ),
          ),
        );
      } else if (m.s == 'quote') {
        final j = maq.job(m.job);
        final q = j?.quotes.where((x) => x.pid == pr.id).firstOrNull;
        if (j != null && q != null) {
          items.add(
            Align(
              alignment: Alignment.centerLeft,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * .86,
                ),
                child: CardK(
                  child: stack([
                    sMut('${pr.first} respondió a tu solicitud «${j.title}»'),
                    T(q.price, size: 22, w: FontWeight.w900, color: k.navy),
                    sMut(
                      q.kind == 'visita'
                          ? 'Primero ve el trabajo y te cotiza. Se descuenta si lo contratas; si no, pagas solo la visita.'
                          : 'No pasará de ${money(qTope(q, j.cat))} sin tu aprobación.',
                    ),
                    sMut('Puede ir: ${q.when}'),
                    if (j.status == 'cotizando')
                      BtnK(
                        'Ver y comparar',
                        () => context.push(RM.comparar(j.id)),
                        kind: Bk.sec,
                        sm: true,
                      ),
                  ], gap: 6),
                ),
              ),
            ),
          );
        }
      } else {
        final me = m.s == 'me';
        items.add(
          Align(
            alignment: me ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .8,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: me ? k.navyBg : k.surface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(me ? 18 : 6),
                  bottomRight: Radius.circular(me ? 6 : 18),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      tr(m.t),
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 15.5,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                        color: me ? Colors.white : k.ink,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 4,
                    children: [
                      Text(
                        m.h,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: (me ? Colors.white : k.ink).withAlpha(165),
                        ),
                      ),
                      if (me)
                        Text(
                          m.read ? '✓✓' : '✓',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: m.read
                                ? const Color(0xFF8FE0B0)
                                : Colors.white.withAlpha(165),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
    if (job != null) {
      items.add(
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: k.greenSoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                T(
                  'Pueden seguir hablando aquí o por WhatsApp.',
                  size: 13,
                  w: FontWeight.w800,
                  color: k.greenInk,
                  align: TextAlign.center,
                ),
                InkWell(
                  onTap: () => context.push(
                    job.status == 'cita' ? RM.cita(job.id) : RM.visita(job.id),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: T(
                      'Ver detalles de la ${job.status == 'cita' ? 'cita' : 'visita'}',
                      size: 14,
                      w: FontWeight.w800,
                      color: k.navy,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    if (typing) items.add(_burbujaPuntos(context));

    final quick = acc
        ? const ['¿Ya viene en camino?', '¿Incluye materiales?', 'Gracias']
        : const [
            '¿Cuándo puede venir?',
            '¿Incluye materiales?',
            '¿Cuánto tarda?',
          ];
    final Widget foot;
    if (isClosed) {
      foot = Container(
        color: k.surface,
        padding: EdgeInsets.fromLTRB(
          20,
          12,
          20,
          14 + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            helpT(
              'Elegiste a otra persona para esta solicitud, así que esta conversación está cerrada.',
            ),
            BtnK(
              'Ver mi solicitud',
              () => context.go('/actividad'),
              kind: Bk.sec,
              sm: true,
            ),
          ],
        ),
      );
    } else if (maq.blocked[pr.id] ?? false) {
      foot = Container(
        color: k.surface,
        padding: EdgeInsets.fromLTRB(
          20,
          12,
          20,
          14 + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            helpT('Bloqueaste a ${pr.name}. No podrá escribirte.'),
            BtnK(
              'Desbloquear',
              () => maq.unblock(pr.id),
              kind: Bk.sec,
              sm: true,
            ),
          ],
        ),
      );
    } else {
      foot = Container(
        color: k.surface,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  spacing: 8,
                  children: [
                    for (final t in quick) quickK(context, t, () => _send(t)),
                  ],
                ),
              ),
            ),
            composerK(context, 'Escribe un mensaje', _c, () => _send(_c.text)),
          ],
        ),
      );
    }
    return Pg(
      noHeader: true,
      top: top,
      scroll: false,
      body: ListView(
        controller: _sc,
        padding: const EdgeInsets.all(16),
        children: [
          for (final w in items)
            Padding(padding: const EdgeInsets.only(bottom: 10), child: w),
        ],
      ),
      foot: foot,
    );
  });

  Widget _burbujaPuntos(BuildContext c) => Align(
    alignment: Alignment.centerLeft,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: kc(c).surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const T('…'),
    ),
  );
}

// ------------------------------------------------------------ reprogramar y cancelar

Widget reprogBlock(BuildContext context, Job j, String first) {
  if (j.resched != null) {
    return NoteK(
      'amber',
      'clock',
      'Pediste mover la cita a **${j.resched!.txt}**. Esperando que $first lo confirme.',
    );
  }
  return BtnK(
    'Reprogramar la cita',
    () => reprogSheet(context, j, first),
    kind: Bk.sec,
    sm: true,
    icon: 'cal',
  );
}

void reprogSheet(BuildContext context, Job j, String first) {
  var d = 1;
  var t = '10:00';
  unawaited(
    hoja<void>(context, (ctx, set) {
      final days0 = days;
      final k = kc(ctx);
      return stack([
        sheetH(ctx, 'Reprogramar la cita'),
        sMut(
          'Elige un nuevo día y hora. $first tiene que confirmarlo; mientras tanto la cita actual sigue en pie.',
        ),
        stack([
          labT('Día'),
          Row(
            spacing: 6,
            children: [
              for (var i = 0; i < days0.length; i++)
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => set(() => d = i),
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 68),
                      decoration: BoxDecoration(
                        color: d == i ? k.navyBg : k.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: d == i ? k.navyBg : k.line,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 2,
                        children: [
                          T(
                            days0[i].$1,
                            size: 13,
                            w: FontWeight.w800,
                            color: d == i ? const Color(0xFFD5E3E8) : k.mut,
                          ),
                          T(
                            '${days0[i].$2}',
                            size: 20,
                            w: FontWeight.w900,
                            color: d == i ? Colors.white : k.ink,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ], gap: 8),
        stack([
          labT('Hora'),
          chipsWrap([
            for (final x in rsTimes)
              ChipK(x, on: t == x, onTap: () => set(() => t = x)),
          ]),
        ], gap: 8),
        BtnK('Enviar cambio', () {
          Navigator.pop(ctx);
          maq.reprog(j.id, d, t);
        }),
      ]);
    }),
  );
}

Widget cancelBlock(BuildContext context, Job j) => BtnK(
  'Cancelar el servicio',
  () => cancelSheet(context, j),
  kind: Bk.ghost,
  sm: true,
  icon: 'x',
);

void cancelSheet(BuildContext context, Job j) {
  var why = '';
  unawaited(
    hoja<void>(context, (ctx, set) {
      final first = provs[j.pid]!.first;
      final late = maq.isLate(j);
      return stack([
        sheetH(ctx, '¿Cancelar el servicio?'),
        NoteK(
          late ? 'amber' : 'blue',
          late ? 'flag' : 'check',
          late
              ? '**Tu cita es en menos de 24 h.** Avisamos a $first de inmediato y queda registrado como cancelación tardía.'
              : '**Sin costo.** Faltan más de 24 h, así que $first solo recibe el aviso.',
        ),
        stack([
          labT('¿Por qué cancelas?'),
          chipsWrap([
            for (final x in const [
              'Ya lo resolví',
              'Cambié de planes',
              'Encontré otra opción',
              'Otro motivo',
            ])
              ChipK(x, on: why == x, onTap: () => set(() => why = x)),
          ]),
        ], gap: 8),
        BtnK(
          'Sí, cancelar',
          why.isEmpty
              ? null
              : () {
                  Navigator.pop(ctx);
                  maq.cancelJob(j.id);
                  context.go('/actividad');
                },
          kind: Bk.danger,
        ),
        BtnK('No, mantener', () => Navigator.pop(ctx), kind: Bk.ghost),
      ]);
    }),
  );
}

// ------------------------------------------------------------ visita

class VisitaMaqueta extends StatelessWidget {
  const VisitaMaqueta({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context) => MaqBuilder((context) {
    final j = maq.job(id);
    if (j == null || j.pid == null) {
      return const Pg(title: 'Tu visita', body: SizedBox());
    }
    final k = kc(context);
    final pr = provs[j.pid]!;
    final first = pr.first;
    final code = (j.code.isEmpty ? '0000' : j.code).split('');
    final b = <Widget>[
      adjustCard(context, j),
      Align(
        alignment: Alignment.centerLeft,
        child: Pill(
          j.diag ? 'Visita para cotizar' : 'Visita confirmada',
          kind: 'green',
          icon: 'check',
          size: 14,
        ),
      ),
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: k.navyBg,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          spacing: 14,
          children: [
            const T(
              'Tu código para cuando llegue',
              size: 16,
              w: FontWeight.w800,
              color: Color(0xFFD5E3E8),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                for (final d in code)
                  Container(
                    width: 58,
                    height: 70,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      d,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1C3A4C),
                      ),
                    ),
                  ),
              ],
            ),
            rich(
              'Pídele a $first que te diga este código en la puerta. **Si no lo sabe, no abras.**',
              color: Colors.white,
              align: TextAlign.center,
            ),
          ],
        ),
      ),
      if (!maq.tipDone)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: k.amberSoft,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Icon(icn('flag'), color: k.amberInk),
                  Expanded(
                    child: rich(
                      '**Tu primera visita con Knock:** no le dictes el código por teléfono ni por mensaje. Él te lo debe decir a ti.',
                      size: 15,
                      color: k.amberInk,
                    ),
                  ),
                ],
              ),
              BtnK(
                'Entendido',
                () {
                  maq.tipDone = true;
                  maq.refresh();
                },
                kind: Bk.sec,
                sm: true,
                auto: true,
              ),
            ],
          ),
        ),
      CardK(
        child: stack([
          Row(
            spacing: 12,
            children: [
              Av.prov(pr, size: 64),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    h3(pr.name),
                    Row(
                      spacing: 6,
                      children: [sMut(cats[pr.cat]!.short), rateW(pr)],
                    ),
                    T(
                      'Identidad verificada',
                      size: 14,
                      w: FontWeight.w700,
                      color: k.greenInk,
                    ),
                  ],
                ),
              ),
            ],
          ),
          sMut(
            'Esta es su foto verificada. Compárala con la persona que llegue.',
          ),
        ], gap: 14),
      ),
      FoldK(
        k: 'vd-${j.id}',
        title: 'Detalles de la visita',
        summary: '${j.when.split(',').first} · entre ${j.time}',
        icon: 'cal',
        child: stack([
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              Icon(icn('cal')),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [bT(j.when), sMut('Entre ${j.time}')],
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              Icon(icn('house')),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bT(
                      '${maq.user.addr.isNotEmpty ? '${maq.user.addr}, ' : ''}${maq.user.col}',
                    ),
                    sMut('Compartida solo con $first'),
                  ],
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              Icon(icn('doc')),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bT('Cotización: ${j.price}'),
                    sMut('El pago lo acuerdas directo con él'),
                  ],
                ),
              ),
            ],
          ),
        ], gap: 14),
      ),
      FoldK(
        k: 'vo-${j.id}',
        title: 'Más opciones',
        summary: 'Avisar a alguien, conversación o reportar',
        icon: 'more',
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: GroupK([
              LiK(
                'share',
                'Avisar a alguien de confianza',
                sub: 'Quién va a tu casa y a qué hora',
                onTap: () => context.push(RM.compartir(j.id)),
              ),
              LiK(
                'chat',
                'Ver la conversación',
                onTap: () {
                  maq.openChat(j.pid!);
                  unawaited(context.push(RM.chat(j.pid!)));
                },
              ),
              liDanger(
                context,
                'flag',
                'Reportar un problema',
                () => context.push(RM.reportar(j.id)),
                sub: 'Si algo no está bien',
              ),
            ]),
          ),
        ),
      ),
      if (j.diag && (j.adjust == null || j.adjust!.status == 'pending'))
        NoteK(
          'blue',
          'house',
          '**Esta visita es para ver el trabajo.** Después, $first te enviará la cotización final aquí para que la apruebes. Si la contratas, la visita se descuenta; si no, pagas solo la visita.',
        ),
      reprogBlock(context, j, first),
      cancelBlock(context, j),
      const NoteK(
        'blue',
        'clock',
        'Cuando termine el trabajo te avisamos aquí y podrás calificarlo. Si algo no queda bien, podrás reportarlo hasta 7 días después.',
      ),
    ];
    return Pg(
      title: 'Tu visita',
      body: stack(b),
      cta: ctaCol([
        BtnK('Escribirle en la app', () {
          maq.openChat(j.pid!);
          unawaited(context.push(RM.chat(j.pid!)));
        }, icon: 'chat'),
        BtnK(
          'Continuar por WhatsApp',
          () => maq.toast('Abriendo WhatsApp con $first…'),
          kind: Bk.ghost,
        ),
      ]),
    );
  });
}

// ------------------------------------------------------------ cita en taller

class CitaScreen extends StatelessWidget {
  const CitaScreen({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context) => MaqBuilder((context) {
    final j = maq.job(id);
    if (j == null || j.pid == null) {
      return const Pg(title: 'Cita en taller', body: SizedBox());
    }
    final k = kc(context);
    final pr = provs[j.pid]!;
    final ll = [
      'Tu auto y un juego de llaves',
      'Tarjeta de circulación',
      'Cuéntales cuándo empezó la falla y si pasa en frío o en caliente',
    ];
    return Pg(
      title: 'Cita en taller',
      body: stack([
        const Align(
          alignment: Alignment.centerLeft,
          child: Pill(
            'Cita confirmada',
            kind: 'green',
            icon: 'check',
            size: 14,
          ),
        ),
        CardK(
          child: stack([
            Row(
              spacing: 12,
              children: [
                Av.prov(pr, size: 56),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      h3(pr.name),
                      Wrap(
                        spacing: 6,
                        children: [rateW(pr), sMut('· ${j.title}')],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(color: k.line2, height: 1),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                Icon(icn('cal')),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      bT(j.when),
                      sMut(
                        '${j.time} · ${j.what.isEmpty ? 'Diagnóstico' : j.what}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                Icon(icn('pin')),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      bT(pr.addr),
                      sMut('${pr.addr2} · a ${pr.km} km'),
                    ],
                  ),
                ),
              ],
            ),
          ], gap: 14),
        ),
        FoldK(
          k: 'll-${j.id}',
          title: 'Qué llevar',
          summary: '4 cosas para tener a la mano',
          icon: 'check',
          child: stack([
            for (final t in ll)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  Icon(icn('check')),
                  Expanded(child: T(t, size: 15.5, w: FontWeight.w700)),
                ],
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                Icon(icn('check')),
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const T(
                        'Tu historial de servicios (está en ',
                        size: 15.5,
                        w: FontWeight.w700,
                      ),
                      InkWell(
                        onTap: () => context.push(RM.miCasa),
                        child: T(
                          'Mi casa y mi auto',
                          size: 15.5,
                          w: FontWeight.w800,
                          color: k.navy,
                        ),
                      ),
                      const T(')', size: 15.5, w: FontWeight.w700),
                    ],
                  ),
                ),
              ],
            ),
          ], gap: 8),
        ),
        NoteK(
          'blue',
          'help',
          '${j.price.isEmpty ? 'Diagnóstico desde \$200' : j.price}. El costo final lo acuerdas en el taller antes de cualquier reparación.',
        ),
        GroupK([
          LiK(
            'chat',
            'Escribirle en la app',
            onTap: () {
              maq.openChat(pr.id);
              unawaited(context.push(RM.chat(pr.id)));
            },
          ),
          LiK(
            'phone',
            'Continuar por WhatsApp',
            onTap: () => maq.toast('Abriendo WhatsApp con el taller…'),
          ),
          liDanger(
            context,
            'flag',
            'Reportar un problema',
            () => context.push(RM.reportar(j.id)),
          ),
        ]),
        reprogBlock(context, j, pr.first),
        cancelBlock(context, j),
        const NoteK(
          'blue',
          'clock',
          'Cuando el taller termine te avisamos aquí y podrás calificarlo. Si algo no queda bien, podrás reportarlo hasta 7 días después.',
        ),
      ]),
      cta: BtnK(
        'Cómo llegar',
        () => maq.toast('Abriendo el mapa con la ruta…'),
        icon: 'route',
      ),
    );
  });
}

// ------------------------------------------------------------ calificar

class CalificarScreen extends StatefulWidget {
  const CalificarScreen({super.key, required this.id});
  final String id;
  @override
  State<CalificarScreen> createState() => _CalificarScreenState();
}

class _CalificarScreenState extends State<CalificarScreen> {
  int g = 0;
  final parts = {'p': 0, 'c': 0, 'j': 0, 't': 0};
  bool more = false;
  late bool save;
  final photos = <String>[];
  final _txt = TextEditingController();

  @override
  void initState() {
    super.initState();
    final j = maq.job(widget.id);
    save = !(maq.saved[j?.pid] ?? false);
  }

  @override
  void dispose() {
    _txt.dispose();
    super.dispose();
  }

  Widget _row(String? key, int val, ValueChanged<int> on, {bool big = false}) =>
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var n = 1; n <= 5; n++)
            GestureDetector(
              onTap: () => on(n),
              child: Padding(
                padding: EdgeInsets.all(big ? 4 : 2),
                child: Text(
                  '★',
                  style: TextStyle(
                    fontSize: big ? 46 : 30,
                    height: 1,
                    color: n <= val
                        ? const Color(0xFFE9682D)
                        : kc(context).line2,
                  ),
                ),
              ),
            ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final j = maq.job(widget.id)!;
    final pr = provs[j.pid]!;
    final first = pr.first;
    final k = kc(context);
    const txt = [
      'Toca una estrella',
      'Muy mal',
      'Mal',
      'Regular',
      'Bien',
      '¡Excelente!',
    ];
    return Pg(
      title: 'Califica el servicio',
      body: stack([
        Column(
          spacing: 8,
          children: [
            Av.prov(pr, size: 72),
            h1('¿Cómo te fue con $first?', a: TextAlign.center),
            sMut(j.title),
          ],
        ),
        CardK(
          child: Column(
            children: [
              _row(null, g, (n) => setState(() => g = n), big: true),
              h3(txt[g]),
            ],
          ),
        ),
        if (g > 0) ...[
          FieldK(
            label: 'Cuéntale a otros cómo fue',
            opt: true,
            c: _txt,
            lines: 3,
            hint: 'Ej.: Llegó a tiempo y cobró lo acordado.',
          ),
          ChoiceK(
            on: more,
            onTap: () => setState(() => more = !more),
            title: 'Calificar por partes',
            sub: 'Puntualidad, calidad, precio y trato (opcional)',
            trailing: Icon(
              more ? Icons.expand_less : Icons.expand_more,
              color: k.mut,
            ),
          ),
          if (more)
            CardK(
              child: stack([
                for (final x in const [
                  ('p', 'Puntualidad'),
                  ('c', 'Calidad'),
                  ('j', 'Precio justo'),
                  ('t', 'Trato'),
                ])
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      bT(x.$2),
                      _row(
                        x.$1,
                        parts[x.$1]!,
                        (n) => setState(() => parts[x.$1] = n),
                      ),
                    ],
                  ),
              ], gap: 4),
            ),
          stack([
            Row(
              spacing: 6,
              children: [
                labT('Fotos'),
                T('(opcional)', size: 15, w: FontWeight.w700, color: k.mut),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 10,
                children: [
                  for (final p in photos) PhotoTile(path: p),
                  if (photos.length < 3)
                    AddPhoto(
                      onTap: () async {
                        final f = await elegirFotos(max: 3 - photos.length);
                        setState(
                          () => photos.addAll(f.take(3 - photos.length)),
                        );
                      },
                    ),
                ],
              ),
            ),
          ], gap: 8),
          ChoiceK(
            on: save,
            check: true,
            onTap: () => setState(() => save = !save),
            title: 'Guardar a $first en mis técnicos de confianza',
            sub: 'Para volver a contratarlo en un toque',
          ),
          const NoteK(
            'green',
            'shield',
            'Tu opinión se publica como «Servicio verificado» porque el trabajo se hizo a través de Knock.',
          ),
        ],
      ], gap: 20),
      cta: ctaCol([
        BtnK(
          'Publicar opinión',
          g == 0
              ? null
              : () {
                  maq.rate(j.id, g, save);
                  context.go('/actividad');
                  exitoRapido(context);
                  maq.toast('Opinión publicada. ¡Gracias!');
                },
        ),
        if (g == 0) helpT('Elige cuántas estrellas para continuar'),
      ]),
    );
  }
}

// ------------------------------------------------------------ reportar

class ReportarScreen extends StatefulWidget {
  const ReportarScreen({
    super.key,
    required this.id,
    this.pid,
    this.noTermino = false,
  });
  final String id;
  final String? pid;
  final bool noTermino;
  @override
  State<ReportarScreen> createState() => _ReportarScreenState();
}

class _ReportarScreenState extends State<ReportarScreen> {
  int? o;
  bool ev = false, sent = false;
  String sentOp = '';
  final _t = TextEditingController();

  @override
  void dispose() {
    _t.dispose();
    super.dispose();
  }

  String _answer(String op, String name) {
    if (op == 'Comportamiento inapropiado' || op == 'Llegó otra persona') {
      return 'Suspendimos de forma preventiva la cuenta de $name mientras revisamos. Te respondemos hoy.';
    }
    if (op == 'Cobró distinto a lo acordado') {
      return 'Ocultamos a $name de nuevas solicitudes mientras revisamos. Te respondemos en menos de 24 horas.';
    }
    if (op == 'No se presentó' || op == 'El trabajo no se terminó') {
      return 'Registramos una advertencia para $name y revisamos tu caso en un máximo de 72 horas.';
    }
    return 'Te ayudamos a resolverlo con $name. Te respondemos en un máximo de 5 días.';
  }

  @override
  Widget build(BuildContext context) {
    final j = maq.job(widget.id)!;
    final pr = provs[(widget.pid ?? '').isNotEmpty ? widget.pid : j.pid]!;
    final k = kc(context);
    if (sent) {
      return Pg(
        noHeader: true,
        body: Column(
          spacing: 14,
          children: [
            const SizedBox(height: 40),
            stateK0(
              context,
              Icons.check,
              k.greenSoft,
              k.green,
              'Recibimos tu reporte',
              _answer(sentOp, pr.name),
            ),
            const NoteK('red', 'phone', 'Si estás en peligro, llama al 911.'),
          ],
        ),
        cta: BtnK('Volver', () => context.pop(), kind: Bk.sec),
      );
    }
    final ops = [
      'No se presentó',
      'Llegó otra persona',
      'Comportamiento inapropiado',
      'Cobró distinto a lo acordado',
      'Otra cosa',
    ];
    if (j.status == 'terminado') ops.insert(0, 'El trabajo no se terminó');
    o ??= widget.noTermino ? 0 : null;
    return Pg(
      title: 'Reportar un problema',
      body: stack([
        rich('Sobre: **${pr.name}** · ${j.title}'),
        stack([
          labT('¿Qué pasó?'),
          for (var i = 0; i < ops.length; i++)
            ChoiceK(
              on: o == i,
              minH: 58,
              onTap: () => setState(() => o = i),
              title: ops[i],
            ),
        ], gap: 8),
        FieldK(label: 'Cuéntanos más', opt: true, c: _t, lines: 3),
        BtnK(
          ev ? '1 foto agregada' : 'Agregar fotos o capturas',
          () {
            setState(() => ev = !ev);
            if (ev) maq.toast('Foto agregada');
          },
          kind: Bk.sec,
          sm: true,
          icon: 'camera',
        ),
        const NoteK('red', 'phone', 'Si estás en peligro, llama al 911.'),
      ]),
      cta: ctaCol([
        BtnK(
          'Enviar reporte',
          o == null
              ? null
              : () {
                  sentOp = ops[o!];
                  maq.report(j.id, sentOp);
                  setState(() => sent = true);
                },
          kind: Bk.danger,
        ),
        if (o == null) helpT('Elige qué pasó para continuar'),
      ]),
    );
  }
}

// ------------------------------------------------------------ avisar a alguien

class CompartirScreen extends StatefulWidget {
  const CompartirScreen({super.key, required this.id});
  final String id;
  @override
  State<CompartirScreen> createState() => _CompartirScreenState();
}

class _CompartirScreenState extends State<CompartirScreen> {
  int c = 0;

  void _add() {
    final n = TextEditingController();
    final ph = TextEditingController();
    unawaited(
      hoja<void>(context, (ctx, set) {
        final ok = n.text.trim().length >= 2 && digits(ph.text).length == 10;
        return stack([
          sheetH(ctx, 'Agregar contacto'),
          FieldK(
            label: 'Nombre',
            c: n,
            hint: 'Ej.: Mamá',
            onChanged: (_) => set(() {}),
          ),
          FieldK(
            label: 'Celular',
            c: ph,
            hint: '771 234 5678',
            keyboard: TextInputType.number,
            maxLen: 12,
            onChanged: (_) => set(() {}),
          ),
          BtnK(
            'Guardar',
            ok
                ? () {
                    maq.addContact(n.text.trim(), ph.text.trim());
                    Navigator.pop(ctx);
                    setState(() => c = maq.contacts.length - 1);
                    maq.toast('Contacto guardado');
                  }
                : null,
          ),
        ]);
      }).whenComplete(() {
        n.dispose();
        ph.dispose();
      }),
    );
  }

  @override
  Widget build(BuildContext context) => MaqBuilder((context) {
    final j = maq.job(widget.id)!;
    final pr = provs[j.pid]!;
    final first = pr.first;
    final cs = maq.contacts;
    final ci = cs.isEmpty ? 0 : c.clamp(0, cs.length - 1);
    final ct = cs.isEmpty ? null : cs[ci];
    return Pg(
      title: 'Avisar a alguien',
      body: stack([
        T('Elige a quién avisarle que $first irá a tu casa.'),
        stack([
          for (var i = 0; i < cs.length; i++)
            ChoiceK(
              on: ci == i,
              onTap: () => setState(() => c = i),
              title: cs[i].n,
              sub: cs[i].ph,
              leading: Av(
                ini: initials(cs[i].n),
                color: contactColors[cs[i].colorIdx],
                size: 44,
              ),
            ),
          BtnK(
            cs.isNotEmpty ? 'Agregar otro contacto' : 'Agregar un contacto',
            _add,
            kind: Bk.sec,
            sm: true,
            icon: 'plus',
          ),
        ], gap: 8),
        if (ct != null)
          stack([
            labT('Así le llegará'),
            CardK(
              child: rich(
                'Hola, ${j.when.toLowerCase()} entre **${j.time}** viene $first (${cats[pr.cat]!.short.toLowerCase()}, identidad verificada en Knock) a mi casa en ${maq.user.col}. Su código de servicio es **${j.code}**. Si no te escribo después, márcame.',
                w: FontWeight.w400,
              ),
            ),
          ], gap: 8),
      ]),
      cta: ct == null
          ? null
          : ctaCol([
              BtnK('Enviar por WhatsApp', () {
                context.pop();
                maq.toast('Le avisamos a ${ct.n.split(',').first}');
              }, icon: 'phone'),
              BtnK('Enviar por SMS', () {
                context.pop();
                maq.toast('Le avisamos a ${ct.n.split(',').first}');
              }, kind: Bk.ghost),
            ]),
    );
  });
}
