import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/core/sesion/sesion_provider.dart';
import 'package:app/core/sesion/verificador_celular.dart';
import 'package:app/features/cuenta/cuenta.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum _Paso { numero, codigo, enviado }

/// La hoja real de «Cambiar mi número» y de «¿Ya no tienes ese número?» (spec
/// 029): Firebase manda el SMS al número nuevo y la API confirma el cambio o
/// recibe el caso de recuperación.
class HojaDeNumeroReal extends ConsumerStatefulWidget {
  const HojaDeNumeroReal({super.key, required this.recuperar});

  final bool recuperar;

  @override
  ConsumerState<HojaDeNumeroReal> createState() => _HojaDeNumeroState();
}

class _HojaDeNumeroState extends ConsumerState<HojaDeNumeroReal> {
  final _anterior = TextEditingController();
  final _nuevo = TextEditingController();
  final _codigo = TextEditingController();
  TipoDeCuenta _tipo = TipoDeCuenta.cliente;
  _Paso _paso = _Paso.numero;
  SolicitudCodigo? _solicitud;

  /// La prueba de Firebase: si falla la API, no se pide otro código.
  String? _prueba;
  bool _ocupado = false;
  String? _error;

  @override
  void dispose() {
    _anterior.dispose();
    _nuevo.dispose();
    _codigo.dispose();
    super.dispose();
  }

  String _diez(TextEditingController c) => c.text.replaceAll(RegExp(r'\D'), '');

  bool get _listo => switch (_paso) {
    _Paso.numero =>
      _diez(_nuevo).length == 10 &&
          (!widget.recuperar || _diez(_anterior).length == 10),
    _Paso.codigo => _prueba != null || _diez(_codigo).length == 6,
    _Paso.enviado => true,
  };

  Future<void> _hacer(Future<void> Function() accion) async {
    if (_ocupado) return;
    final textos = AppLocalizations.of(context);
    setState(() {
      _ocupado = true;
      _error = null;
    });
    try {
      await accion();
    } on Failure catch (falla) {
      _error = falla is ConflictoFailure
          ? textos.cuentaNumeroEnUso
          : mensajeDeError(textos, falla);
    }
    if (mounted) setState(() => _ocupado = false);
  }

  Future<void> _pedirCodigo() => _hacer(() async {
    if (!widget.recuperar) {
      await ref.read(numeroRepositoryProvider).comprobar('+52${_diez(_nuevo)}');
    }
    _solicitud = await ref
        .read(verificadorCelularProvider)
        .enviarCodigo(_diez(_nuevo), anterior: _solicitud);
    _prueba = null;
    _codigo.clear();
    _paso = _Paso.codigo;
  });

  Future<void> _confirmar() => _hacer(() async {
    final textos = AppLocalizations.of(context);
    final verificador = ref.read(verificadorCelularProvider);
    final repo = ref.read(numeroRepositoryProvider);
    if (_prueba == null) {
      _prueba = await verificador.tokenDeId(_solicitud!, _diez(_codigo));
      // La app usa su propia sesión; la de Firebase no se necesita.
      try {
        await verificador.cerrarSesion();
      } on Exception {
        // Sin registro: podría llevar datos.
      }
    }
    if (widget.recuperar) {
      await repo.recuperar(
        firebaseIdToken: _prueba!,
        celularAnterior: '+52${_diez(_anterior)}',
        tipo: _tipo,
      );
      _paso = _Paso.enviado;
      return;
    }
    await repo.confirmar(_prueba!);
    maq.user.phone = _diez(_nuevo);
    maq.refresh();
    maq.toast(textos.cuentaNumeroCambiado);
    if (mounted) Navigator.pop(context);
  });

  Widget _campo(String etiqueta, TextEditingController c, {int largo = 12}) =>
      FieldK(
        label: etiqueta,
        c: c,
        keyboard: TextInputType.number,
        maxLen: largo,
        onChanged: (_) => setState(() {}),
      );

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final recuperar = widget.recuperar;
    return stack([
      sheetH(
        context,
        recuperar ? textos.cuentaRecuperarTitulo : textos.cuentaNumeroTitulo,
        big: true,
      ),
      if (_paso == _Paso.numero) ...[
        mutT(
          recuperar
              ? textos.cuentaRecuperarExplicacion
              : textos.cuentaNumeroExplicacion,
        ),
        if (recuperar) ...[
          _campo(textos.cuentaNumeroAnterior, _anterior),
          chipsWrap([
            for (final (tipo, nombre) in [
              (TipoDeCuenta.cliente, textos.cuentaTipoCliente),
              (TipoDeCuenta.tecnico, textos.cuentaTipoTecnico),
            ])
              ChipK(
                nombre,
                on: _tipo == tipo,
                onTap: () => setState(() => _tipo = tipo),
              ),
          ]),
        ],
        _campo(textos.cuentaNumeroNuevo, _nuevo),
      ],
      if (_paso == _Paso.codigo)
        _campo(textos.cuentaNumeroCodigo, _codigo, largo: 6),
      if (_paso == _Paso.enviado)
        NoteK('green', 'check', textos.cuentaRecuperarRecibida),
      if (_error case final error?) NoteK('red', 'help', error),
      BtnK(
        switch (_paso) {
          _Paso.numero => textos.cuentaNumeroEnviarCodigo,
          _Paso.codigo => textos.cuentaNumeroConfirmar,
          _Paso.enviado => textos.cuentaNumeroEntendido,
        },
        _listo && !_ocupado
            ? switch (_paso) {
                _Paso.numero => _pedirCodigo,
                _Paso.codigo => _confirmar,
                _Paso.enviado => () => Navigator.pop(context),
              }
            : null,
        busy: _ocupado,
      ),
      if (_paso == _Paso.codigo)
        BtnK(
          textos.cuentaNumeroOtro,
          () => setState(() {
            _paso = _Paso.numero;
            _prueba = null;
            _error = null;
          }),
          kind: Bk.ghost,
        ),
    ]);
  }
}
