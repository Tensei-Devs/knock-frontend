import 'package:app/features/cuenta/data/perfil_repository_simulado.dart';
import 'package:app/features/cuenta/domain/perfil_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Repositorio del perfil (raíz de composición). SIMULADO hasta que existan
/// `GET/PUT /api/v1/me`; se cambia solo esta línea.
final perfilRepositoryProvider = Provider<PerfilRepository>(
  (ref) => PerfilRepositorySimulado(),
);
