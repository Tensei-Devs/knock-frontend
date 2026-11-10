import 'package:app/core/router/rutas.dart';
import 'package:app/core/tema/tokens.dart';
import 'package:app/features/oficios/oficios.dart';
import 'package:app/features/oficios/presentation/oficios_controller.dart';
import 'package:app/features/previa/demo/datos_de_ejemplo.dart';
import 'package:app/features/previa/domain/requerir_cuenta.dart';
import 'package:app/features/previa/presentation/barra_marca.dart';
import 'package:app/features/previa/presentation/buscador_previa.dart';
import 'package:app/features/previa/presentation/catalogo_previa.dart';
import 'package:app/features/previa/presentation/chips_oficio.dart';
import 'package:app/features/previa/presentation/hoja_invitacion.dart';
import 'package:app/features/previa/presentation/mapa/controlador_mapa.dart';
import 'package:app/features/previa/presentation/mapa/mapa_previa.dart';
import 'package:app/features/previa/presentation/panel_expertos.dart';
import 'package:app/features/previa/presentation/rotulo_ejemplo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Previa sin sesión (`/previa`, spec 027, decisión D-12): la pantalla de
/// inicio de la maqueta antes de entrar. Barra de marca con «Entrar» y
/// «Registrarme» arriba; debajo, un mapa a pantalla completa (dibujado por la
/// app, con pan y zoom) con el buscador y los chips de oficio flotando encima,
/// los botones del mapa y un panel inferior plegable de «expertos cerca de
/// ti» con la tarjeta «Explorar servicios y trabajos» y el catálogo real de
/// oficios.
///
/// Los expertos, los pines y la colonia son de ejemplo y llevan siempre el
/// rótulo «Datos de ejemplo». No pide ubicación ni permisos y no hace ninguna
/// petición protegida (CA-14, CA-30).
class PreviaScreen extends ConsumerStatefulWidget {
  const PreviaScreen({super.key});

  @override
  ConsumerState<PreviaScreen> createState() => _PreviaScreenState();
}

class _PreviaScreenState extends ConsumerState<PreviaScreen> {
  final _mapa = ControladorMapa();
  final _extensionPanel = ValueNotifier<double>(TamanosPanel.mitad);

  /// Clave del oficio elegido en los chips; `null` es «Todos».
  String? _clave;

  @override
  void dispose() {
    _mapa.dispose();
    _extensionPanel.dispose();
    super.dispose();
  }

  void _invitar() => mostrarHojaInvitacion(context);

  /// Tocar un experto (pin o tarjeta) pide cuenta; nunca muestra contacto.
  void _pedirCuenta(ExpertoDeEjemplo _) =>
      requerirCuenta(destino: Rutas.explorar, navegar: context.go);

  @override
  Widget build(BuildContext context) {
    final oficios =
        ref.watch(oficiosControllerProvider).asData?.value ?? const <Oficio>[];
    final expertos = [
      for (final e in expertosDeEjemplo)
        if (_clave == null || e.claveOficio == _clave) e,
    ];
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ColoredBox(
              color: Theme.of(context).colorScheme.surface,
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Espaciado.cuerpo,
                  vertical: Espaciado.bloqueChico / 2,
                ),
                child: BarraMarca(),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: MapaPrevia(
                      controlador: _mapa,
                      expertos: expertos,
                      alTocarExperto: _pedirCuenta,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    child: _Superior(
                      oficios: oficios,
                      seleccionado: _clave,
                      alElegir: (clave) => setState(() => _clave = clave),
                      alTocarBuscador: _invitar,
                    ),
                  ),
                  Positioned(
                    right: Espaciado.fila,
                    bottom: 0,
                    top: 0,
                    child: ValueListenableBuilder<double>(
                      valueListenable: _extensionPanel,
                      builder: (context, extension, _) => LayoutBuilder(
                        builder: (context, caja) => Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom:
                                  caja.maxHeight *
                                      extension.clamp(0, TamanosPanel.mitad) +
                                  Espaciado.fila,
                            ),
                            child: ControlesMapa(controlador: _mapa),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: PanelExpertos(
                      expertos: expertos,
                      alTocarExperto: _pedirCuenta,
                      alCambiarExtension: (e) => _extensionPanel.value = e,
                      catalogo: CatalogoPrevia(clave: _clave),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Capa flotante de arriba: buscador, chips y el rótulo «Datos de ejemplo»
/// del mapa (`.mtop` de la maqueta).
class _Superior extends StatelessWidget {
  const _Superior({
    required this.oficios,
    required this.seleccionado,
    required this.alElegir,
    required this.alTocarBuscador,
  });

  final List<Oficio> oficios;
  final String? seleccionado;
  final ValueChanged<String?> alElegir;
  final VoidCallback alTocarBuscador;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Espaciado.fila,
        Espaciado.fila,
        Espaciado.fila,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Espaciado.bloqueChico,
        children: [
          BuscadorPrevia(alTocar: alTocarBuscador),
          ChipsOficio(
            oficios: oficios,
            seleccionado: seleccionado,
            alElegir: alElegir,
            alNoSeCual: alTocarBuscador,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: FittedBox(fit: BoxFit.scaleDown, child: RotuloDeEjemplo()),
          ),
        ],
      ),
    );
  }
}
