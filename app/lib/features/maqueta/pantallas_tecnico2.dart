import 'dart:async';

import 'package:app/features/maqueta/asistente_real.dart';
import 'package:app/features/maqueta/servicios_reales.dart';
import 'package:app/features/maqueta/datos.dart';
import 'package:app/features/maqueta/anim_k.dart';
import 'package:app/features/maqueta/carga_k.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/horarios_reales.dart';
import 'package:app/features/maqueta/nav.dart';
import 'package:app/features/maqueta/pantallas_tecnico.dart';
import 'package:app/features/maqueta/tecnico_estado.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

String _catIcon(String id) => id == 'mec'
    ? 'car'
    : id == 'plo'
    ? 'drop'
    : 'bolt';

// ------------------------------------------------------------ cotización con IA

class CotizarScreen extends StatefulWidget {
  const CotizarScreen({super.key, required this.rid});
  final String rid;
  @override
  State<CotizarScreen> createState() => _CotizarState();
}

class _CotizarState extends State<CotizarScreen> {
  final lo = TextEditingController(),
      hi = TextEditingController(),
      fx = TextEditingController(),
      nt = TextEditingController();
  String? _loaded;
  bool _gen = false;

  @override
  void dispose() {
    for (final c in [lo, hi, fx, nt]) {
      c.dispose();
    }
    super.dispose();
  }

  void _load(Borrador d) {
    lo.text = d.lo;
    hi.text = d.hi;
    fx.text = d.fx;
    nt.text = d.nt;
  }

  void _send(Req r) {
    void doSend() {
      pv.sendQuote(r);
      context.go('/trabajo');
      maq.toast('Cotización enviada');
    }

    if (needVerif(context, 'enviar tu cotización', doSend)) return;
    doSend();
  }

