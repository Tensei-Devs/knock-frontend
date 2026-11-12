import 'package:app/core/router/rutas.dart';
import 'package:app/core/widgets/estado_knock.dart';
import 'package:app/core/widgets/pantalla_titulada.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Pestaña Actividad: por ahora solo el estado vacío de la maqueta (P11); su
/// historia agrega la lista de solicitudes. Sin el botón «Pedir una
/// cotización», que aún no tiene a dónde ir (spec 014, decisión 5).
class ActividadScreen extends StatelessWidget {
  const ActividadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    return PantallaTitulada(
      titulo: textos.tabActividad,
      cuerpo: EstadoKnock(
        icono: Icons.receipt_long_outlined,
        titulo: textos.actividadVaciaTitulo,
        detalle: textos.actividadVaciaDetalle,
        accion: FilledButton(
          onPressed: () => context.push(Rutas.solicitudNueva),
          child: Text(textos.actividadPedirCotizacion),
        ),
      ),
    );
  }
}
