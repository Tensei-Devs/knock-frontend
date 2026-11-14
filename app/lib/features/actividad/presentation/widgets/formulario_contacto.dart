import 'package:app/features/actividad/domain/aviso.dart';
import 'package:app/features/actividad/presentation/aviso_controller.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Abre el formulario para agregar o editar un contacto (spec 022, CA-05 a
/// CA-07). Devuelve `true` si se guardó.
Future<bool> mostrarFormularioContacto(
  BuildContext context, {
  ContactoConfianza? contacto,
}) async =>
    await showDialog<bool>(
      context: context,
      builder: (_) => UncontrolledProviderScope(
        container: ProviderScope.containerOf(context),
        child: _FormularioContacto(contacto: contacto),
      ),
    ) ??
    false;

/// Texto de cada error del formulario (§7).
String mensajeErrorContacto(AppLocalizations textos, ErrorContacto error) {
  switch (error) {
    case ErrorContacto.nombre:
      return textos.avisoErrorNombre;
    case ErrorContacto.celular:
      return textos.avisoErrorCelular;
    case ErrorContacto.repetido:
      return textos.avisoErrorRepetido;
    case ErrorContacto.lleno:
      return textos.avisoErrorLleno;
  }
}

class _FormularioContacto extends ConsumerStatefulWidget {
  const _FormularioContacto({this.contacto});

  final ContactoConfianza? contacto;

  @override
  ConsumerState<_FormularioContacto> createState() =>
      _FormularioContactoState();
}

class _FormularioContactoState extends ConsumerState<_FormularioContacto> {
  late final TextEditingController _nombre;
  late final TextEditingController _celular;
  ErrorContacto? _error;
  var _guardando = false;

  @override
  void initState() {
    super.initState();
    _nombre = TextEditingController(text: widget.contacto?.nombre ?? '');
    _celular = TextEditingController(text: widget.contacto?.celular ?? '');
  }

  @override
  void dispose() {
    _nombre.dispose();
    _celular.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    setState(() => _guardando = true);
    final error = await ref
        .read(contactosProvider.notifier)
        .guardar(
          nombre: _nombre.text,
          celular: _celular.text,
          id: widget.contacto?.id,
        );
    if (!mounted) return;
    if (error == null) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _error = error;
        _guardando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final error = _error;
    final errorNombre = error == ErrorContacto.nombre
        ? textos.avisoErrorNombre
        : null;
    final errorCelular =
        error == ErrorContacto.celular || error == ErrorContacto.repetido
        ? mensajeErrorContacto(textos, error!)
        : null;
    return AlertDialog(
      title: Text(
        widget.contacto == null
            ? textos.avisoAgregarContacto
            : textos.avisoEditarContacto,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nombre,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: textos.avisoNombre,
                errorText: errorNombre,
                errorMaxLines: 2,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _celular,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: InputDecoration(
                labelText: textos.avisoCelular,
                errorText: errorCelular,
                errorMaxLines: 2,
              ),
            ),
            if (error == ErrorContacto.lleno) ...[
              const SizedBox(height: 12),
              Text(
                textos.avisoErrorLleno,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 12),
            Text(
              textos.avisoPrivacidad,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _guardando ? null : () => Navigator.of(context).pop(false),
          child: Text(textos.avisoCancelar),
        ),
        FilledButton(
          onPressed: _guardando ? null : _guardar,
          child: Text(textos.avisoGuardar),
        ),
      ],
    );
  }
}