  @override
  Widget build(BuildContext context) => MaqBuilder((context) {
    final k = kc(context);
    final r = pv.req(widget.rid) ?? pv.reqs.first;
    final th = pv.ensureThread(r);
    final c = cliente(r.cid);
    if (pv.workerMsgs(th) == 0) {
      return Pg(
        title: 'Cotización',
        scroll: false,
        body: stateK(
          Icons.chat_bubble_outline,
          k.amberSoft,
          k.amberInk,
          'Primero conversa con ${c.n}',
          [
            mutT(
              'La cotización se arma con lo que platiquen: detalles del problema, materiales y día de la visita.',
              a: TextAlign.center,
            ),
          ],
        ),
        cta: BtnK('Ir al chat', () {
          context.pushReplacement(RT.chat(r.cid, r.id));
        }, icon: 'chat'),
      );
    }
    final d = pv.draft(r);
    if (_loaded != r.id) {
      _load(d);
      _loaded = r.id;
    }
    final ok = pv.draftOk(d);
    final ed = d.edited;
    final mk = pv.marketRef(r);
    final vlo = (priceVisitaMax * .6 / 10).round() * 10;
    final loN = int.tryParse(d.lo) ?? 0,
        hiN = int.tryParse(d.hi) ?? 0,
        fxN = int.tryParse(d.fx) ?? 0;
    void upd(VoidCallback f) {
      f();
      maq.refresh();
    }

    Widget seg(String id, String label) => Expanded(
      child: InkWell(
        onTap: () => upd(() => d.m = id),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            color: d.m == id ? k.navyBg : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: T(
            label,
            size: 14,
            w: FontWeight.w800,
            color: d.m == id ? Colors.white : k.ink,
            align: TextAlign.center,
          ),
        ),
      ),
    );
    final days0 = days;
    return Pg(
      title: 'Cotización',
      body: stack([
        CardK(
          child: stack([
            Row(
              spacing: 6,
              children: [
                Pill(cats[r.cat]!.short, icon: _catIcon(r.cat)),
                Pill(
                  pv.me.how == 'taller' ? 'En tu taller' : 'A domicilio',
                  kind: 'gray',
                ),
              ],
            ),
            h3(r.titulo),
            T('“${r.desc}”'),
            sMut(
              '${c.n} · ${r.zona} (zona aproximada) · Prefiere: ${r.cuando}',
            ),
          ], gap: 8),
        ),
        CardK(
          child: stack([
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Pill(
                  'Sugerencia de la IA',
                  kind: 'amber',
                  icon: 'sparkle',
                ),
                Pill(
                  ed ? 'Editada por ti' : 'Sin cambios',
                  kind: ed ? 'navy' : 'gray',
                ),
              ],
            ),
            const NotaIaDeEjemplo(),
            rich(
              'Armé este borrador con tu chat con ${c.n.split(' ').first} (${d.msgs} mensajes) y la solicitud. **Revísalo y edítalo antes de enviar.**',
              w: FontWeight.w400,
            ),
            FoldK(
              k: 'qb',
              title: 'Qué tomó en cuenta',
              summary: '${d.basis.length} datos',
              icon: 'list',
              child: stack([
                for (final x in d.basis)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      const Text('•'),
                      Expanded(child: sMut(x, color: k.ink)),
                    ],
                  ),
              ], gap: 6),
            ),
            if (_gen)
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  CargaK(tipo: TipoCarga.puntos, size: 40),
                  Flexible(
                    child: MensajesRotativos([
                      'Leyendo tu chat…',
                      'Calculando un precio justo…',
                      'Ya casi…',
                    ]),
                  ),
                ],
              ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                BtnK(
                  'Regenerar con el chat',
                  () {
                    setState(() => _gen = true);
                    Timer(const Duration(milliseconds: 1500), () {
                      if (!mounted) return;
                      _gen = false;
                      pv.makeDraft(r);
                      _loaded = null;
                      maq.refresh();
                      maq.toast('Sugerencia actualizada con tu chat');
                    });
                  },
                  kind: Bk.sec,
                  sm: true,
                  auto: true,
                  icon: 'sparkle',
                  busy: _gen,
                ),
                if (ed)
                  BtnK(
                    'Volver a la sugerencia',
                    () {
                      d
                        ..m = d.ai.m
                        ..lo = d.ai.lo
                        ..hi = d.ai.hi
                        ..fx = d.ai.fx
                        ..t = d.ai.t
                        ..d = d.ai.d
                        ..nt = d.ai.nt;
                      _loaded = null;
                      maq.refresh();
                      maq.toast('Volviste a la sugerencia de la IA');
                    },
                    kind: Bk.ghost,
                    sm: true,
                    auto: true,
                  ),
              ],
            ),
          ], gap: 10),
        ),
        CardK(
          child: stack([
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Pill(
                  'Referencia del mercado',
                  kind: 'gray',
                  icon: 'jobs',
                ),
                sMut('Sin IA'),
              ],
            ),
            rich(
              'Por trabajos parecidos ${mk.what}, otros técnicos de Tula de Allende cotizan entre **${money(mk.lo)} y ${money(mk.hi)}**. Lo más común es cerca de **${money(mk.med)}**.',
              w: FontWeight.w400,
            ),
            sMut(
              'Según ${mk.n} cotizaciones de los últimos 90 días. Solo es una referencia: tú decides tu precio, según tus costos y el trabajo.',
            ),
            if (d.m == 'visita')
              rich(
                'Por la visita para cotizar, lo normal es entre ${money(vlo)} y ${money(priceVisitaMax)}.',
                size: 14,
                w: FontWeight.w700,
              )
            else
              BtnK(
                'Usar este rango',
                () {
                  upd(() {
                    d.m = 'rango';
                    d.lo = '${mk.lo}';
                    d.hi = '${mk.hi}';
                  });
                  _loaded = null;
                  maq.toast('Usaste el rango del mercado; ajústalo a tu caso');
                },
                kind: Bk.sec,
                sm: true,
                auto: true,
              ),
          ], gap: 8),
        ),
        stack([
          labT('Tu precio'),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: k.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: k.line, width: 2),
            ),
            child: Row(
              children: [
                seg('rango', 'Aproximado (de – a)'),
                seg('fijo', 'Precio fijo'),
                seg('visita', 'Ver primero'),
              ],
            ),
          ),
          if (d.m == 'rango') ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Expanded(
                  child: FieldK(
                    label: 'Desde \$',
                    c: lo,
                    keyboard: TextInputType.number,
                    err: loN > 0 ? null : '',
                    onChanged: (v) => upd(() => d.lo = v),
                  ),
                ),
                Expanded(
                  child: FieldK(
                    label: 'Hasta \$',
                    c: hi,
                    keyboard: TextInputType.number,
                    err: hiN < loN || hiN <= 0 ? '' : null,
                    onChanged: (v) => upd(() => d.hi = v),
                  ),
                ),
              ],
            ),
            if (hiN < loN)
              Row(
                spacing: 6,
                children: [
                  Icon(Icons.close, size: 16, color: k.red),
                  T(
                    '«Hasta» debe ser mayor que «Desde»',
                    size: 14,
                    w: FontWeight.w800,
                    color: k.red,
                  ),
                ],
              ),
          ] else if (d.m == 'visita')
            FieldK(
              label: 'Costo de la visita \$',
              c: fx,
              keyboard: TextInputType.number,
              err: fxN > priceVisitaMax
                  ? 'La visita puede costar hasta ${money(priceVisitaMax)}.'
                  : null,
              help:
                  'Máximo ${money(priceVisitaMax)}. Úsalo si necesitas ver el lugar para dar un precio justo. Se descuenta si te contratan; si no, el cliente paga solo la visita (siempre que la hagas y envíes tu cotización final).',
              onChanged: (v) => upd(() => d.fx = v),
            )
          else
            FieldK(
              label: 'Precio total del trabajo \$',
              c: fx,
              keyboard: TextInputType.number,
              err: fxN > 0 ? null : '',
              onChanged: (v) => upd(() => d.fx = v),
            ),
        ], gap: 8),
        if (d.m != 'visita')
          Row(
            spacing: 6,
            children: [
              Icon(icn('shield'), size: 16, color: k.mut),
              Expanded(
                child: rich(
                  'No podrás cobrar más de **${money(pv.tTope(d, r.cat))}** sin que el cliente lo apruebe.',
                  size: 14,
                  color: k.mut,
                ),
              ),
            ],
          ),
        stack([
          labT('¿Cuánto tardas en el trabajo?'),
          chipsWrap([
            for (var i = 0; i < 4; i++)
              ChipK(
                const ['1 hora', '2 horas', 'Medio día', 'Más de un día'][i],
                on: d.t == i,
                onTap: () => upd(() => d.t = i),
              ),
          ]),
        ], gap: 8),
        stack([
          labT('¿Cuándo puedes ir?'),
          Row(
            spacing: 6,
            children: [
              for (var i = 0; i < days0.length; i++)
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => upd(() => d.d = i),
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 68),
                      decoration: BoxDecoration(
                        color: d.d == i ? k.navyBg : k.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: d.d == i ? k.navyBg : k.line,
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
                            color: d.d == i ? const Color(0xFFD5E3E8) : k.mut,
                          ),
                          T(
                            '${days0[i].$2}',
                            size: 20,
                            w: FontWeight.w900,
                            color: d.d == i ? Colors.white : k.ink,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ], gap: 8),
        FieldK(
          label: 'Nota para el cliente (la IA la redactó, edítala)',
          c: nt,
          lines: 6,
          onChanged: (v) => upd(() => d.nt = v),
        ),
        const NoteK(
          'blue',
          'help',
          'La IA puede equivocarse. Revisa precio, tiempo y nota: el cliente verá que el precio puede cambiar si el trabajo no coincide con lo que describió.',
        ),
      ], gap: 18),
      cta: BtnK('Enviar cotización', ok ? () => _send(r) : null, icon: 'send'),
    );
  });
}

