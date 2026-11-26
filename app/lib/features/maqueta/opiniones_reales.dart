import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/features/actividad/actividad.dart'
    show solicitudesRealesActivasProvider;
import 'package:app/features/maqueta/servicios_reales.dart';
import 'package:app/features/maqueta/confianza_real.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/explorar_real.dart' show fechaDeCopia;
import 'package:app/features/maqueta/nav.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/features/opiniones/opiniones.dart';
import 'package:app/features/tecnicos_confianza/tecnicos_confianza.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Carga, error con Reintentar y última copia de las opiniones de un técnico
/// (spec 041, CA-05, CA-12 y CA-13).
class _EstadoDeOpiniones extends ConsumerWidget {
  const _EstadoDeOpiniones(this.tecnicoId, this.datos);

  final String tecnicoId;
  final List<Widget> Function(PaginaOpiniones) datos;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = AppLocalizations.of(context);
    final proveedor = opinionesControllerProvider(tecnicoId);
    final reintentar = ref.read(proveedor.notifier).reintentar;
    Widget aviso(String clase, String texto) => stack([
      NoteK(clase, 'help', texto),
      BtnK(textos.opinionesReintentar, reintentar, kind: Bk.sec),
    ], gap: 8);
    return ref
        .watch(proveedor)
        .when(
          skipLoadingOnRefresh: false,
          loading: () => sMut(textos.opinionesCargando),
          error: (e, _) => aviso('red', switch (e) {
            NoEncontradoFailure() => textos.opinionesNoDisponible,
            ServicioNoDisponibleFailure() => textos.errorSinConexion,
            _ => textos.opinionesError,
          }),
          data: (vista) => stack([
            if (vista.copiaDel case final fecha?)
              aviso('amber', textos.opinionesCopia(fechaDeCopia(fecha))),
            ...datos(vista.pagina),
          ], gap: 12),
        );
  }
}

/// Promedio, total y distribución por estrellas.
class _Resumen extends StatelessWidget {
  const _Resumen(this.resumen);

  final ResumenDeOpiniones resumen;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    return CardK(
      child: stack([
        if (resumen.promedio case final promedio?)
          T(
            textos.opinionesPromedio(promedio.toStringAsFixed(1)),
            size: 26,
            w: FontWeight.w900,
          ),
        sMut(textos.opinionesTotal(resumen.total)),
        for (var n = 5; n >= 1; n--)
          sMut(textos.opinionesEstrellas(n, resumen.distribucion[n] ?? 0)),
      ], gap: 4),
    );
  }
}

class _Tarjeta extends StatelessWidget {
  const _Tarjeta(this.opinion);

  final Opinion opinion;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final partes = opinion.partes;
    return CardK(
      child: stack([
        Align(
          alignment: Alignment.centerLeft,
          child: Stars(opinion.calificacion),
        ),
        sMut(
          MaterialLocalizations.of(context)
              .formatMediumDate(opinion.creadoEn.toLocal()),
        ),
        if (opinion.anonimizada) sMut(textos.opinionesAnonima),
        if (opinion.comentario case final comentario?) T(comentario),
        if (partes != null)
          for (final (nombre, valor) in [
            (textos.opinionesPuntualidad, partes.puntualidad),
            (textos.opinionesCalidad, partes.calidad),
            (textos.opinionesPrecioJusto, partes.precioJusto),
            (textos.opinionesTrato, partes.trato),
          ])
            if (valor != null) sMut('$nombre: $valor ★'),
        if (opinion.servicioVerificado)
          Align(
            alignment: Alignment.centerLeft,
            child: Pill(textos.opinionesServicioVerificado, kind: 'green'),
          ),
        if (opinion.respuesta case final respuesta?)
          sMut(textos.opinionesRespuesta(respuesta.texto)),
      ], gap: 6),
    );
  }
}

/// «Opiniones» de un técnico real (OPI-01): resumen, lista y «Ver más».
class OpinionesReales extends ConsumerWidget {
  const OpinionesReales({super.key, required this.tecnicoId});

  final String tecnicoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = AppLocalizations.of(context);
    return _EstadoDeOpiniones(
      tecnicoId,
      (pagina) => [
        if (pagina.items.isEmpty)
          sMut(textos.opinionesVacio)
        else ...[
          _Resumen(pagina.resumen),
          for (final o in pagina.items) _Tarjeta(o),
        ],
        if (pagina.siguiente != null)
          BtnK(textos.opinionesVerMas, () async {
            final falla = await ref
                .read(opinionesControllerProvider(tecnicoId).notifier)
                .cargarMas();
            if (falla != null && context.mounted) {
              maq.toast(mensajeDeError(textos, falla));
            }
          }, kind: Bk.ghost),
      ],
    );
  }
}

/// El perfil de un técnico real: solo lo que manda el servidor y sus opiniones
/// (spec 041). El resto del perfil llega con TEC-05 (spec 036).
class PerfilTecnicoReal extends ConsumerWidget {
  const PerfilTecnicoReal({
    super.key,
    required this.tecnicoId,
    required this.idDeMaqueta,
    required this.nombre,
    required this.verificado,
    required this.alPedir,
  });

