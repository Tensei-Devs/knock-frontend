import 'package:app/core/preferencias/preferencias_provider.dart';
import 'package:app/core/router/app_router.dart';
import 'package:app/core/tema/tema.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Raíz de la app: tema claro y oscuro de la maqueta e idiomas es/en.
///
/// Tema e idioma salen de [preferenciasProvider]; al cambiar se reconstruye
/// el `MaterialApp` sin volver a crear el router (TT-MOB-02).
class KnockApp extends ConsumerWidget {
  const KnockApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferencias = ref.watch(preferenciasProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: temaClaro,
      darkTheme: temaOscuro,
      themeMode: preferencias.modoTema,
      locale: preferencias.idioma,
      supportedLocales: idiomasSoportados,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
