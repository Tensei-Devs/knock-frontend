# Versiones publicadas

> Registro de cada publicación del frontend (R-07 de la spec 011): una fila por publicación y componente (`app`, `panel`, `landing`). Se llena a mano hasta que el pipeline de publicación lo haga automático (T-03 de la spec 011, depende de KNOCK-221).
>
> - **Versión:** `X.Y.Z` calculada con `python scripts/ci/version.py bump --current <anterior> --points <N>`.
> - **Etiqueta de Git:** `<componente>-vX.Y.Z`.
> - **versionCode:** solo para la app; `python scripts/ci/version.py code --version <X.Y.Z> --n <n>`. `n` es el número de subida de esa versión (0 a 99).
> - **Cambios:** PR incluidos (`#N`). **Puntos:** suma de las etiquetas `puntos-<componente>-N` de esos PR; con 0 puntos la versión no cambia.

| Fecha | Componente | Versión | Etiqueta de Git | versionCode | Puntos | Cambios | Responsable |
|---|---|---|---|---|---|---|---|
