import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Una lista de la API por páginas con sus estados: carga, error con
/// reintento, vacío y «Ver más» (spec 033, CA-19 a CA-24). Cada lista dice sus
/// textos, de dónde salen los datos y cómo se pinta cada fila.
abstract class ListaPaginadaReal<P> extends ConsumerWidget {
  const ListaPaginadaReal({super.key});

  TextosDeLista textosDeLista(AppLocalizations t);
  AsyncValue<P> observar(WidgetRef ref);
  List<Widget> filas(P pagina);
  bool hayMas(P pagina);
  void reintentar(WidgetRef ref);
  Future<Failure?> cargarMas(WidgetRef ref);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = AppLocalizations.of(context);
    final propios = textosDeLista(textos);
    return stack([
      h2(propios.titulo),
      observar(ref).when(
        skipLoadingOnRefresh: false,
        loading: () => sMut(propios.cargando),
        error: (e, _) => stack([
          NoteK(
            'red',
            'help',
            e is ServicioNoDisponibleFailure
                ? textos.errorSinConexion
                : propios.error,
          ),
          BtnK(textos.bloqueosReintentar, () => reintentar(ref), kind: Bk.sec),
        ], gap: 8),
        data: (pagina) {
          final lista = filas(pagina);
          return stack([
            if (lista.isEmpty) sMut(propios.vacio),
            ...lista,
            if (hayMas(pagina))
              BtnK(textos.bloqueosVerMas, () async {
                final falla = await cargarMas(ref);
                if (falla != null && context.mounted) {
                  maq.toast(mensajeDeError(textos, falla));
                }
              }, kind: Bk.ghost),
          ], gap: 10);
        },
      ),
    ], gap: 10);
  }
}

/// Los textos propios de una [ListaPaginadaReal].
typedef TextosDeLista = ({
  String titulo,
  String cargando,
  String error,
  String vacio,
});
