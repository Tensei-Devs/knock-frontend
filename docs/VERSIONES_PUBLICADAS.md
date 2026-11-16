# Versiones publicadas

> Registro de cada publicación del frontend (R-07 de la spec 011): una fila por publicación y componente (`app`, `panel`, `landing`). Se llena a mano hasta que el pipeline de publicación lo haga automático (T-03 de la spec 011, depende de KNOCK-221).
>
> - **Versión:** `X.Y.Z` calculada con `python scripts/ci/version.py bump --current <anterior> --points <N>`.
> - **Etiqueta de Git:** `<componente>-vX.Y.Z`.
> - **versionCode:** solo para la app; `python scripts/ci/version.py code --version <X.Y.Z> --n <n>`. `n` es el número de subida de esa versión (0 a 99).
> - **Cambios:** PR incluidos (`#N`). **Puntos:** suma de las etiquetas `puntos-<componente>-N` de esos PR; con 0 puntos la versión no cambia.

| Fecha | Componente | Versión | Etiqueta de Git | versionCode | Puntos | Cambios | Responsable |
|---|---|---|---|---|---|---|---|
| 2026-11-10 | app | 1.0.0 | app-v1.0.0-n0 | 1000000 | 0 | Primera publicación (R-01): la app completa de `develop` a `main` (#36). Pista interna de Google Play. | José Julián Hernández Hernández |
| 2026-11-10 | app | 1.0.0 | app-v1.0.0-n1 | 1000001 | 1 | Corrección del token de renovación (#32, 0 puntos) e ícono de lanzador (#37, 1 punto), llevados por #38 y #40. La versión no se subió en `app/pubspec.yaml` antes de publicar, así que salió como 1.0.0 con n=1; el punto se aplica en 1.0.1. Pista interna de Google Play. | José Julián Hernández Hernández |
