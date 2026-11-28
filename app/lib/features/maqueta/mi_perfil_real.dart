import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/horarios_reales.dart';
import 'package:app/features/maqueta/servicios_reales.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/features/tecnico/tecnico.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// «Tu perfil público» con datos reales (spec 036, enmienda 2026-11-27): la
/// edición abre con lo guardado en `GET /tecnicos/me` y el `PUT` lleva solo
/// lo que cambió (CA-G01). Si la lectura falla no hay formulario, para no
/// pisar datos que la app no ve (CA-G02). Debajo, los servicios y los horarios
/// reales.
class MiPerfilReal extends ConsumerWidget {
  const MiPerfilReal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => stack([
    ...ref
        .watch(miPerfilProvider)
        .when(
          loading: () => [sMut('Cargando tu perfil…')],
          error: (error, _) => [
            NoteK(
              'red',
              'help',
              error is NoEncontradoFailure
                  ? 'No encontramos tu perfil de técnico.'
                  : error is Failure
                  ? mensajeDeError(AppLocalizations.of(context), error)
                  : 'No pudimos cargar tu perfil.',
            ),
            BtnK(
              'Reintentar',
              () => ref.invalidate(miPerfilProvider),
              kind: Bk.sec,
            ),
          ],
          data: (perfil) => [
            _Formulario(key: ValueKey(perfil), perfil: perfil),
            const CardK(child: MisServiciosReales()),
            const HorariosReales(),
          ],
        ),
  ], gap: 20);
}

class _Formulario extends ConsumerStatefulWidget {
  const _Formulario({super.key, required this.perfil});

  final MiPerfilTecnico perfil;

  @override
  ConsumerState<_Formulario> createState() => _FormularioState();
}

class _FormularioState extends ConsumerState<_Formulario> {
  late final EdicionPerfil _edicion = EdicionPerfil.desde(widget.perfil);
  late final _nombre = TextEditingController(text: _edicion.nombre);
  late final _negocio = TextEditingController(text: _edicion.nombreNegocio);
  late final _anios = TextEditingController(text: _edicion.anios);
  late final _descripcion = TextEditingController(text: _edicion.descripcion);
  late final _direccion = TextEditingController(text: _edicion.direccionTaller);
  bool _intento = false;
  bool _guardando = false;

  @override
  void dispose() {
    for (final c in [_nombre, _negocio, _anios, _descripcion, _direccion]) {
      c.dispose();
    }
    super.dispose();
  }

  EdicionPerfil _leida() => _edicion
    ..nombre = _nombre.text
    ..nombreNegocio = _negocio.text
    ..anios = _anios.text
    ..descripcion = _descripcion.text
    ..direccionTaller = _direccion.text;

  Future<void> _guardar() async {
    setState(() => _intento = true);
    final edicion = _leida();
    if (erroresDeEdicion(edicion).isNotEmpty) return;
    final cambios = cambiosDelPerfil(widget.perfil, edicion);
    if (cambios.isEmpty) {
      maq.toast('No hay cambios que guardar.');
      return;
    }
    setState(() => _guardando = true);
    try {
      await ref.read(miPerfilRepositoryProvider).guardar(cambios);
      maq.toast('Guardamos tu perfil.');
      ref.invalidate(miPerfilProvider);
    } on Failure catch (falla) {
      // Lo escrito se conserva para corregirlo (CA-32).
      if (mounted) {
        maq.toast(mensajeDeError(AppLocalizations.of(context), falla));
      }
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final errores = _intento
        ? erroresDeEdicion(_leida())
        : const <CampoPerfil, String>{};
    void alCambiar(String _) {
      if (_intento) setState(() {});
    }

    final p = widget.perfil;
    return stack([
      FieldK(
        label: 'Tu nombre completo',
        c: _nombre,
        maxLen: 80,
        err: errores[CampoPerfil.nombre],
        onChanged: alCambiar,
      ),
      FieldK(
        label: 'Nombre de tu negocio',
        opt: true,
        c: _negocio,
        maxLen: 60,
        err: errores[CampoPerfil.nombreNegocio],
        onChanged: alCambiar,
      ),
      FieldK(
        label: 'Años de experiencia',
        opt: true,
        c: _anios,
        keyboard: TextInputType.number,
        maxLen: 2,
        err: errores[CampoPerfil.anios],
        onChanged: alCambiar,
      ),
      if (p.atiendeEnTaller)
        FieldK(
          label: 'Dirección de tu taller',
          c: _direccion,
          maxLen: 200,
          err: errores[CampoPerfil.direccionTaller],
          onChanged: alCambiar,
        ),
      if (p.vaADomicilio)
        stack([
          bT('Hasta dónde vas'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final km in radiosDeAtencionKm)
                ChipK(
                  '$km km',
                  on: _edicion.radioKm == km,
                  onTap: () => setState(() => _edicion.radioKm = km),
                ),
            ],
          ),
        ], gap: 8),
      FieldK(
        label: 'Sobre ti y tu trabajo',
        opt: true,
        c: _descripcion,
        lines: 4,
        maxLen: 300,
        err: errores[CampoPerfil.descripcion],
        onChanged: alCambiar,
      ),
      sMut(
        'Tus oficios y tu foto se cambian después; aquí no se tocan.',
        size: 13,
      ),
      BtnK('Guardar cambios', () => unawaited(_guardar()), busy: _guardando),
    ], gap: 14);
  }
}
