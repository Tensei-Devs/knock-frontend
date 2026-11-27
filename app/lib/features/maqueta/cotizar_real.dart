import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/features/maqueta/bandeja_trabajo_real.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/features/trabajo/trabajo.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// El detalle de una solicitud para el técnico y el envío de su cotización
/// (spec 046). Todo vive en memoria: nada se guarda ni se registra.
class CotizarReal extends ConsumerWidget {
  const CotizarReal({super.key, required this.solicitudId});

  final String solicitudId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final proveedor = solicitudParaCotizarProvider(solicitudId);
    return ref
        .watch(proveedor)
        .when(
          skipLoadingOnRefresh: false,
          loading: () => sMut(t.cotizarCargando),
          error: (e, _) => stack([
            NoteK('red', 'help', mensajeDeError(t, e)),
            if (e is! NoEncontradoFailure && e is! SinPerfilTecnicoFailure)
              BtnK(
                t.bloqueosReintentar,
                () => ref.invalidate(proveedor),
                kind: Bk.sec,
              ),
          ], gap: 8),
          data: (s) => stack([_Detalle(s), _Envio(s)], gap: 16),
        );
  }
}

class _Detalle extends StatelessWidget {
  const _Detalle(this.solicitud);

  final SolicitudParaCotizar solicitud;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return CardK(
      child: stack([
        h2('${solicitud.oficio} · ${solicitud.colonia}'),
        T(solicitud.descripcion),
        sMut(t.cotizarCuando(solicitud.dia, t.cotizarFranja(solicitud.franja))),
        if (solicitud.fotos.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final (i, foto) in solicitud.fotos.indexed)
                Image.network(
                  foto.url,
                  width: 96,
                  height: 96,
                  fit: BoxFit.cover,
                  semanticLabel: t.cotizarFotoDe(i + 1),
                  errorBuilder: (_, _, _) => Semantics(
                    label: t.cotizarFotoDe(i + 1),
                    child: const SizedBox.square(
                      dimension: 96,
                      child: Icon(Icons.image_not_supported_outlined),
                    ),
                  ),
                ),
            ],
          ),
      ], gap: 8),
    );
  }
}

/// El formulario, o lo que lo reemplaza cuando ya no se puede enviar.
class _Envio extends ConsumerStatefulWidget {
  const _Envio(this.solicitud);

  final SolicitudParaCotizar solicitud;

  @override
  ConsumerState<_Envio> createState() => _EnvioState();
}

class _EnvioState extends ConsumerState<_Envio> {
  final _precio = TextEditingController();
  final _minimo = TextEditingController();
  final _maximo = TextEditingController();
  final _hora = TextEditingController();
  TipoPrecio _tipo = TipoPrecio.fijo;
  String? _dia;
  Set<CampoCotizacion> _errores = const {};
  bool _enviando = false;
  Failure? _falla;
  CotizacionPropia? _enviada;

