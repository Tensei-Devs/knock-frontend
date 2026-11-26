import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/features/mi/mi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// «Mi casa y mi auto» con datos reales (spec 031, backend 041): la lista de la
/// persona con carga, vacío y error con Reintentar (CA-16), alta, edición, baja
/// e historial por páginas (CA-15). Un error deja abierto el formulario con lo
/// escrito (CA-05, CA-08, CA-11). No registra nombres ni años (CA-19).
class CasaYAutoReal extends ConsumerWidget {
  const CasaYAutoReal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(casaYAutoControllerProvider);
    final controlador = ref.read(casaYAutoControllerProvider.notifier);
    return stack([
      ...estado.when(
        loading: () => [sMut('Cargando tus cosas registradas…')],
        error: (_, _) => [
          Row(
            spacing: 12,
            children: [
              Expanded(
                child: T(
                  'No pudimos cargar tus cosas registradas.',
                  size: 14,
                  w: FontWeight.w800,
                  color: kc(context).red,
                ),
              ),
              BtnK(
                'Reintentar',
                controlador.reintentar,
                kind: Bk.sec,
                sm: true,
                auto: true,
              ),
            ],
          ),
        ],
        data: (elementos) => [
          if (elementos.isEmpty)
            sMut(
              'Agrega tu auto, el tinaco, el boiler o lo que quieras recordar para darle mantenimiento a tiempo.',
            )
          else
            GroupK([for (final e in elementos) _Fila(e)]),
          if (elementos.length < ReglasElemento.maximoElementos)
            BtnK(
              'Agregar',
              () => unawaited(abrirFormulario(context, ref)),
              kind: Bk.sec,
              icon: 'plus',
            ),
        ],
      ),
    ], gap: 12);
  }
}

class _Fila extends ConsumerWidget {
  const _Fila(this.elemento);

  final ElementoCasa elemento;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final k = kc(context);
    return Semantics(
      button: true,
      label: '${elemento.nombre}, ${nombreDeTipo(elemento.tipo)}',
      excludeSemantics: true,
      child: InkWell(
        onTap: () => unawaited(_acciones(context, ref, elemento)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              spacing: 14,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: k.navySoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icn(elemento.tipo == TipoElemento.auto ? 'car' : 'house'),
                    color: k.navy,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      T(elemento.nombre, w: FontWeight.w800),
                      sMut(
                        elemento.anio == null
                            ? nombreDeTipo(elemento.tipo)
                            : '${nombreDeTipo(elemento.tipo)} · ${elemento.anio}',
                        size: 13.5,
                      ),
                    ],
                  ),
                ),
                Icon(icn('chev'), color: k.mut),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Nombre del tipo para la persona.
String nombreDeTipo(TipoElemento tipo) => switch (tipo) {
  TipoElemento.auto => 'Auto',
  TipoElemento.electrodomestico => 'Electrodoméstico',
  TipoElemento.instalacion => 'Instalación',
  TipoElemento.otro => 'Otro',
};

/// Mensaje para cada error, sin detalles técnicos. [alta] distingue el 409 del
/// alta, que solo puede ser el límite de 20 (R-15).
String textoDeErrorCasa(Failure error, {bool alta = false}) => switch (error) {
  ConflictoFailure() when alta => 'Llegaste al máximo de 20 cosas registradas. Quita alguna para agregar otra.',
  NoEncontradoFailure() ||
  AccesoDenegadoFailure() => 'Eso ya no está disponible.',
  DatosRechazadosFailure() =>
    'Revisa los datos: el nombre (2 a 60 letras) y, en un auto, el año.',
  DemasiadosIntentosFailure() =>
    'Hiciste demasiados intentos. Espera un momento.',
  NoAutorizadoFailure() => 'Tu sesión venció. Entra de nuevo.',
  _ => 'No pudimos conectar. Revisa tu internet e intenta de nuevo.',
};

Future<void> _acciones(
  BuildContext context,
  WidgetRef ref,
  ElementoCasa elemento,
) => hoja<void>(
  context,
  (ctx, set) => stack([
    sheetH(ctx, elemento.nombre),
    BtnK(
      'Ver trabajos hechos',
      () {
        Navigator.pop(ctx);
        unawaited(abrirHistorial(context, ref, elemento));
      },
      kind: Bk.sec,
      icon: 'doc',
    ),
    BtnK(
      'Editar',
      () {
        Navigator.pop(ctx);
        unawaited(abrirFormulario(context, ref, elemento: elemento));
      },
      kind: Bk.sec,
      icon: 'edit',
    ),
    BtnK(
      'Quitar',
      () async {
        final error = await ref
            .read(casaYAutoControllerProvider.notifier)
            .quitar(elemento.id);
        if (ctx.mounted) Navigator.pop(ctx);
        maq.toast(error == null ? 'Quitado' : textoDeErrorCasa(error));
      },
      kind: Bk.ghost,
      icon: 'trash',
    ),
  ]),
);

/// Formulario de alta o edición. Valida con las reglas del backend antes de
/// enviar y, si el servidor rechaza, deja todo lo escrito (CA-05).
Future<void> abrirFormulario(
  BuildContext context,
  WidgetRef ref, {
  ElementoCasa? elemento,
}) => hoja<void>(context, (ctx, _) => _Formulario(elemento: elemento));

/// Dueño de sus campos: los libera al salir de la pantalla, después de la
/// animación de cierre de la hoja.
class _Formulario extends ConsumerStatefulWidget {
  const _Formulario({this.elemento});

