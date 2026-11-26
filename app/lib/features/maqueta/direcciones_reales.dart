import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/features/direcciones/direcciones.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 403 y 404 dicen lo mismo: la dirección «no está disponible» (spec 030 §6).
String _textoDeFalla(AppLocalizations l, Object falla) =>
    falla is NoEncontradoFailure || falla is AccesoDenegadoFailure
    ? l.direccionesNoDisponible
    : mensajeDeError(l, falla);

/// Sin calle ni número: en las listas solo van la colonia y las referencias
/// (spec 030, D-03).
String _resumen(AppLocalizations l, Direccion d) {
  final referencias = d.referencias?.trim() ?? '';
  return referencias.isEmpty ? l.direccionesSinReferencias : referencias;
}

/// Carga, error o sin conexión con Reintentar, y datos (CA-12 y CA-13). El
/// vacío lo dibuja cada pantalla en [datos].
Widget _estados(
  BuildContext context,
  WidgetRef ref, {
  required Widget Function(List<Direccion>) datos,
}) {
  final l = AppLocalizations.of(context);
  return ref
      .watch(direccionesControllerProvider)
      .when(
        loading: () => sMut(l.direccionesCargando),
        error: (error, _) => stack([
          NoteK(
            'red',
            'help',
            '${l.direccionesError} ${_textoDeFalla(l, error)}',
          ),
          BtnK(
            l.direccionesReintentar,
            ref.read(direccionesControllerProvider.notifier).reintentar,
            kind: Bk.sec,
          ),
        ], gap: 12),
        data: datos,
      );
}

/// «Mis direcciones» dentro de «Mis datos»: ver, agregar, editar y eliminar
/// (DIR-01 a DIR-04).
class DireccionesReales extends ConsumerWidget {
  const DireccionesReales({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return stack([
      labT(l.direccionesTitulo),
      _estados(
        context,
        ref,
        datos: (lista) => stack([
          if (lista.isEmpty) sMut(l.direccionesVacio),
          for (final d in lista)
            CardK(
              child: stack([
                Row(
                  spacing: 10,
                  children: [
                    Expanded(child: bT(d.colonia)),
                    if (d.principal)
                      Pill(l.direccionesPrincipal, kind: 'amber'),
                  ],
                ),
                sMut(_resumen(l, d)),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    BtnK(
                      l.direccionesEditar,
                      () => editarDireccion(context, d),
                      kind: Bk.sec,
                      auto: true,
                    ),
                    BtnK(
                      l.direccionesEliminar,
                      () => _confirmarEliminar(context, d),
                      kind: Bk.ghost,
                      auto: true,
                    ),
                  ],
                ),
              ], gap: 8),
            ),
          BtnK(
            l.direccionesAgregar,
            () => editarDireccion(context, null),
            kind: Bk.sec,
          ),
        ], gap: 10),
      ),
    ], gap: 8);
  }
}

/// «¿Dónde?» del paso 3 de «Pedir cotización»: elegir o agregar (DIR-01 y
/// DIR-02).
class DireccionAlPedirReal extends ConsumerWidget {
  const DireccionAlPedirReal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final elegida = ref.watch(direccionParaPedirProvider);
    return _estados(
      context,
      ref,
      datos: (lista) => stack([
        if (lista.isEmpty) sMut(l.direccionesVacio),
        for (final d in lista)
          ChoiceK(
            on: d.id == elegida?.id,
            minH: 64,
            onTap: () =>
                ref.read(direccionElegidaProvider.notifier).elegir(d.id),
            title: d.colonia,
            sub: _resumen(l, d),
          ),
        BtnK(
          l.direccionesAgregar,
          () => editarDireccion(context, null),
          kind: Bk.sec,
        ),
      ], gap: 8),
    );
  }
}

/// Abre el formulario de [actual], o el de una dirección nueva si es `null`.
void editarDireccion(BuildContext context, Direccion? actual) {
  unawaited(
    hoja<void>(context, (_, _) => _FormularioDireccion(actual: actual)),
  );
}

class _FormularioDireccion extends ConsumerStatefulWidget {
  const _FormularioDireccion({required this.actual});

  final Direccion? actual;

  @override
  ConsumerState<_FormularioDireccion> createState() => _FormularioState();
}

