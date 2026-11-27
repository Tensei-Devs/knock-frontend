import 'package:app/core/red/contrato_json.dart';
import 'package:app/features/tecnico/domain/disponible_hoy.dart';
import 'package:http/http.dart' as http;

/// REAL: `GET /api/v1/tecnicos/me/trabajo` (backend 046), del que solo se lee
/// `disponibleHoy`. Escrito a mano por ADR-007; no se guarda nada.
class DisponibleHoyRepositoryApi implements DisponibleHoyRepository {
  const DisponibleHoyRepositoryApi({
    required this.transporte,
    required this.url,
  });

  final http.Client transporte;
  final String url;

  @override
  Future<bool> consultar() async {
    final r = await enviarJsonONoEncontrado(
      transporte,
      url,
      'GET',
      'tecnicos/me/trabajo',
    );
    return booleanoObligatorio(objetoDelContrato(r.json)['disponibleHoy']);
  }
}