// ------------------------------------------------------------ iniciar trabajo

class IniciarScreen extends StatefulWidget {
  const IniciarScreen({super.key, required this.vid});
  final String vid;
  @override
  State<IniciarScreen> createState() => _IniciarState();
}

class _IniciarState extends State<IniciarScreen> {
  final _c = TextEditingController();
  String state = '';
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaqBuilder((context) {
    final k = kc(context);
    final vis = pv.visita(widget.vid) ?? pv.nextVisit;
    if (vis == null) {
      return Pg(
        title: 'Iniciar trabajo',
        scroll: false,
        body: emptyK(
          'cal',
          'No tienes visitas por iniciar',
          'Cuando un cliente acepte tu cotización, podrás iniciar el trabajo aquí.',
          BtnK(
            'Ver solicitudes',
            () => context.go('/trabajo'),
            kind: Bk.sec,
            auto: true,
          ),
        ),
      );
    }
    final c = cliente(vis.cid);
    final rq = pv.req(vis.rid);
    final first = c.n.split(' ').first;
    final head = [
      CardK(
        child: Row(
          spacing: 14,
          children: [
            Av(ini: c.ini, color: c.c, size: 52),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  T(c.n, size: 16.5, w: FontWeight.w800),
                  sMut(vis.titulo),
                  sMut(
                    '${c.addr}, ${c.col} · ${pv.dayLabel(vis.d)} ${vis.time}',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      if (rq?.bit != null && rq!.bit!.saved)
        CardK(
          child: stack([
            const Align(
              alignment: Alignment.centerLeft,
              child: Pill('Tu bitácora', kind: 'amber', icon: 'doc'),
            ),
            rich('**Qué llevar:** ${rq.bit!.tools}', size: 14),
            if (rq.bit!.falta.isNotEmpty)
              rich('**Por confirmar:** ${rq.bit!.falta.join('; ')}', size: 14),
          ], gap: 6),
        ),
    ];
    if (state == 'ok') {
      return Pg(
        title: 'Iniciar trabajo',
        body: stack([
          ...head,
          Column(
            spacing: 14,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: k.greenSoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, size: 52, color: k.green),
              ),
              h1('Código correcto', a: TextAlign.center),
              mutT(
                '¡Toc, toc! $first ya sabe que llegaste. Puedes empezar.',
                a: TextAlign.center,
              ),
            ],
          ),
        ], gap: 18),
        cta: BtnK(
          'Comenzar el trabajo',
          () => context.pushReplacement(RT.cerrar(vis.id)),
          icon: 'play',
        ),
      );
    }
    final ok = digits(_c.text).length == 4;
    void check() {
      if (!ok) return;
      setState(() => state = _c.text == vis.code ? 'ok' : 'bad');
    }

    return Pg(
      title: 'Iniciar trabajo',
      body: stack([
        ...head,
        Column(
          spacing: 8,
          children: [
            h1('Pídele a $first su código', a: TextAlign.center),
            mutT(
              'Te dirá 4 números en la puerta. Escríbelos aquí.',
              a: TextAlign.center,
            ),
          ],
        ),
        TextField(
          controller: _c,
          keyboardType: TextInputType.number,
          maxLength: 4,
          textAlign: TextAlign.center,
          onChanged: (_) => setState(() => state = ''),
          onSubmitted: (_) => check(),
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 40,
            fontWeight: FontWeight.w900,
            letterSpacing: 18,
            color: k.ink,
          ),
          decoration: InputDecoration(
            counterText: '',
            hintText: '• • • •',
            filled: true,
            fillColor: k.surface,
            contentPadding: const EdgeInsets.symmetric(vertical: 22),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: state == 'bad' ? k.red : k.line,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: state == 'bad' ? k.red : k.navy,
                width: 2,
              ),
            ),
          ),
        ),
        if (state == 'bad')
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 6,
            children: [
              Icon(Icons.close, size: 16, color: k.red),
              Flexible(
                child: T(
                  'El código no coincide. Confirma la dirección y vuelve a pedírselo.',
                  size: 14,
                  w: FontWeight.w800,
                  color: k.red,
                ),
              ),
            ],
          ),
        NoteK(
          'blue',
          'shield',
          'Este paso confirma que estás con la persona correcta. Para la demostración, el código es ${vis.code}.',
        ),
      ], gap: 18),
      cta: BtnK('Validar código', ok ? check : null),
    );
  });
}

