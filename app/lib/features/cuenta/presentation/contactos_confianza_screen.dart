import 'package:app/core/widgets/estado_knock.dart';
import 'package:app/features/actividad/actividad.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Contactos de confianza desde Mi cuenta, sin necesitar una visita
/// (spec 022, D-01 y CA-14): agregar, editar y borrar. Viven solo en el
/// teléfono.
class ContactosConfianzaScreen extends ConsumerWidget {
  const ContactosConfianzaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = AppLocalizations.of(context);
    final contactos = ref.watch(contactosProvider);
    return Scaffold(
      appBar: AppBar(title: Text(textos.cuentaContactosConfianza)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => mostrarFormularioContacto(context),
        icon: const Icon(Icons.person_add_alt_outlined),
        label: Text(textos.avisoAgregarContacto),
      ),
      body: switch (contactos) {
        AsyncData(:final value) when value.isEmpty => EstadoKnock(
          icono: Icons.people_outline,
          titulo: textos.avisoSinContactos,
          detalle: textos.avisoPrivacidad,
        ),
        AsyncData(:final value) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            Text(textos.avisoPrivacidad),
            const SizedBox(height: 8),
            for (final contacto in value)
              Card(
                child: ListTile(
                  title: Text(contacto.nombre),
                  subtitle: Text(contacto.celular),
                  trailing: Wrap(
                    children: [
                      IconButton(
                        tooltip: textos.avisoEditarA(contacto.nombre),
                        onPressed: () => mostrarFormularioContacto(
                          context,
                          contacto: contacto,
                        ),
                        icon: const Icon(Icons.edit_outlined),
                      ),
                      IconButton(
                        tooltip: textos.avisoBorrarContacto(contacto.nombre),
                        onPressed: () => ref
                            .read(contactosProvider.notifier)
                            .borrar(contacto.id),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