  @override
  void dispose() {
    for (final c in [_precio, _minimo, _maximo, _hora]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _enviar() async {
    if (_enviando) return;
    final revision = revisarCotizacion(
      tipo: _tipo,
      precio: _precio.text,
      precioMin: _minimo.text,
      precioMax: _maximo.text,
      dia: _dia,
      hora: _hora.text,
    );
    final nueva = revision.cotizacion;
    setState(() {
      _errores = revision.errores;
      _falla = null;
      _enviando = nueva != null;
    });
    if (nueva == null) return;
    // El contenedor sigue vivo aunque la persona salga antes de la respuesta.
    final contenedor = ProviderScope.containerOf(context, listen: false);
    try {
      final enviada = await ref
          .read(cotizarRepositoryProvider)
          .enviar(widget.solicitud.id, nueva);
      _refrescarListas(contenedor);
      if (mounted) setState(() => _enviada = enviada);
    } on Failure catch (falla) {
      // El servidor dice que las listas que se ven ya no son ciertas.
      if (falla is CotizacionNoPermitidaFailure ||
          falla is NoEncontradoFailure) {
        _refrescarListas(contenedor);
      }
      if (mounted) setState(() => _falla = falla);
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  void _refrescarListas(ProviderContainer contenedor) => contenedor
    ..invalidate(solicitudesRecibidasProvider)
    ..invalidate(cotizacionesEnviadasProvider);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final propias = ref.watch(cotizacionesEnviadasProvider).value?.items;
    final enviada = _enviada;
    if (enviada != null) {
      return stack([
        NoteK('green', 'check', t.cotizarEnviada),
        TarjetaDeCotizacionPropia(enviada),
        sMut(
          enviada.requiereAprobacion ?? false
              ? t.cotizarRequiereAprobacion
              : t.cotizarSinAprobacion,
        ),
      ], gap: 8);
    }
    final propia = propias
        ?.where((c) => c.solicitudId == widget.solicitud.id)
        .firstOrNull;
    if (propia != null) {
      return stack([
        NoteK('amber', 'help', t.cotizarYaCotizada),
        TarjetaDeCotizacionPropia(propia),
      ], gap: 8);
    }
    final falla = _falla;
    if (falla is CotizacionNoPermitidaFailure ||
        falla is NoEncontradoFailure ||
        falla is SinPerfilTecnicoFailure) {
      return NoteK('red', 'help', mensajeDeError(t, falla!));
    }
    final rango = _tipo == TipoPrecio.rango;
    final visita = _tipo == TipoPrecio.visita;
    final dias = diasParaCotizar(
      widget.solicitud.dia,
      ref.watch(relojCotizarProvider)(),
    );
    return stack([
      labT(t.cotizarTipoLabel),
      _opciones([
        for (final tipo in TipoPrecio.values)
          (t.cotizarTipo(tipo.name), _tipo == tipo, () => _tipo = tipo),
      ]),
      if (!rango)
        _monto(
          visita ? t.cotizarPrecioVisita : t.cotizarPrecio,
          _precio,
          CampoCotizacion.precio,
          visita
              ? t.cotizarErrorMontoVisita(visitaMinima, visitaMaxima)
              : t.cotizarErrorMonto,
          ayuda: visita
              ? t.cotizarPrecioVisitaRango(visitaMinima, visitaMaxima)
              : null,
        ),
      if (rango) ...[
        _monto(
          t.cotizarPrecioMin,
          _minimo,
          CampoCotizacion.precioMin,
          t.cotizarErrorMonto,
        ),
        _monto(
          t.cotizarPrecioMax,
          _maximo,
          CampoCotizacion.precioMax,
          t.cotizarErrorMaximo,
        ),
      ],
      labT(t.cotizarDia),
      if (dias.isEmpty) sMut(t.cotizarSinDias),
      _opciones([for (final dia in dias) (dia, _dia == dia, () => _dia = dia)]),
      if (_errores.contains(CampoCotizacion.dia)) sMut(t.cotizarErrorDia),
      FieldK(
        label: t.cotizarHora,
        c: _hora,
        keyboard: TextInputType.datetime,
        maxLen: 5,
        err: _errores.contains(CampoCotizacion.hora)
            ? t.cotizarErrorHora
            : null,
      ),
      if (falla != null) NoteK('red', 'help', mensajeDeError(t, falla)),
      BtnK(t.cotizarEnviar, _enviar, busy: _enviando),
    ], gap: 10);
  }

  Widget _opciones(List<(String, bool, VoidCallback)> opciones) => Wrap(
    spacing: 8,
    children: [
      for (final (texto, elegida, elegir) in opciones)
        ChoiceChip(
          label: Text(texto),
          selected: elegida,
          materialTapTargetSize: MaterialTapTargetSize.padded,
          onSelected: (_) => setState(elegir),
        ),
    ],
  );

  Widget _monto(
    String etiqueta,
    TextEditingController c,
    CampoCotizacion campo,
    String error, {
    String? ayuda,
  }) => FieldK(
    key: ValueKey(campo),
    label: etiqueta,
    help: ayuda,
    c: c,
    keyboard: TextInputType.number,
    maxLen: 6,
    err: _errores.contains(campo) ? error : null,
  );
}