// ------------------------------------------------------------ terminar trabajo

class CerrarScreen extends StatefulWidget {
  const CerrarScreen({super.key, required this.vid});
  final String vid;
  @override
  State<CerrarScreen> createState() => _CerrarState();
}

class _CerrarState extends State<CerrarScreen> {
  final photos = <String>[];
  final tx = TextEditingController(), rc = TextEditingController();
  @override
  void dispose() {
    tx.dispose();
    rc.dispose();
    super.dispose();
  }

  void _adjust(Visita vis, Req rq) {
    final fin = rq.quote!.m == 'visita';
    final amount = TextEditingController();
    final why = TextEditingController();
    unawaited(
      hoja<void>(context, (ctx, set) {
        final n = int.tryParse(amount.text) ?? 0;
        final tp = pv.tTope(rq.quote!, rq.cat);
        final ok = n > 0 && why.text.trim().length >= 10;
        final over = !fin && n > tp;
        return stack([
          sheetH(ctx, fin ? 'Cotización final' : 'Proponer otro precio'),
          FieldK(
            label: 'Precio total \$',
            c: amount,
            keyboard: TextInputType.number,
            onChanged: (_) => set(() {}),
          ),
          FieldK(
            label: '¿Por qué cambia?',
            c: why,
            lines: 3,
            hint: 'Ej.: Hay otra pieza dañada que no se veía en la foto.',
            onChanged: (_) => set(() {}),
          ),
          if (n > 0)
            (fin || over
                ? NoteK(
                    'amber',
                    'bell',
                    'El cliente tiene que **aprobarlo** antes de que sigas. Si lo rechaza, el trabajo se cancela${fin ? ' y se paga solo la visita.' : ' sin costo.'}',
                  )
                : const NoteK(
                    'green',
                    'check',
                    'Está dentro del tope: no necesita aprobación.',
                  )),
          BtnK(
            over || fin ? 'Enviar al cliente' : 'Registrar el cambio',
            ok
                ? () {
                    Navigator.pop(ctx);
                    pv.adjust(vis.id, n, why.text);
                  }
                : null,
          ),
        ]);
      }).whenComplete(() {
        amount.dispose();
        why.dispose();
      }),
    );
  }

