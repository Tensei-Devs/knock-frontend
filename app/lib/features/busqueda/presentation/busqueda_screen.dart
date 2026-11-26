import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/core/router/rutas.dart';
import 'package:app/features/actividad/actividad.dart'
    show coloniaGuardadaProvider;
import 'package:app/features/busqueda/busqueda.dart';
import 'package:app/features/busqueda/presentation/tarjeta_experto.dart';
import 'package:app/features/oficios/oficios.dart' show Oficio;
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Pantalla de búsqueda de expertos por texto (spec 021, §7, `/inicio/buscar`).
///
/// El texto no se guarda en disco ni en caché (R-05). La colonia viene de
/// [coloniaGuardadaProvider]; si no hay, se pide elegirla (CA-15, R-06).
class BusquedaScreen extends ConsumerStatefulWidget {
  const BusquedaScreen({super.key});

  @override
  ConsumerState<BusquedaScreen> createState() => _BusquedaScreenState();
}

class _BusquedaScreenState extends ConsumerState<BusquedaScreen> {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // El campo recibe el foco al abrir (spec 021, §7).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Abre «Pedir cotización» con el oficio ya elegido (CA-09, R-08).
  void _pedirCotizacion(BuildContext context, String? oficioClave) {
    final uri = Uri(
      path: Rutas.solicitudNueva,
      queryParameters: {Rutas.parametroOficio: ?oficioClave},
    );
    context.go(uri.toString());
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final consulta = ref.watch(consultaBusquedaProvider);
    final control = ref.read(consultaBusquedaProvider.notifier);
    final coloniaId = ref.watch(coloniaGuardadaProvider);
    final oficios =
        ref.watch(oficiosBusquedaProvider).value ?? const <Oficio>[];
    final largo = _textController.text.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.busquedaTitulo),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Semantics(
              label: l.busquedaEtiqueta,
              child: TextField(
                controller: _textController,
                focusNode: _focusNode,
                maxLength: largoMaximoBusqueda,
                textInputAction: TextInputAction.search,
                onChanged: (v) {
                  control.escribir(v);
                  setState(() {});
                },
                onSubmitted: control.buscarYa,
                decoration: InputDecoration(
                  hintText: l.busquedaPlaceholder,
                  prefixIcon: const Icon(Icons.search),
                  counterText: l.busquedaContador(largo),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Chips de filtros: «Solo verificados» y «Oficio» (CA-08).
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  FilterChip(
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    label: Text(
                      consulta.soloVerificados
                          ? l.busquedaSoloVerificadosActivo
                          : l.busquedaSoloVerificados,
                    ),
                    selected: consulta.soloVerificados,
                    onSelected: (v) => control.soloVerificados(activo: v),
                  ),
                  for (final oficio in oficios) ...[
                    const SizedBox(width: 8),
                    FilterChip(
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      label: Text(oficio.nombre),
                      selected: consulta.oficio == oficio.clave,
                      onSelected: (seleccionado) => control.filtrarOficio(
                        seleccionado ? oficio.clave : null,
                      ),
                    ),
                  ],
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(child: _buildBody(context, l, consulta, coloniaId, oficios)),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppLocalizations l,
    ConsultaBusqueda consulta,
    String? coloniaId,
    List<Oficio> oficios,
  ) {
    final largo = _textController.text.trim().length;

    // CA-05: menos de 2 caracteres.
    if (largo < largoMinimoBusqueda && consulta.texto == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(l.busquedaMinimo, textAlign: TextAlign.center),
        ),
      );
    }

    // CA-15: sin zona guardada.
    if (coloniaId == null) {
      return _SinZona(l: l);
    }

    return _ResultadosView(
      coloniaId: coloniaId,
      l: l,
      oficios: oficios,
      alPedir: (clave) => _pedirCotizacion(context, clave),
    );
  }
}

/// Vista de «elige tu zona» cuando no hay colonia guardada (CA-15).
class _SinZona extends StatelessWidget {
  const _SinZona({required this.l});

  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_on_outlined, size: 48),
            const SizedBox(height: 16),
            Text(l.busquedaSinZona, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

/// Vista con los resultados del [BusquedaController] (CA-01 a CA-18).
class _ResultadosView extends ConsumerWidget {
  const _ResultadosView({
    required this.coloniaId,
    required this.l,
    required this.oficios,
    required this.alPedir,
  });

  final String coloniaId;
  final AppLocalizations l;
  final List<Oficio> oficios;
  final void Function(String? clave) alPedir;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controlNotifier = ref.read(
      busquedaControllerProvider(coloniaId).notifier,
    );
    return ref
        .watch(busquedaControllerProvider(coloniaId))
        .when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _ErrorView(
            mensaje: _mensajeDeError(l, error),
            reintentar: controlNotifier.reintentar,
          ),
          data: (pagina) {
            if (pagina == null) {
              return Center(
                child: Text(l.busquedaMinimo, textAlign: TextAlign.center),
              );
            }
            return _PaginaView(
              pagina: pagina,
              coloniaId: coloniaId,
              l: l,
              oficios: oficios,
              alPedir: alPedir,
            );
          },
        );
  }

  String _mensajeDeError(AppLocalizations l, Object error) => switch (error) {
    BusquedaNoDisponible() => l.busquedaNoDisponible,
    ServicioNoDisponibleFailure() => l.busquedaSinConexion,
    DatosRechazadosFailure() => l.busquedaOtrasPalabras,
    DemasiadosIntentosFailure(:final espera?) => l.busquedaEspera(
      espera.inSeconds,
    ),
    OpcionNoDisponibleFailure() => l.busquedaSinZona,
    // El resto del catálogo también sale del ARB (R-10), no en español fijo.
    final Failure f => mensajeDeError(l, f),
    _ => l.busquedaNoDisponible,
  };
}

