import 'package:app/core/config/subida_de_fotos.dart';
import 'package:app/core/router/rutas.dart';
import 'package:app/features/actividad/actividad.dart' as act;
import 'package:app/features/maqueta/envio_de_visita.dart';
import 'package:app/features/maqueta/estado.dart' show maq;
import 'package:app/features/maqueta/nav.dart';
import 'package:app/features/maqueta/precio_tecnico_real.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/features/visita/visita.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// «Terminar servicio» de una visita real (VIS-09): de 1 a 5 fotos, qué se hizo
/// y una recomendación opcional. Las fotos se suben con propósito `trabajo` y,
/// mientras la subida esté apagada, no se puede terminar. Si algo falla, lo
/// escrito y las fotos elegidas se conservan.
class TerminarServicioReal extends ConsumerStatefulWidget {
  const TerminarServicioReal({
    super.key,
    required this.visitaId,
    this.elegir = elegirFotos,
  });

  final String visitaId;
  final Future<List<String>> Function({bool varias, int max}) elegir;

  @override
  ConsumerState<TerminarServicioReal> createState() => _TerminarState();
}

class _TerminarState extends ConsumerState<TerminarServicioReal>
    with EnvioDeVisita {
  static const _maximoFotos = 5;
  final _fotos = <String>[];
  final _descripcion = TextEditingController();
  final _recomendacion = TextEditingController();

  /// `archivoId` de cada foto ya subida, para no repetirla al reintentar.
  final _subidas = <String, String>{};

  @override
  void dispose() {
    _descripcion.dispose();
    _recomendacion.dispose();
    super.dispose();
  }

  Future<void> _agregar() async {
    final libres = _maximoFotos - _fotos.length;
    final elegidas = await widget.elegir(max: libres);
    if (mounted) setState(() => _fotos.addAll(elegidas.take(libres)));
  }

  Future<void> _terminar() async {
    final textos = AppLocalizations.of(context);
    final bien = await enviarUnaVez(textos.visitaTerminarNoEnCurso, () async {
      final subir = ref.read(act.subidaDeFotoDeTrabajoProvider);
      final ids = <String>[];
      for (final ruta in List.of(_fotos)) {
        ids.add(_subidas[ruta] ??= await subir(ruta));
      }
      final recomendacion = _recomendacion.text.trim();
      await ref
          .read(accionesVisitaRepositoryProvider)
          .terminar(
            widget.visitaId,
            descripcion: _descripcion.text.trim(),
            recomendacion: recomendacion.isEmpty ? null : recomendacion,
            fotos: ids,
          );
    });
    if (!bien || !mounted) return;
    ref.invalidate(agendaControllerProvider);
    maq.toast(textos.visitaTerminarHecho);
    context.go(Rutas.trabajo);
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final subida = ref.watch(subidaDeFotosActivaProvider);
    final listo =
        subida && _fotos.isNotEmpty && _descripcion.text.trim().length >= 8;
    return stack([
      PrecioTecnicoReal(visitaId: widget.visitaId),
      if (!subida) NoteK('amber', 'clock', textos.visitaTerminarSinSubida),
      labT(textos.visitaTerminarFotos),
      Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          for (final ruta in _fotos)
            PhotoTile(
              path: ruta,
              onRemove: enviando
                  ? null
                  : () => setState(() => _fotos.remove(ruta)),
            ),
          if (subida && _fotos.length < _maximoFotos) AddPhoto(onTap: _agregar),
        ],
      ),
      FieldK(
        label: textos.visitaTerminarDescripcion,
        help: textos.visitaTerminarDescripcionAyuda,
        c: _descripcion,
        lines: 3,
        maxLen: 500,
        onChanged: (_) => setState(() {}),
      ),
      FieldK(
        label: textos.visitaTerminarRecomendacion,
        c: _recomendacion,
        lines: 3,
        maxLen: 300,
      ),
      if (errorDeEnvio case final error?) NoteK('red', 'help', error),
      BtnK(
        enviando ? textos.visitaEnviando : textos.visitaTerminarBoton,
        listo && !enviando ? _terminar : null,
      ),
    ], gap: 14);
  }
}