  @override
  Widget build(BuildContext context) => MaqBuilder((context) {
    final k = kc(context);
    final vis = pv.visita(widget.vid) ?? pv.nextVisit;
    if (vis == null) {
      return Pg(
        title: 'Terminar servicio',
        scroll: false,
        body: emptyK('cal', 'Nada que terminar'),
      );
    }
    final c = cliente(vis.cid);
    final rq = pv.req(vis.rid);
    final qq = rq?.quote;
    final fin = qq != null && qq.m == 'visita';
    final ok = photos.isNotEmpty && tx.text.trim().length > 3;
    return Pg(
      title: 'Terminar servicio',
      body: stack([
        const Align(
          alignment: Alignment.centerLeft,
          child: Pill('Trabajo en curso', kind: 'amber', icon: 'clock'),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            h2(vis.titulo),
            sMut('${c.n} · ${c.col} · código validado'),
          ],
        ),
        stack([
          Row(
            spacing: 6,
            children: [
              labT('Fotos del trabajo terminado'),
              T('(mínimo 1)', size: 15, w: FontWeight.w700, color: k.amberInk),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 10,
              children: [
                for (var i = 0; i < photos.length; i++)
                  PhotoTile(
                    path: photos[i],
                    onRemove: () => setState(() => photos.removeAt(i)),
                  ),
                if (photos.length < 6)
                  AddPhoto(
                    onTap: () async {
                      final f = await elegirFotos(max: 6 - photos.length);
                      setState(() => photos.addAll(f.take(6 - photos.length)));
                    },
                  ),
              ],
            ),
          ),
          if (photos.isEmpty)
            Row(
              spacing: 6,
              children: [
                Icon(Icons.close, size: 16, color: k.red),
                T(
                  'Agrega al menos una foto',
                  size: 14,
                  w: FontWeight.w800,
                  color: k.red,
                ),
              ],
            ),
          sMut(
            'Se muestran en tu perfil y en Explorar, para que más clientes vean tu trabajo.',
          ),
        ], gap: 8),
        FieldK(
          label: '¿Qué hiciste?',
          c: tx,
          lines: 3,
          hint: 'Ej.: Cambié el termopar y limpié el quemador.',
          err: tx.text.isNotEmpty && !ok && photos.isNotEmpty
              ? 'Cuéntale al cliente qué hiciste'
              : null,
          onChanged: (_) => setState(() {}),
        ),
        FieldK(
          label: 'Recomendación para el cliente',
          opt: true,
          c: rc,
          lines: 3,
          hint: 'Ej.: Dar mantenimiento cada año.',
        ),
        if (qq != null && rq != null)
          CardK(
            child: stack([
              bT(
                fin
                    ? '¿Ya tienes el precio final?'
                    : '¿Costó más de lo cotizado?',
              ),
              sMut(
                fin
                    ? 'Enviaste una visita para cotizar: propón aquí el precio del trabajo y el cliente lo aprueba.'
                    : 'Hasta ${money(pv.tTope(qq, rq.cat))} no necesitas aprobación. Si pasa de eso, el cliente debe aprobarlo antes.',
              ),
              if (vis.fin.isNotEmpty)
                Row(
                  spacing: 4,
                  children: [
                    if (vis.fin.contains('esperando aprobación'))
                      const CargaK(tipo: TipoCarga.puntos, size: 34)
                    else
                      Icon(icn('check'), size: 15, color: k.navy),
                    Expanded(
                      child: T(
                        vis.fin,
                        size: 14,
                        w: FontWeight.w800,
                        color: k.navy,
                      ),
                    ),
                  ],
                )
              else
                BtnK(
                  fin ? 'Enviar cotización final' : 'Proponer otro precio',
                  () => _adjust(vis, rq),
                  kind: Bk.sec,
                  sm: true,
                ),
            ], gap: 8),
          ),
        NoteK(
          'green',
          'star',
          'Al terminar, le pediremos a ${c.n.split(' ').first} que califique tu servicio. Su opinión saldrá como «Servicio verificado».',
        ),
      ], gap: 18),
      cta: BtnK(
        'Terminar servicio',
        ok
            ? () {
                pv.closeJob(vis.id, photos);
                context.go('/trabajo');
                exitoRapido(context);
              }
            : null,
      ),
    );
  });
}

