import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/core/router/destino_de_regreso_provider.dart';
import 'package:app/core/router/rutas.dart';
import 'package:app/core/tema/tokens.dart';
import 'package:app/features/cuenta/domain/perfil.dart';
import 'package:app/features/cuenta/presentation/avatar_iniciales.dart';
import 'package:app/features/cuenta/presentation/perfil_controller.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Completar el perfil la primera vez (HU-002): nombre y, al guardar,
/// «¡Listo, ya entraste!». Los pasos de zona (HU-009) y foto no están aún.
/// El guardado es SIMULADO (`PUT /me` no existe todavía).
class CompletarPerfilScreen extends ConsumerStatefulWidget {
  const CompletarPerfilScreen({super.key});

  @override
  ConsumerState<CompletarPerfilScreen> createState() => _EstadoCompletar();
}

class _EstadoCompletar extends ConsumerState<CompletarPerfilScreen> {
  final _formulario = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  bool _guardando = false;
  bool _listo = false;

  @override
  void dispose() {
    _nombre.dispose();
    super.dispose();
  }

  Future<void> _continuar() async {
    if (!_formulario.currentState!.validate()) return;
    setState(() => _guardando = true);
    final error = await ref
        .read(perfilControllerProvider.notifier)
        .guardarNombre(_nombre.text);
    if (!mounted) return;
    setState(() {
      _guardando = false;
      _listo = error == null;
    });
    if (error != null) {
      final textos = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensajeDeError(textos, error)),
          action: SnackBarAction(
            label: textos.inicioReintentar,
            onPressed: _continuar,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_listo) return _Listo(nombre: _nombre.text.trim());
    return Scaffold(
      appBar: AppBar(title: const Text('Tu perfil')),
      body: Form(
        key: _formulario,
        child: ListView(
          padding: const EdgeInsets.all(Espaciado.cuerpo),
          children: [
            Text(
              '¿Cómo te llamas?',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            const Text('Así sabrán con quién tratan los técnicos y clientes.'),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nombre,
              decoration: const InputDecoration(labelText: 'Nombre'),
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              maxLength: 60,
              validator: validarNombre,
              onFieldSubmitted: (_) => _continuar(),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _guardando ? null : _continuar,
              child: _guardando
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        semanticsLabel: 'Guardando',
                      ),
                    )
                  : const Text('Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Listo extends ConsumerWidget {
  const _Listo({required this.nombre});

  final String nombre;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AvatarIniciales(perfil: Perfil(nombre: nombre), radio: 40),
            const SizedBox(height: 16),
            Text(
              '¡Listo, ya entraste!',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                // Spec 027, R-09: tras completar el perfil se continúa al
                // destino de regreso (válido) o a Inicio.
                final destino = destinoDeRegreso(
                  ref.read(destinoDeRegresoProvider),
                );
                ref.read(destinoDeRegresoProvider.notifier).olvidar();
                context.go(destino);
              },
              child: const Text('Empezar'),
            ),
          ],
        ),
      ),
    ),
  );
}
