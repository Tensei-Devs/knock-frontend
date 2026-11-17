import 'dart:async';
import 'dart:math' as math;

import 'package:app/core/enlaces/abridor_de_enlaces.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

/// Zonas donde Knock está disponible (las de la maqueta: CP 42800, 42833,
/// 42809 y 42846) y detección «fuera de cobertura» con la ubicación real.

class ZonaKnock {
  const ZonaKnock(this.colonia, this.cp, this.lat, this.lng);
  final String colonia, cp;
  final double lat, lng;
}

const zonasKnock = <ZonaKnock>[
  ZonaKnock('Col. Centro', '42800', 20.0527, -99.3427),
  ZonaKnock('Col. La Malinche', '42809', 20.0430, -99.3350),
  ZonaKnock('Col. Empleados Tolteca', '42833', 20.0640, -99.3600),
  ZonaKnock('Col. Cruz Azul', '42846', 20.0480, -99.3200),
];

/// Radio de cobertura alrededor de cada colonia (Tula de Allende y
/// alrededores).
const radioCoberturaKm = 10.0;

/// Ubicaciones de prueba (Mi cuenta > Zona de pruebas).
const actopanHidalgo = LatLng(20.2742, -98.9450);

double distanciaKm(double lat1, double lng1, double lat2, double lng2) {
  const r = 6371.0, d2r = math.pi / 180;
  final dLa = (lat2 - lat1) * d2r, dLo = (lng2 - lng1) * d2r;
  final x =
      math.sin(dLa / 2) * math.sin(dLa / 2) +
      math.cos(lat1 * d2r) *
          math.cos(lat2 * d2r) *
          math.sin(dLo / 2) *
          math.sin(dLo / 2);
  return 2 * r * math.asin(math.sqrt(x));
}

class ResultadoCobertura {
  const ResultadoCobertura(this.zona, this.km);
  final ZonaKnock zona;
  final double km;
  bool get dentro => km <= radioCoberturaKm;
}

/// La zona más cercana y si la ubicación cae dentro de la cobertura.
ResultadoCobertura evaluarCobertura(double lat, double lng) {
  ZonaKnock? mejor;
  var d = double.infinity;
  for (final z in zonasKnock) {
    final x = distanciaKm(lat, lng, z.lat, z.lng);
    if (x < d) {
      d = x;
      mejor = z;
    }
  }
  return ResultadoCobertura(mejor!, d);
}

const _redes = <(String, IconData, String)>[
  (
    'Instagram',
    Icons.camera_alt_outlined,
    'https://www.instagram.com/knock.mx/',
  ),
  ('TikTok', Icons.music_note, 'https://www.tiktok.com/@knockmx'),
  ('X', Icons.close, 'https://x.com/knock_mx'),
  ('Facebook', Icons.facebook, 'https://www.facebook.com/share/1C3PA8XoUb/'),
];

/// Contenido de la hoja «¡Pronto estaremos cerca de ti!» (misma estética que
/// las hojas de la maqueta). [alExplorar] se llama solo si la persona lo pide.
class PantallaFueraDeCobertura extends ConsumerWidget {
  const PantallaFueraDeCobertura({
    super.key,
    required this.alCerrar,
    required this.alExplorar,
    this.enHoja = true,
    this.alAvisar,
    this.avisando = false,
    this.avisado = false,
  });
  final VoidCallback alCerrar, alExplorar;

  /// Registra la zona en la lista de espera (spec 017, R-08). Si es `null`, no
  /// se ofrece el botón (por ejemplo, cuando la zona salió de la ubicación y no
  /// hay código postal escrito: nunca se envían coordenadas).
  final VoidCallback? alAvisar;

  /// Hay un registro en curso (el botón se deshabilita, R-15) o ya se hizo.
  final bool avisando, avisado;

  /// `false` cuando va dentro de otra hoja (entrada): sin botón de cerrar.
  final bool enHoja;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final k = kc(context);
    return stack([
      if (enHoja)
        sheetH(context, '¡Pronto estaremos cerca de ti!', big: true)
      else
        h1('¡Pronto estaremos cerca de ti!'),
      Center(
        child: Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(color: k.navySoft, shape: BoxShape.circle),
          child: Icon(Icons.place_outlined, size: 46, color: k.navy),
        ),
      ),
      T(
        'Por el momento, Knock todavía no está disponible en tu zona, pero estamos trabajando para llegar pronto. Si quieres estar al tanto de nuestra llegada y conocer las novedades, síguenos en nuestras redes sociales.',
        color: k.ink2,
      ),
      Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          for (final r in _redes)
            Semantics(
              label: r.$1,
              button: true,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () => unawaited(
                  ref.read(abridorDeEnlacesProvider).abrir(Uri.parse(r.$3)),
                ),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 48),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: k.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: k.navy, width: 2),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 6,
                    children: [
                      Icon(r.$2, size: 20, color: k.navy),
                      Text(
                        r.$1,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: k.navy,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      if (alAvisar != null || avisado)
        BtnK(
          avisado
              ? 'Ya estás en la lista de espera'
              : avisando
              ? 'Guardando…'
              : 'Avisarme cuando lleguen',
          avisado || avisando ? null : alAvisar,
        ),
      BtnK('Explorar de todos modos', alExplorar, kind: Bk.sec),
      BtnK('Entendido', alCerrar, kind: Bk.ghost),
    ]);
  }
}

/// Selector explícito de una zona disponible (solo desde «Explorar de todos
/// modos»). Devuelve la zona elegida o `null`.
Future<ZonaKnock?> elegirZonaDisponible(BuildContext context) =>
    hoja<ZonaKnock>(
      context,
      (ctx, _) => stack([
        sheetH(ctx, 'Zonas disponibles'),
        sMut(
          'Knock está disponible en estas colonias de Tula de Allende. Elige una para explorar expertos de ejemplo.',
        ),
        stack([
          for (final z in zonasKnock)
            ChoiceK(
              on: false,
              title: z.colonia,
              sub: 'Tula de Allende, Hgo. · CP ${z.cp}',
              minH: 64,
              onTap: () => Navigator.pop(ctx, z),
            ),
        ], gap: 8),
      ]),
    );

bool _hojaAbierta = false;

/// Muestra la hoja de fuera de cobertura. Si la persona elige explorar, pide
/// una zona disponible y la devuelve (para mover el mapa).
Future<ZonaKnock?> mostrarFueraDeCobertura(BuildContext context) async {
  if (_hojaAbierta) return null;
  _hojaAbierta = true;
  var explorar = false;
  await hoja<void>(
    context,
    (ctx, _) => PantallaFueraDeCobertura(
      alCerrar: () => Navigator.pop(ctx),
      alExplorar: () {
        explorar = true;
        Navigator.pop(ctx);
      },
    ),
  );
  _hojaAbierta = false;
  if (!explorar || !context.mounted) return null;
  final z = await elegirZonaDisponible(context);
  if (z != null) {
    maq.user.col = z.colonia;
    maq.user.cp = z.cp;
    maq.refresh();
  }
  return z;
}