// ------------------------------------------------------------ perfil público

class PerfilEditarScreen extends StatefulWidget {
  const PerfilEditarScreen({super.key});
  @override
  State<PerfilEditarScreen> createState() => _PerfilEditarState();
}

class _PerfilEditarState extends State<PerfilEditarScreen> {
  final name = TextEditingController(),
      business = TextEditingController(),
      years = TextEditingController(),
      other = TextEditingController(),
      address = TextEditingController(),
      about = TextEditingController();
  final sel = <String>{};
  bool otherOn = false, tried = false;
  String how = 'dom', km = '8 km';
  String? photo;
  final svcs = <Servicio>[];

  @override
  void initState() {
    super.initState();
    final m = pv.me;
    name.text = m.name;
    business.text = m.business;
    years.text = m.years;
    other.text = m.other;
    address.text = m.address;
    about.text = m.about;
    sel.addAll(m.cats);
    otherOn = m.otherOn;
    how = m.how;
    km = m.km;
    photo = m.photo;
    for (final s in m.svcs) {
      svcs.add(Servicio(s[0], s[2].replaceAll(RegExp(r'\D'), '')));
    }
  }

  @override
  void dispose() {
    for (final c in [name, business, years, other, address, about]) {
      c.dispose();
    }
    for (final s in svcs) {
      s.dispose();
    }
    super.dispose();
  }

  Map<String, String> _errors() {
    final e = <String, String>{};
    final n = clean(name.text);
    if (n.length < 3) {
      e['name'] = 'Escribe tu nombre completo';
    } else if (!RegExp(r"^[A-Za-zÁÉÍÓÚÜÑáéíóúüñ' .-]+$").hasMatch(n)) {
      e['name'] = 'Usa solo letras en tu nombre';
    } else if (n.split(' ').length < 2) {
      e['name'] = 'Escribe también tu apellido';
    }
    final ot = otherOn && other.text.trim().length >= 3;
    if (otherOn && !ot) e['other'] = 'Escribe cuál es tu oficio';
    if (sel.isEmpty && !ot) e['cats'] = 'Elige al menos un servicio';
    if (how == 'taller' && address.text.trim().length < 8) {
      e['address'] = 'Escribe calle, número y colonia';
    }
    advErrors(e, years.text.trim(), about.text, svcs);
    return e;
  }