/// Un estado de error con «Reintentar» (CA-12, CA-13, R-09).
class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.mensaje, required this.reintentar});

  final String mensaje;
  final VoidCallback reintentar;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(mensaje, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: reintentar,
              child: Text(l.busquedaReintentar),
            ),
          ],
        ),
      ),
    );
  }
}

/// La página de resultados: interpretación, lista y paginación (CA-01 a CA-04,
/// CA-07 a CA-11, CA-18).
class _PaginaView extends ConsumerWidget {
  const _PaginaView({
    required this.pagina,
    required this.coloniaId,
    required this.l,
    required this.oficios,
    required this.alPedir,
  });

  final PaginaBusqueda pagina;
  final String coloniaId;
  final AppLocalizations l;
  final List<Oficio> oficios;
  final void Function(String? clave) alPedir;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final interpretacion = pagina.interpretacion;
    final detectado = interpretacion.oficioDetectado;
    final control = ref.read(busquedaControllerProvider(coloniaId).notifier);
    final filtrar = ref.read(consultaBusquedaProvider.notifier).filtrarOficio;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Interpretación del servidor (R-04).
        ..._interpretacionWidgets(context, interpretacion, filtrar),
        if (pagina.items.isEmpty &&
            interpretacion.estado != EstadoInterpretacion.noEntendido) ...[
          const SizedBox(height: 16),
          if (detectado == null)
            Text(l.busquedaSinResultados, textAlign: TextAlign.center)
          else ...[
            Text(
              l.busquedaSinResultadosOficio(detectado.nombre),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => alPedir(detectado.clave),
              child: Text(l.busquedaPedirCotizacion),
            ),
          ],
        ],
        if (pagina.items.isNotEmpty) ...[
          Semantics(
            liveRegion: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                l.busquedaTotal(pagina.items.length),
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          ),
          for (final experto in pagina.items) ...[
            TarjetaExperto(
              experto: experto,
              alTocar: () => alPedir(
                detectado?.clave ?? experto.oficios.firstOrNull?.clave,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ],
        // Paginación (CA-18, R-03).
        if (pagina.siguiente != null)
          _BotonVerMas(coloniaId: coloniaId, control: control, l: l)
        else if (pagina.items.length >= 100)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(l.busquedaTope, textAlign: TextAlign.center),
          ),
      ],
    );
  }

  List<Widget> _interpretacionWidgets(
    BuildContext context,
    InterpretacionBusqueda interp,
    void Function(String?) filtrar,
  ) {
    final detectado = interp.oficioDetectado;
    return switch (interp.estado) {
      EstadoInterpretacion.detectado || EstadoInterpretacion.elegido => [
        if (detectado != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(l.busquedaBuscamos(detectado.nombre)),
          ),
      ],
      EstadoInterpretacion.ambiguo => [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(l.busquedaAmbiguo),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            for (final o in interp.oficiosSugeridos.take(3))
              ActionChip(
                materialTapTargetSize: MaterialTapTargetSize.padded,
                label: Text(o.nombre),
                onPressed: () => filtrar(o.clave),
              ),
          ],
        ),
        const SizedBox(height: 8),
      ],
      EstadoInterpretacion.noEntendido => [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(l.busquedaNoEntendimos),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(l.busquedaElegirCategoria),
        ),
        if (oficios.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final o in oficios)
                ActionChip(
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  label: Text(o.nombre),
                  onPressed: () => filtrar(o.clave),
                ),
            ],
          ),
        const SizedBox(height: 8),
      ],
    };
  }
}

/// «Ver más» con manejo de error (CA-17, CA-18).
class _BotonVerMas extends StatefulWidget {
  const _BotonVerMas({
    required this.coloniaId,
    required this.control,
    required this.l,
  });

  final String coloniaId;
  final BusquedaController control;
  final AppLocalizations l;

  @override
  State<_BotonVerMas> createState() => _BotonVerMasState();
}

class _BotonVerMasState extends State<_BotonVerMas> {
  bool _cargando = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: OutlinedButton(
        onPressed: _cargando ? null : _verMas,
        child: _cargando
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(widget.l.busquedaCargarMas),
      ),
    );
  }

  Future<void> _verMas() async {
    setState(() => _cargando = true);
    try {
      final falla = await widget.control.verMas();
      if (falla != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mensajeDeError(widget.l, falla))),
        );
      }
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }
}
