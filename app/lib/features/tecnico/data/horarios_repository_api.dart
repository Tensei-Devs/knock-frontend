import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/contrato_json.dart';
import 'package:app/core/red/enviar_json.dart';
import 'package:app/features/tecnico/domain/horarios.dart';
import 'package:http/http.dart' as http;

/// REAL: `/api/v1/tecnicos/me/horarios` (TEC-10 y TEC-11) y
/// `/api/v1/tecnicos/me/disponibilidad` (TEC-09), backend 046. Va por el
/// transporte con sesión (spec 026) y no registra nada.
class HorariosRepositoryApi implements HorariosRepository {
  const HorariosRepositoryApi({required this.transporte, required this.url});

  final http.Client transporte;
  final String url;

  static const _horarios = 'tecnicos/me/horarios';

  @override
  Future<List<HorarioDelDia>> horarios() async =>
      _semana(await enviarJsonONoEncontrado(transporte, url, 'GET', _horarios));

  @override
  Future<List<HorarioDelDia>> guardar(List<HorarioDelDia> semana) async =>
      _semana(
        await enviarJsonONoEncontrado(
          transporte,
          url,
          'PUT',
          _horarios,
          cuerpo: {
            'horarios': [for (final d in semana) _cuerpo(d)],
          },
        ),
      );

  @override
  Future<Disponibilidad> cambiarDisponibilidad({
    required bool disponibleHoy,
  }) async {
    final r = await enviarJson(
      transporte,
      url,
      'PUT',
      'tecnicos/me/disponibilidad',
      cuerpo: {'disponibleHoy': disponibleHoy},
    );
    final m = objetoDelContrato(r.json);
    return Disponibilidad(
      disponibleHoy: booleanoObligatorio(m['disponibleHoy']),
      hasta: fechaHoraObligatoria(m['disponibleHasta']),
    );
  }

  /// Un día cerrado va sin franjas: el servidor las rechaza.
  static Map<String, Object?> _cuerpo(HorarioDelDia d) => {
    'dia': d.dia.valor,
    'abierto': d.abierto,
    'franjas': [
      if (d.abierto)
        for (final f in d.franjas) {'inicio': f.inicio, 'fin': f.fin},
    ],
  };

  static List<HorarioDelDia> _semana(RespuestaJson r) => [
    for (final valor in listaDelContrato(objetoDelContrato(r.json)['horarios']))
      _dia(objetoDelContrato(valor)),
  ];

  static HorarioDelDia _dia(Map<Object?, Object?> m) => HorarioDelDia(
    dia: DiaSemana.values.firstWhere(
      (d) => d.valor == m['dia'],
      orElse: () => throw const DatosInvalidosFailure(),
    ),
    abierto: booleanoObligatorio(m['abierto']),
    franjas: [
      for (final f in listaDelContrato(m['franjas']).map(objetoDelContrato))
        (
          inicio: textoObligatorio(f['inicio']),
          fin: textoObligatorio(f['fin']),
        ),
    ],
  );
}
