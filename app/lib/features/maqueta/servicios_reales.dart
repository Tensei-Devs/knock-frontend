import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/features/actividad/actividad.dart'
    show solicitudesRealesActivasProvider;
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/explorar_real.dart' show fechaDeCopia;
import 'package:app/features/maqueta/oficios_reales.dart';
import 'package:app/features/maqueta/rutas_tecnico.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/features/tecnico/tecnico.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Con sesión y API, los servicios propios del servidor; sin ellas, el editor
/// de [ejemplo].
class MisServiciosSegunSesion extends ConsumerWidget {
  const MisServiciosSegunSesion({super.key, required this.ejemplo});

  final Widget ejemplo;

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(solicitudesRealesActivasProvider)
      ? const CardK(child: MisServiciosReales())
      : ejemplo;
}

String _precio(AppLocalizations textos, ServicioTecnico s) =>
    textos.serviciosPrecioDesde(s.precioReferencia);

String _textoDeRechazo(AppLocalizations textos, RechazoDeServicio rechazo) {
  if (rechazo == RechazoDeServicio.limite) return textos.serviciosLimite;
  if (rechazo == RechazoDeServicio.noExiste) return textos.serviciosNoExiste;
  if (rechazo == RechazoDeServicio.oficioNoValido) {
    return textos.serviciosOficioNoValido;
  }
  return textos.serviciosSinPerfil;
}

String _nombreDeOficio(AppLocalizations textos, String clave) =>
    switch (clave) {
      'mec' => textos.serviciosOficioMecanica,
      'plo' => textos.serviciosOficioPlomeria,
      'ele' => textos.serviciosOficioElectricidad,
      _ => clave,
    };

/// «Servicios y precio de referencia» de «Tu perfil público» (spec 037, SRV-02
/// a SRV-04). Si la cuenta no tiene perfil de técnico no muestra datos y
/// ofrece crearlo (enmienda del 2026-11-26).
class MisServiciosReales extends ConsumerStatefulWidget {
  const MisServiciosReales({super.key});

  @override
  ConsumerState<MisServiciosReales> createState() => _MisServiciosState();
}

class _MisServiciosState extends ConsumerState<MisServiciosReales> {
  /// El formulario abierto: `null` cerrado; sin `editando`, es un alta.
  ({ServicioTecnico? editando})? _formulario;
  bool _sinPerfil = false;

  MisServiciosController get _control =>
      ref.read(misServiciosControllerProvider.notifier);

  /// Devuelve el texto del error, o `null` si se guardó. Lo escrito se
  /// conserva mientras haya error.
  Future<String?> _guardar(DatosDeServicio datos, String? id) async {
    final textos = AppLocalizations.of(context);
    try {
      final rechazo = await _control.guardar(datos, id: id);
      if (!mounted) return null;
      if (rechazo == RechazoDeServicio.sinPerfilDeTecnico) {
        setState(() => _sinPerfil = true);
        return null;
      }
      if (rechazo != null) return _textoDeRechazo(textos, rechazo);
      setState(() => _formulario = null);
      return null;
    } on Failure catch (falla) {
      return mensajeDeError(textos, falla);
    }
  }

  Future<void> _quitar(String id) async {
    final textos = AppLocalizations.of(context);
    try {
      final rechazo = await _control.quitar(id);
      if (!mounted || rechazo == null) return;
      if (rechazo == RechazoDeServicio.sinPerfilDeTecnico) {
        setState(() => _sinPerfil = true);
      } else {
        maq.toast(_textoDeRechazo(textos, rechazo));
      }
    } on Failure catch (falla) {
      maq.toast(mensajeDeError(textos, falla));
    }
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final estado = ref.watch(misServiciosControllerProvider);
    final titulo = h3(textos.serviciosTituloPropio);
    if (_sinPerfil) {
      return stack([
        titulo,
        NoteK('amber', 'help', textos.serviciosSinPerfil),
        BtnK(
          textos.serviciosCrearPerfil,
          () => unawaited(context.push(RT.registro)),
        ),
      ], gap: 12);
    }
    return stack([
      titulo,
      ...estado.when(
        loading: () => [sMut(textos.serviciosCargandoPropios)],
        error: (error, _) => [
          NoteK(
            'red',
            'help',
            error is ServicioNoDisponibleFailure
                ? textos.errorSinConexion
                : textos.serviciosErrorPropios,
          ),
          BtnK(textos.serviciosReintentar, _control.reintentar, kind: Bk.sec),
        ],
        data: _datos,
      ),
    ], gap: 12);
  }