  bool _save() {
    setState(() => tried = true);
    if (_errors().isNotEmpty) return false;
    final m = pv.me;
    final prev = m.svcs;
    m
      ..name = clean(name.text)
      ..business = clean(business.text)
      ..years = years.text.trim()
      ..cats = {...sel}
      ..otherOn = otherOn
      ..other = otherOn ? other.text.trim() : ''
      ..how = how
      ..km = km
      ..address = address.text.trim()
      ..about = about.text.trim()
      ..photo = photo;
    m.svcs = [
      for (var i = 0; i < svcs.length; i++)
        [
          svcs[i].n.text.trim(),
          (i < prev.length && prev[i][0] == svcs[i].n.text.trim())
              ? prev[i][1]
              : '',
          '\$${digits(svcs[i].p.text)}',
        ],
    ];
    pv.syncMe();
    maq.refresh();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final E = tried ? _errors() : <String, String>{};
    final taller = how == 'taller';
    const hd = [
      ['Lunes a viernes', '8:00 a 19:00'],
      ['Sábado', '9:00 a 14:00'],
      ['Domingo', 'Solo urgencias'],
    ];
    return Pg(
      title: 'Tu perfil público',
      body: stack([
        CardK(
          child: Row(
            spacing: 14,
            children: [
              Av(
                ini: initials(name.text),
                color: const Color(0xFF2A5568),
                size: 72,
                photo: photo,
              ),
              Expanded(
                child: stack([
                  bT('Tu foto'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      BtnK(
                        photo != null ? 'Cambiar' : 'Subir foto',
                        () async {
                          final f = await elegirFotos(varias: false);
                          if (f.isNotEmpty) setState(() => photo = f.first);
                        },
                        kind: Bk.sec,
                        sm: true,
                        auto: true,
                        icon: 'camera',
                      ),
                      if (photo != null)
                        BtnK(
                          'Quitar',
                          () => setState(() => photo = null),
                          kind: Bk.ghost,
                          sm: true,
                          auto: true,
                        ),
                    ],
                  ),
                  sMut('Se ve en tu perfil, en tus cotizaciones y en el chat.'),
                ], gap: 8),
              ),
            ],
          ),
        ),
        FieldK(
          label: 'Tu nombre completo',
          c: name,
          err: E['name'],
          onChanged: (_) => setState(() {}),
        ),
        FieldK(
          label: 'Nombre de tu negocio',
          opt: true,
          c: business,
          hint: 'Ej.: Plomería Mendoza',
        ),
        FieldK(
          label: 'Años de experiencia',
          opt: true,
          c: years,
          hint: 'Ej.: 8',
          keyboard: TextInputType.number,
          maxLen: 2,
          err: E['years'],
          onChanged: (_) => setState(() {}),
        ),
        tradesBlock(
          context,
          sel: sel,
          otherOn: otherOn,
          other: other,
          errCats: E['cats'],
          errOther: E['other'],
          toggle: (c) =>
              setState(() => sel.contains(c) ? sel.remove(c) : sel.add(c)),
          toggleOther: () => setState(() => otherOn = !otherOn),
          onChanged: () => setState(() {}),
        ),
        stack([
          labT('¿Cómo atiendes?'),
          ChoiceK(
            on: taller,
            onTap: () => setState(() => how = 'taller'),
            title: 'En mi taller o local',
            leading: Icon(icn('store')),
          ),
          ChoiceK(
            on: !taller,
            onTap: () => setState(() => how = 'dom'),
            title: 'A domicilio',
            leading: Icon(icn('house')),
          ),
        ], gap: 8),
        if (taller)
          FieldK(
            label: 'Dirección del taller',
            c: address,
            err: E['address'],
            onChanged: (_) => setState(() {}),
          )
        else
          stack([
            labT('¿Hasta dónde vas?'),
            chipsWrap([
              for (final x in const ['3 km', '5 km', '8 km', '12 km'])
                ChipK(x, on: km == x, onTap: () => setState(() => km = x)),
            ]),
          ], gap: 8),
        FieldK(
          label: 'Cómo te presentas',
          c: about,
          lines: 4,
          maxLen: 320,
          hint: 'Cuéntales a los clientes qué haces y por qué confiar en ti.',
          err: E['about'],
          help: '${about.text.length}/300',
          onChanged: (_) => setState(() {}),
        ),
        MisServiciosSegunSesion(
          ejemplo: CardK(
            child: stack([
              h3('Servicios y precio de referencia'),
              if (svcs.isEmpty) mutT('Aún no agregas servicios.'),
              serviciosEditor(
                context,
                svcs,
                E,
                () => setState(() {}),
                () => setState(() => svcs.add(Servicio('', ''))),
                (i) => setState(() => svcs.removeAt(i).dispose()),
              ),
            ], gap: 12),
          ),
        ),
        HorariosSegunSesion(
          ejemplo: GroupK([
            for (var i = 0; i < 3; i++)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  spacing: 14,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 2,
                        children: [
                          T(hd[i][0], w: FontWeight.w800),
                          sMut(pv.hours[i] ? hd[i][1] : 'Cerrado', size: 13.5),
                        ],
                      ),
                    ),
                    Sw(
                      on: pv.hours[i],
                      onTap: () {
                        pv.hours[i] = !pv.hours[i];
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
          ]),
        ),
        BtnK(
          'Ver cómo lo ven los clientes',
          () {
            if (_save()) {
              unawaited(context.push(RM.experto('me')));
            }
          },
          kind: Bk.ghost,
          icon: 'eye',
        ),
      ], gap: 18),
      cta: ctaCol([
        BtnK('Guardar cambios', () {
          if (_save()) {
            context.pop();
            maq.toast('Cambios guardados');
          }
        }),
        if (tried && E.isNotEmpty) helpT('Revisa los campos marcados en rojo'),
      ]),
    );
  }
}

// ------------------------------------------------------------ reputación