class _FormularioState extends ConsumerState<_FormularioDireccion> {
  late final _calle = TextEditingController(text: widget.actual?.calleNumero);
  late final _referencias = TextEditingController(
    text: widget.actual?.referencias,
  );

  /// Una dirección nueva usa la colonia elegida en la spec 017 (D-03).
  late String _colonia = widget.actual?.colonia ?? maq.user.col;
  late bool _principal = widget.actual?.principal ?? false;
  bool _enviando = false;
  Failure? _falla;

  @override
  void dispose() {
    _calle.dispose();
    _referencias.dispose();
    super.dispose();
  }

  /// Si falla, la hoja sigue abierta con lo escrito (CA-05, CA-08).
  Future<void> _guardar() async {
    if (_enviando) return;
    setState(() {
      _enviando = true;
      _falla = null;
    });
    final control = ref.read(direccionesControllerProvider.notifier);
    final actual = widget.actual;
    final referencias = _referencias.text.trim();
    final falla = actual == null
        ? await control.crear(
            DireccionNueva(
              calleNumero: _calle.text,
              colonia: _colonia,
              referencias: referencias.isEmpty ? null : referencias,
              principal: _principal,
            ),
          )
        : await control.editar(
            actual.id,
            CambiosDireccion(
              calleNumero: _calle.text,
              colonia: _colonia,
              referencias: referencias,
              principal: _principal,
            ),
          );
    if (!mounted) return;
    if (falla == null) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _enviando = false;
      _falla = falla;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    // La lista sigue viva mientras la hoja está abierta.
    ref.watch(direccionesControllerProvider);
    final completa =
        _calle.text.trim().isNotEmpty && _colonia.trim().isNotEmpty;
    return stack([
      sheetH(
        context,
        widget.actual == null ? l.direccionesNueva : l.direccionesEditarTitulo,
      ),
      FieldK(
        label: l.direccionesCalle,
        c: _calle,
        onChanged: (_) => setState(() {}),
      ),
      FieldK(label: l.direccionesReferencias, c: _referencias),
      sMut(l.direccionesColonia(_colonia)),
      if (maq.user.col.isNotEmpty && maq.user.col != _colonia)
        LinkK(
          l.direccionesCambiarColonia(maq.user.col),
          () => setState(() => _colonia = maq.user.col),
        ),
      ChoiceK(
        on: _principal,
        check: true,
        minH: 56,
        onTap: () => setState(() => _principal = !_principal),
        title: l.direccionesMarcarPrincipal,
      ),
      if (_falla case final falla?)
        NoteK('red', 'help', _textoDeFalla(l, falla)),
      BtnK(
        _enviando ? l.direccionesGuardando : l.direccionesGuardar,
        completa ? _guardar : null,
        busy: _enviando,
      ),
    ]);
  }
}

void _confirmarEliminar(BuildContext context, Direccion direccion) {
  unawaited(hoja<void>(context, (_, _) => _Eliminar(direccion: direccion)));
}

class _Eliminar extends ConsumerStatefulWidget {
  const _Eliminar({required this.direccion});

  final Direccion direccion;

  @override
  ConsumerState<_Eliminar> createState() => _EliminarState();
}

class _EliminarState extends ConsumerState<_Eliminar> {
  bool _enviando = false;
  Failure? _falla;

  Future<void> _eliminar() async {
    if (_enviando) return;
    setState(() => _enviando = true);
    final falla = await ref
        .read(direccionesControllerProvider.notifier)
        .eliminar(widget.direccion.id);
    if (!mounted) return;
    if (falla == null) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _enviando = false;
      _falla = falla;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    ref.watch(direccionesControllerProvider);
    return stack([
      sheetH(context, l.direccionesConfirmarEliminar),
      sMut('${widget.direccion.colonia} · ${_resumen(l, widget.direccion)}'),
      if (_falla case final falla?)
        NoteK('red', 'help', _textoDeFalla(l, falla)),
      BtnK(l.direccionesEliminar, _eliminar, kind: Bk.dark, busy: _enviando),
      BtnK(
        l.direccionesCancelar,
        () => Navigator.of(context).pop(),
        kind: Bk.ghost,
      ),
    ]);
  }
}
