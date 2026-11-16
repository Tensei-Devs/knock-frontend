import 'package:app/core/plataforma/compartir.dart';
import 'package:app/core/enlaces/abridor_de_enlaces.dart';
import 'package:app/core/enlaces/enlaces.dart';
import 'package:app/features/actividad/domain/aviso.dart';
import 'package:app/features/actividad/presentation/aviso_controller.dart';
import 'package:app/features/actividad/presentation/widgets/formulario_contacto.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Abre la hoja «Avisar a alguien de confianza» de la visita [visitaId]
/// (spec 022). El texto se pide una sola vez al abrirla (R-07).
Future<void> mostrarHojaAvisar(BuildContext context, String visitaId) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => UncontrolledProviderScope(
        container: ProviderScope.containerOf(context),
        child: HojaAvisar(visitaId: visitaId),
      ),
    );

/// Vista previa del mensaje, contactos del teléfono y canales: SMS, WhatsApp
/// o la hoja de compartir del sistema. La app no envía nada por sí sola
/// (R-03, CA-09 a CA-12).
class HojaAvisar extends ConsumerStatefulWidget {
  const HojaAvisar({required this.visitaId, super.key});

  final String visitaId;

  @override
  ConsumerState<HojaAvisar> createState() => _HojaAvisarState();
}

class _HojaAvisarState extends ConsumerState<HojaAvisar> {
  String? _elegido;

  PlantillaAviso _plantilla(AppLocalizations textos) => PlantillaAviso(
    encabezado: textos.avisoLocalEncabezado,
    tecnicoVerificado: textos.avisoLocalVerificado,
    tecnicoSinVerificar: textos.avisoLocalSinVerificar,
    cuando: textos.avisoLocalCuando,
    recomendacion: textos.avisoLocalRecomendacion,
  );

  Future<void> _abrir(
    Uri? enlace,
    String texto, {
    bool compartirSiFalla = false,
  }) async {
    final mensajero = ScaffoldMessenger.of(context);
    final textos = AppLocalizations.of(context);
    final abierto =
        enlace != null &&
        await ref.read(abridorDeEnlacesProvider).abrir(enlace);
    if (abierto) return;
    if (compartirSiFalla) {
      // CA-10: sin WhatsApp, la hoja de compartir del sistema.
      await ref.read(compartidorDeTextoProvider).compartir(texto);
      return;
    }
    mensajero.showSnackBar(SnackBar(content: Text(textos.avisoSinApp)));
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final tema = Theme.of(context);
    final aviso = ref.watch(textoDeAvisoProvider(widget.visitaId));
    final contactos = ref.watch(contactosProvider).value ?? const [];
    final idioma = Localizations.localeOf(context).toLanguageTag();

    final (String? texto, String? advertencia) = switch (aviso) {
      AsyncData(value: AvisoDelServidor(:final texto)) => (texto, null),
      AsyncData(value: AvisoDeRespaldo(:final datos)) => (
        armarAvisoLocal(
          datos,
          _plantilla(textos),
          diaFormateado: DateFormat('EEEE d MMMM', idioma).format(datos.dia),
        ),
        textos.avisoSinRegistro,
      ),
      AsyncData(value: AvisoNoPermitido()) => (null, textos.avisoNoPermitido),
      AsyncData(value: AvisoSinDatos()) => (null, textos.avisoSinDatos),
      AsyncError() => (null, textos.avisoSinDatos),
      _ => (null, null),
    };

    final elegido = contactos.where((c) => c.id == _elegido).firstOrNull;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(textos.avisoTitulo, style: tema.textTheme.titleLarge),
            const SizedBox(height: 12),
            if (aviso.isLoading) const LinearProgressIndicator(),
            if (advertencia != null)
              Semantics(
                liveRegion: true,
                child: Text(
                  advertencia,
                  style: TextStyle(color: tema.colorScheme.error),
                ),
              ),
            if (texto != null) ...[
              const SizedBox(height: 12),
              Text(textos.avisoVistaPrevia, style: tema.textTheme.titleSmall),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: tema.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SelectableText(texto),
              ),
              const SizedBox(height: 16),
              Text(textos.avisoElige, style: tema.textTheme.titleSmall),
              if (contactos.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(textos.avisoSinContactos),
                ),
              RadioGroup<String>(
                groupValue: _elegido,
                onChanged: (id) => setState(() => _elegido = id),
                child: Column(
                  children: [
                    for (final contacto in contactos)
                      RadioListTile<String>(
                        value: contacto.id,
                        title: Text(contacto.nombre),
                        subtitle: Text(contacto.celular),
                      ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: () => mostrarFormularioContacto(context),
                icon: const Icon(Icons.person_add_alt_outlined),
                label: Text(textos.avisoAgregarContacto),
              ),
              Text(textos.avisoPrivacidad, style: tema.textTheme.bodySmall),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    onPressed: elegido == null
                        ? null
                        : () => _abrir(
                            Enlaces.sms(elegido.celular, texto),
                            texto,
                          ),
                    icon: const Icon(Icons.sms_outlined),
                    label: Text(textos.avisoEnviarSms),
                  ),
                  FilledButton.icon(
                    onPressed: elegido == null
                        ? null
                        : () => _abrir(
                            Enlaces.whatsappConTexto(elegido.celular, texto),
                            texto,
                            compartirSiFalla: true,
                          ),
                    icon: const Icon(Icons.chat_outlined),
                    label: Text(textos.avisoEnviarWhatsapp),
                  ),
                  OutlinedButton.icon(
                    onPressed: () =>
                        ref.read(compartidorDeTextoProvider).compartir(texto),
                    icon: const Icon(Icons.share_outlined),
                    label: Text(textos.avisoCompartir),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(textos.avisoCerrar),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
