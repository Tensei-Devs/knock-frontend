import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/features/trabajo/data/cotizar_repository_api.dart';
import 'package:app/features/trabajo/domain/cotizar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Cotizar (specs 046 y 038). La maqueta lo usa solo con sesión y API.
final cotizarRepositoryProvider = Provider<CotizarRepository>(
  (ref) => CotizarRepositoryApi(
    transporte: ref.watch(transporteApiProvider),
    url: ref.watch(urlApiProvider),
  ),
);

/// La hora actual, para saber qué días ya pasaron; las pruebas la fijan.
final relojCotizarProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);

/// La referencia de mercado del formulario de cotizar (spec 038, D-03). Sin
/// reintento automático y sin copia: se descarta al salir.
final referenciaDeMercadoProvider = FutureProvider.autoDispose
    .family<ReferenciaDeMercado, ({String oficio, TipoPrecio tipo})>(
      (ref, consulta) => ref
          .watch(cotizarRepositoryProvider)
          .referenciaDeMercado(oficio: consulta.oficio, tipo: consulta.tipo),
      retry: (_, _) => null,
    );