class ReputacionScreen extends StatefulWidget {
  const ReputacionScreen({super.key});
  @override
  State<ReputacionScreen> createState() => _ReputacionState();
}

class _ReputacionState extends State<ReputacionScreen> {
  String? open;
  final _rp = TextEditingController();
  @override
  void dispose() {
    _rp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaqBuilder((context) {
    final k = kc(context);
    final s = pv.stats;
    final lv = repLevel(s.done);
    final revs = pv.reviews;
    final avg = revs.isEmpty
        ? 0.0
        : revs.fold<int>(0, (a, r) => a + r.s) / revs.length;
    return Pg(
      title: 'Mi reputación',
      body: CargaInicial(
        clave: 'reputacion',
        esqueleto: const EsqueletoReputacion(),
        child: stack([
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: k.navyBg,
              borderRadius: BorderRadius.circular(22),
            ),
            child: stack([
              T(
                'Nivel ${lv.i + 1} de ${levels.length}',
                size: 14,
                w: FontWeight.w800,
                color: const Color(0xFFD5E3E8),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  T(lv.name, size: 26, w: FontWeight.w900, color: Colors.white),
                  revs.isNotEmpty
                      ? Row(
                          children: [
                            Text(
                              '★ ',
                              style: TextStyle(fontSize: 20, color: k.amber),
                            ),
                            T(
                              avg.toStringAsFixed(1),
                              size: 20,
                              w: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ],
                        )
                      : const T(
                          'Sin opiniones',
                          size: 20,
                          w: FontWeight.w900,
                          color: Colors.white,
                        ),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: LinearProgressIndicator(
                  value: lv.pct / 100,
                  minHeight: 10,
                  backgroundColor: const Color(0xFF122B3A),
                  color: k.amber,
                ),
              ),
              T(
                lv.next.isNotEmpty
                    ? '${s.done} trabajos terminados · te faltan ${lv.left} para ${lv.next}'
                    : 'Llegaste al nivel más alto',
                size: 14,
                w: FontWeight.w700,
                color: const Color(0xFFD5E3E8),
              ),
            ], gap: 10),
          ),
          stack([
            h3('Estadísticas'),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2.2,
              children: [
                for (final f in [
                  ('${s.sent}', 'cotizaciones enviadas'),
                  ('${s.accepted}', 'cotizaciones aceptadas'),
                  (
                    s.sent > 0
                        ? '${(s.accepted * 100 / s.sent).round()}%'
                        : '—',
                    'te eligen',
                  ),
                  ('${s.done}', 'trabajos terminados'),
                ])
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: k.bg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        T(f.$1, size: 17, w: FontWeight.w900),
                        sMut(f.$2, size: 12.5),
                      ],
                    ),
                  ),
              ],
            ),
          ], gap: 8),
          CardK(
            child: stack([
              h3('Opiniones recientes'),
              if (revs.isEmpty)
                mutT(
                  'Aún no tienes opiniones. Llegan cuando terminas tu primer trabajo.',
                )
              else
                for (final r in revs)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 8,
                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          Av(
                            ini: initials(r.n),
                            color: const Color(0xFF64748B),
                            size: 40,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [bT(r.n), sMut(r.w)],
                            ),
                          ),
                        ],
                      ),
                      Align(alignment: Alignment.centerLeft, child: Stars(r.s)),
                      T(r.t),
                      if (pv.replied[r.id] != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: k.bg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: rich(
                            '**Tu respuesta:** ${pv.replied[r.id]}',
                            size: 14.5,
                            w: FontWeight.w400,
                          ),
                        )
                      else if (open == r.id) ...[
                        FieldK(label: 'Tu respuesta', c: _rp, lines: 3),
                        BtnK(
                          'Publicar respuesta',
                          () {
                            pv.replied[r.id] = _rp.text.isEmpty
                                ? '¡Gracias! Cualquier cosa aquí estoy.'
                                : _rp.text;
                            open = null;
                            pv.syncMe();
                            maq.refresh();
                            maq.toast('Respuesta publicada');
                          },
                          kind: Bk.dark,
                          sm: true,
                        ),
                      ] else
                        BtnK(
                          'Responder',
                          () {
                            _rp.text =
                                '¡Gracias, ${r.n.split(' ').first}! Cualquier cosa aquí estoy.';
                            setState(() => open = r.id);
                          },
                          kind: Bk.sec,
                          sm: true,
                        ),
                    ],
                  ),
            ], gap: 14),
          ),
        ], gap: 18),
      ),
    );
  });
}