  final String tecnicoId;
  final String idDeMaqueta;
  final String nombre;
  final bool verificado;
  final VoidCallback alPedir;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = AppLocalizations.of(context);
    final activas = ref.watch(solicitudesRealesActivasProvider);
    return Pg(
      right: activas
          ? GuardarTecnicoReal(
              tecnicoId: tecnicoId,
              destino: RM.experto(idDeMaqueta),
            )
          : null,
      body: stack([
        T(nombre, size: 24, w: FontWeight.w900, align: TextAlign.center),
        if (verificado)
          const Center(
            child: Pill(
              'Identidad verificada',
              kind: 'green',
              icon: 'shield',
              size: 14,
            ),
          ),
        // Servicios y precios de referencia (spec 037, SRV-01).
        if (activas) ServiciosDeTecnicoReal(tecnicoId: tecnicoId),
        if (activas)
          _EstadoDeOpiniones(
            tecnicoId,
            (pagina) => [
              if (pagina.items.isEmpty)
                sMut(textos.opinionesVacio)
              else ...[
                _Resumen(pagina.resumen),
                BtnK(
                  textos.opinionesVerTodas,
                  () => context.push(RM.opiniones(idDeMaqueta)),
                  kind: Bk.sec,
                ),
              ],
            ],
          )
        else
          BtnK(
            'Iniciar sesión para ver más',
            () => pedirCuenta(context, RM.experto(idDeMaqueta)),
            kind: Bk.sec,
          ),
      ], gap: 12),
      cta: BtnK('Pedir cotización', alPedir),
    );
  }
}

/// «Calificar» una visita terminada de una solicitud real (OPI-02). Un error
/// deja intacto lo escrito (CA-08); nunca reintenta solo.
class CalificarReal extends ConsumerStatefulWidget {
  const CalificarReal({
    super.key,
    required this.visitaId,
    required this.trabajo,
  });

  final String visitaId;
  final String trabajo;

  @override
  ConsumerState<CalificarReal> createState() => _CalificarRealState();
}

class _CalificarRealState extends ConsumerState<CalificarReal> {
  int _general = 0;
  final _partes = <int, int>{};
  bool _guardar = false;
  bool _enviando = false;
  String? _error;
  final _comentario = TextEditingController();

  @override
  void dispose() {
    _comentario.dispose();
    super.dispose();
  }

  Future<void> _publicar() async {
    if (_enviando) return;
    final textos = AppLocalizations.of(context);
    setState(() {
      _enviando = true;
      _error = null;
    });
    try {
      await ref
          .read(opinionesRepositoryProvider)
          .calificar(
            widget.visitaId,
            NuevaOpinion(
              calificacion: _general,
              partes: PartesDeOpinion(
                puntualidad: _partes[0],
                calidad: _partes[1],
                precioJusto: _partes[2],
                trato: _partes[3],
              ),
              comentario: _comentario.text,
              guardarTecnicoConfianza: _guardar,
            ),
          );
    } on Failure catch (falla) {
      if (!mounted) return;
      setState(() {
        _enviando = false;
        _error = falla is NoEncontradoFailure
            ? textos.opinionesVisitaNoDisponible
            : mensajeDeError(textos, falla);
      });
      return;
    }
    if (!mounted) return;
    if (_guardar) ref.invalidate(tecnicosConfianzaControllerProvider);
    maq.reintentarSolicitudes?.call();
    context.go('/actividad');
    maq.toast(textos.opinionesEnviada);
  }

  Widget _estrellas(
    int valor,
    String Function(int) etiqueta,
    ValueChanged<int> alElegir,
  ) => Wrap(
    alignment: WrapAlignment.center,
    children: [
      for (var n = 1; n <= 5; n++)
        Semantics(
          button: true,
          selected: n == valor,
          label: etiqueta(n),
          excludeSemantics: true,
          onTap: () => alElegir(n),
          child: InkWell(
            onTap: () => alElegir(n),
            child: SizedBox(
              width: 48,
              height: 48,
              child: Icon(
                n <= valor ? Icons.star_rounded : Icons.star_outline_rounded,
                size: 36,
                color: n <= valor ? kc(context).amber : kc(context).mut,
              ),
            ),
          ),
        ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final nombres = [
      textos.opinionesPuntualidad,
      textos.opinionesCalidad,
      textos.opinionesPrecioJusto,
      textos.opinionesTrato,
    ];
    return Pg(
      title: textos.opinionesCalificarTitulo,
      body: stack([
        h1(textos.opinionesCalificarPregunta, a: TextAlign.center),
        sMut(widget.trabajo, a: TextAlign.center),
        _estrellas(
          _general,
          textos.opinionesEstrellaBoton,
          (n) => setState(() => _general = n),
        ),
        FieldK(
          label: textos.opinionesComentario,
          opt: true,
          c: _comentario,
          lines: 3,
          maxLen: NuevaOpinion.largoComentario,
        ),
        labT(textos.opinionesPorPartes),
        for (var i = 0; i < nombres.length; i++)
          Column(
            children: [
              bT(nombres[i]),
              _estrellas(
                _partes[i] ?? 0,
                (n) => textos.opinionesParteBoton(nombres[i], n),
                (n) => setState(() => _partes[i] = n),
              ),
            ],
          ),
        ChoiceK(
          on: _guardar,
          check: true,
          onTap: () => setState(() => _guardar = !_guardar),
          title: textos.opinionesGuardarConfianza,
        ),
        if (_error case final error?) NoteK('red', 'help', error),
      ], gap: 16),
      cta: ctaCol([
        BtnK(
          _enviando ? textos.opinionesPublicando : textos.opinionesPublicar,
          _general == 0 || _enviando ? null : _publicar,
        ),
        if (_general == 0) helpT(textos.opinionesElige),
      ]),
    );
  }
}