  List<Widget> _datos(MisServicios mios) {
    final textos = AppLocalizations.of(context);
    final abierto = _formulario;
    return [
      if (!mios.listaCompleta)
        sMut(textos.serviciosListaParcial)
      else if (mios.items.isEmpty)
        sMut(textos.serviciosVacioPropios),
      for (final s in mios.items)
        _FilaDeServicio(
          s,
          acciones: [
            BtnK(
              textos.serviciosEditar,
              () => setState(() => _formulario = (editando: s)),
              kind: Bk.ghost,
              sm: true,
              auto: true,
            ),
            BtnK(
              textos.serviciosQuitar,
              () => unawaited(_quitar(s.id)),
              kind: Bk.ghost,
              sm: true,
              auto: true,
            ),
          ],
        ),
      if (abierto == null)
        BtnK(
          textos.serviciosAgregar,
          () => setState(() => _formulario = (editando: null)),
          kind: Bk.ghost,
          sm: true,
          icon: 'plus',
        )
      else
        FormularioDeServicio(
          key: ValueKey(abierto.editando?.id ?? 'nuevo'),
          inicial: abierto.editando,
          guardar: (datos) => _guardar(datos, abierto.editando?.id),
          cancelar: () => setState(() => _formulario = null),
        ),
    ];
  }
}

class _FilaDeServicio extends StatelessWidget {
  const _FilaDeServicio(this.servicio, {this.acciones = const []});

  final ServicioTecnico servicio;
  final List<Widget> acciones;

  @override
  Widget build(BuildContext context) {
    final detalle = servicio.detalle?.trim() ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        T(servicio.nombre, w: FontWeight.w800),
        if (detalle.isNotEmpty) sMut(detalle, size: 13.5),
        T(
          _precio(AppLocalizations.of(context), servicio),
          w: FontWeight.w900,
          color: kc(context).navy,
        ),
        if (acciones.isNotEmpty) Wrap(spacing: 8, children: acciones),
      ],
    );
  }
}

/// Alta o edición de un servicio. Los controladores se liberan en `dispose`.
class FormularioDeServicio extends StatefulWidget {
  const FormularioDeServicio({
    super.key,
    required this.guardar,
    required this.cancelar,
    this.inicial,
  });

  final ServicioTecnico? inicial;
  final Future<String?> Function(DatosDeServicio) guardar;
  final VoidCallback cancelar;

  @override
  State<FormularioDeServicio> createState() => _FormularioState();
}

class _FormularioState extends State<FormularioDeServicio> {
  late final _nombre = TextEditingController(text: widget.inicial?.nombre);
  late final _detalle = TextEditingController(text: widget.inicial?.detalle);
  late final _precioTexto = TextEditingController(
    text: widget.inicial?.precioReferencia.toString(),
  );
  late String? _oficio = widget.inicial?.oficio;
  Map<String, String> _errores = const {};
  String? _errorDelServidor;
  bool _guardando = false;