  final ElementoCasa? elemento;

  @override
  ConsumerState<_Formulario> createState() => _FormularioState();
}

class _FormularioState extends ConsumerState<_Formulario> {
  late final _nombre = TextEditingController(
    text: widget.elemento?.nombre ?? '',
  );
  late final _anio = TextEditingController(
    text: widget.elemento?.anio?.toString() ?? '',
  );
  late var _tipo = widget.elemento?.tipo ?? TipoElemento.auto;
  String? _error;
  var _enviando = false;

  @override
  void dispose() {
    _nombre.dispose();
    _anio.dispose();
    super.dispose();
  }

  int? get _anioEnviado =>
      _tipo == TipoElemento.auto ? int.tryParse(_anio.text.trim()) : null;

  Future<void> _guardar() async {
    setState(() => _enviando = true);
    final elemento = widget.elemento;
    final controlador = ref.read(casaYAutoControllerProvider.notifier);
    final fallo = elemento == null
        ? await controlador.agregar(
            tipo: _tipo,
            nombre: _nombre.text,
            anio: _anioEnviado,
          )
        : await controlador.editar(
            elemento.id,
            tipo: _tipo,
            nombre: _nombre.text,
            anio: _anioEnviado,
          );
    if (!mounted) return;
    if (fallo == null) {
      Navigator.pop(context);
      maq.toast(elemento == null ? 'Agregado' : 'Guardado');
      return;
    }
    setState(() {
      _enviando = false;
      _error = textoDeErrorCasa(fallo, alta: elemento == null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final campo = ReglasElemento.validar(
      tipo: _tipo,
      nombre: _nombre.text,
      anio: _anioEnviado,
      hoy: DateTime.now(),
    );
    return stack([
      sheetH(
        context,
        widget.elemento == null ? 'Agregar a Mi casa y mi auto' : 'Editar',
      ),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final t in TipoElemento.values)
            ChipK(
              nombreDeTipo(t),
              on: t == _tipo,
              onTap: () => setState(() => _tipo = t),
            ),
        ],
      ),
      FieldK(
        label: _tipo == TipoElemento.auto ? 'Marca y modelo' : '¿Qué es?',
        c: _nombre,
        hint: _tipo == TipoElemento.auto
            ? 'Ej.: Nissan Versa'
            : 'Ej.: Boiler de gas',
        maxLen: ReglasElemento.nombreMaximo,
        onChanged: (_) => setState(() {}),
      ),
      if (_tipo == TipoElemento.auto)
        FieldK(
          label: 'Año',
          c: _anio,
          hint: 'Ej.: 2018',
          keyboard: TextInputType.number,
          maxLen: 4,
          err: campo == CampoElemento.anio && _anio.text.trim().length == 4
              ? 'Escribe un año entre ${ReglasElemento.anioMinimo} y ${ReglasElemento.anioMaximo(DateTime.now())}.'
              : null,
          onChanged: (_) => setState(() {}),
        ),
      if (_error != null)
        T(_error!, size: 14, w: FontWeight.w700, color: kc(context).red),
      BtnK(
        'Guardar',
        campo == null && !_enviando ? () => unawaited(_guardar()) : null,
        busy: _enviando,
      ),
    ]);
  }
}

/// Historial del elemento por páginas: «Ver más» pide la siguiente con el
/// cursor y nunca repite trabajos (CA-15).
Future<void> abrirHistorial(
  BuildContext context,
  WidgetRef ref,
  ElementoCasa elemento,
) {
  final historial = HistorialElemento(
    ref.read(casaYAutoRepositoryProvider),
    elemento.id,
  );
  var cargando = false;
  String? error;
  var primera = true;
  return hoja<void>(context, (ctx, set) {
    Future<void> cargar() async {
      set(() {
        cargando = true;
        error = null;
      });
      try {
        await historial.cargarMas();
      } on Failure catch (e) {
        error = textoDeErrorCasa(e);
      }
      if (ctx.mounted) set(() => cargando = false);
    }

    if (primera) {
      primera = false;
      unawaited(Future.microtask(cargar));
    }
    return stack([
      sheetH(ctx, 'Trabajos hechos · ${elemento.nombre}'),
      if (historial.trabajos.isEmpty &&
          !cargando &&
          error == null &&
          !historial.hayMas)
        sMut('Todavía no hay trabajos terminados para esto.'),
      for (final t in historial.trabajos)
        Row(
          spacing: 12,
          children: [
            Icon(icn('check'), color: kc(ctx).green),
            Expanded(
              child: T('${t.oficio} · ${t.tecnico}', w: FontWeight.w700),
            ),
            sMut('${t.fecha.day}/${t.fecha.month}/${t.fecha.year}', size: 13),
          ],
        ),
      if (error != null)
        T(error!, size: 14, w: FontWeight.w700, color: kc(ctx).red),
      if (cargando) sMut('Cargando…'),
      if (!cargando && historial.hayMas && historial.trabajos.isNotEmpty)
        BtnK('Ver más', () => unawaited(cargar()), kind: Bk.sec, sm: true),
      if (!cargando && error != null)
        BtnK('Reintentar', () => unawaited(cargar()), kind: Bk.sec, sm: true),
    ]);
  });
}