  @override
  void dispose() {
    _nombre.dispose();
    _detalle.dispose();
    _precioTexto.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    final textos = AppLocalizations.of(context);
    final nombre = _nombre.text.trim();
    final precio = int.tryParse(_precioTexto.text.trim());
    final oficio = _oficio;
    final errores = {
      if (nombre.isEmpty) 'nombre': textos.serviciosErrorNombre,
      if (nombre.length > DatosDeServicio.maxNombre)
        'nombre': textos.serviciosErrorNombreMax(DatosDeServicio.maxNombre),
      if (_detalle.text.trim().length > DatosDeServicio.maxDetalle)
        'detalle': textos.serviciosErrorDetalleMax(DatosDeServicio.maxDetalle),
      if (precio == null || precio <= 0 || precio > DatosDeServicio.maxPrecio)
        'precio': textos.serviciosErrorPrecio,
      if (oficio == null) 'oficio': textos.serviciosErrorOficio,
    };
    setState(() {
      _errores = errores;
      _errorDelServidor = null;
    });
    if (errores.isNotEmpty || _guardando) return;
    setState(() => _guardando = true);
    final error = await widget.guardar(
      DatosDeServicio(
        nombre: nombre,
        detalle: _detalle.text,
        precioReferencia: precio!,
        oficio: oficio!,
      ),
    );
    if (!mounted) return;
    setState(() {
      _guardando = false;
      _errorDelServidor = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    return stack([
      FieldK(
        label: textos.serviciosNombre,
        c: _nombre,
        hint: textos.serviciosNombreEjemplo,
        maxLen: DatosDeServicio.maxNombre,
        err: _errores['nombre'],
      ),
      FieldK(
        label: textos.serviciosDetalle,
        opt: true,
        c: _detalle,
        lines: 2,
        maxLen: DatosDeServicio.maxDetalle,
        err: _errores['detalle'],
      ),
      FieldK(
        label: textos.serviciosPrecio,
        c: _precioTexto,
        hint: '250',
        keyboard: TextInputType.number,
        maxLen: 10,
        err: _errores['precio'],
      ),
      labT(textos.serviciosOficioPregunta),
      if (maq.oficiosError && maq.oficios.isEmpty) const AvisoOficios(),
      chipsWrap([
        for (final clave in maq.oficios)
          SizedBox(
            height: 48,
            child: ChipK(
              _nombreDeOficio(textos, clave),
              on: _oficio == clave,
              onTap: () => setState(() => _oficio = clave),
            ),
          ),
      ]),
      if (_errores['oficio'] != null) helpT(_errores['oficio']!),
      if (_errorDelServidor != null) NoteK('red', 'help', _errorDelServidor!),
      BtnK(
        textos.serviciosGuardar,
        () => unawaited(_enviar()),
        busy: _guardando,
      ),
      BtnK(textos.serviciosCancelar, widget.cancelar, kind: Bk.ghost, sm: true),
    ], gap: 10);
  }
}

/// «Servicios y precios» del perfil de un técnico real (spec 037, SRV-01):
/// carga, vacío, error con Reintentar y la última copia sin conexión con su
/// fecha.
class ServiciosDeTecnicoReal extends ConsumerWidget {
  const ServiciosDeTecnicoReal({super.key, required this.tecnicoId});

  final String tecnicoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = AppLocalizations.of(context);
    final proveedor = serviciosDeTecnicoProvider(tecnicoId);
    final reintentar = BtnK(
      textos.serviciosReintentar,
      () => ref.invalidate(proveedor),
      kind: Bk.sec,
    );
    return CardK(
      child: stack([
        h3(textos.serviciosTituloPublico),
        ...ref
            .watch(proveedor)
            .when(
              loading: () => [sMut(textos.serviciosCargandoPublicos)],
              error: (error, _) => [
                NoteK('red', 'help', switch (error) {
                  NoEncontradoFailure() => textos.serviciosNoDisponible,
                  ServicioNoDisponibleFailure() => textos.errorSinConexion,
                  _ => textos.serviciosErrorPublicos,
                }),
                reintentar,
              ],
              data: (vistos) => [
                if (vistos.copiaDel != null) ...[
                  NoteK(
                    'amber',
                    'help',
                    textos.serviciosCopia(fechaDeCopia(vistos.copiaDel!)),
                  ),
                  reintentar,
                ],
                if (vistos.items.isEmpty) ...[
                  sMut(textos.serviciosVacioPublico),
                  if (vistos.copiaDel == null) reintentar,
                ] else ...[
                  for (final s in vistos.items) _FilaDeServicio(s),
                  sMut(textos.serviciosReferencia),
                ],
              ],
            ),
      ], gap: 12),
    );
  }
}
