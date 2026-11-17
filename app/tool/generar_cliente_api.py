#!/usr/bin/env python3
"""Genera el cliente Dart de la API (spec 006, KNOCK-220) desde contracts/openapi.v1.json.

Uso (desde la raíz del repositorio, Python 3.11+ y Java 11+):
    python app/tool/generar_cliente_api.py            # regenera app/packages/knock_api/
    python app/tool/generar_cliente_api.py --check    # falla (exit 1) si el cliente no corresponde al contrato

Qué hace, siempre igual:
1. Lee el contrato vendorizado (OpenAPI 3.2.0, el que publica knock-backend).
2. Lo normaliza a OpenAPI 3.1.0 en memoria, porque openapi-generator 7.27.0 no
   acepta 3.2 (falla con «attribute openapi is unexpected»). La normalización es
   mecánica y no inventa nada (ver `normalizar`). El contrato en contracts/ no se toca.
3. Descarga openapi-generator-cli 7.27.0 de Maven Central (una vez, a una caché
   fuera del repositorio) y comprueba su SHA-256 antes de ejecutarlo.
4. Genera con el generador `dart` (serialización nativa y `package:http`, sin
   build_runner) en una carpeta temporal y la copia a app/packages/knock_api/.
5. Quita los comentarios `// ignore` que agrega el generador (ver `quitar_ignores`).
6. Escribe app/packages/knock_api/.knock-manifest.json con el SHA-256 del
   contrato y de cada archivo generado; app/test/api/cliente_generado_test.dart
   lo comprueba en cada `flutter test`.

Con --check regenera en una carpeta temporal y compara archivo por archivo con lo
que está en el repositorio (R-04): si alguien editó el cliente a mano o cambió el
contrato sin regenerar, sale con código 1 y lista las diferencias.
"""
from __future__ import annotations

import argparse
import copy
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
import urllib.request
from pathlib import Path

RAIZ = Path(__file__).resolve().parents[2]
CONTRATO = RAIZ / "contracts" / "openapi.v1.json"
DESTINO = RAIZ / "app" / "packages" / "knock_api"
MANIFIESTO = ".knock-manifest.json"

GENERADOR_VERSION = "7.27.0"
GENERADOR_URL = (
    "https://repo1.maven.org/maven2/org/openapitools/openapi-generator-cli/"
    f"{GENERADOR_VERSION}/openapi-generator-cli-{GENERADOR_VERSION}.jar"
)
# SHA-256 calculado al fijar la versión; su SHA-1 coincide con el .sha1 publicado en Maven Central.
GENERADOR_SHA256 = "db9c4b738727698748746144394cb7ee96512fe50166555baaeeca9311ee1dba"

# Archivos del generador que no aportan nada al cliente (scripts de publicación y CI ajenos).
IGNORAR_GENERADOS = ["git_push.sh", ".travis.yml"]

OPCIONES = [
    "-g", "dart",
    "--additional-properties=pubName=knock_api,pubVersion=1.0.0,"
    "pubDescription=Cliente generado de la API de Knock (no editar)",
    "--global-property=apiTests=false,modelTests=false",
    "--skip-validate-spec",
]


# El generador escribe comentarios `// ignore:` y `// ignore_for_file:` que
# scripts/ci/check_exceptions.py trata como supresiones sin EXC-NNN. El paquete
# no se analiza (app/analysis_options.yaml lo excluye), así que se quitan al
# generar: es un paso automático y reproducible, nunca una edición a mano.
_IGNORE_LINEA = re.compile(r"^\s*//\s*ignore(?:_for_file)?:.*$")
_IGNORE_FINAL = re.compile(r"\s*//\s*ignore(?:_for_file)?:.*$")


def quitar_ignores(codigo: str) -> str:
    lineas = []
    for linea in codigo.split("\n"):
        if _IGNORE_LINEA.match(linea):
            continue
        lineas.append(_IGNORE_FINAL.sub("", linea))
    return "\n".join(lineas)


class ErrorNormalizacion(Exception):
    """El contrato usa algo que la normalización no sabe convertir sin inventar."""


def _normalizar_tipo(esquema: dict, ruta: str) -> None:
    tipo = esquema.get("type")
    if not isinstance(tipo, list):
        return
    sin_nulo = [t for t in tipo if t != "null"]
    acepta_nulo = len(sin_nulo) != len(tipo)
    if len(sin_nulo) == 1:
        nuevo = sin_nulo
    elif set(sin_nulo) in ({"integer", "string"}, {"number", "string"}):
        # ASP.NET Core declara así los números que también acepta como texto
        # (JsonNumberHandling.AllowReadingFromString). El valor real es numérico:
        # se queda el tipo numérico y se quita el patrón que solo aplica al texto.
        nuevo = [t for t in sin_nulo if t != "string"]
        esquema.pop("pattern", None)
    else:
        raise ErrorNormalizacion(f"{ruta}: tipo {tipo} sin regla de normalización")
    esquema["type"] = ["null", *nuevo] if acepta_nulo else nuevo[0]


def _recorrer(nodo: object, ruta: str) -> None:
    if isinstance(nodo, dict):
        _normalizar_tipo(nodo, ruta)
        for clave, valor in nodo.items():
            _recorrer(valor, f"{ruta}/{clave}")
    elif isinstance(nodo, list):
        for i, valor in enumerate(nodo):
            _recorrer(valor, f"{ruta}/{i}")


def normalizar(contrato: dict) -> dict:
    """Devuelve una copia del contrato en OpenAPI 3.1.0 que openapi-generator acepta.

    Reglas (todas mecánicas):
    - `openapi: 3.2.x` → `3.1.0` (los contratos de Knock no usan nada exclusivo de 3.2;
      si aparece una clave desconocida para 3.1, el generador la ignora).
    - `type: [null, integer, string]` (número que también se lee como texto) → `[null, integer]`
      y se quita `pattern`; igual con `number`.
    - Cualquier otra unión de tipos detiene la generación con un error.
    """
    version = str(contrato.get("openapi", ""))
    if not (version.startswith("3.2") or version.startswith("3.1")):
        raise ErrorNormalizacion(f"versión OpenAPI no soportada: {version!r}")
    copia = copy.deepcopy(contrato)
    copia["openapi"] = "3.1.0"
    _recorrer(copia, "#")
    return copia


def _sha256(datos: bytes) -> str:
    return hashlib.sha256(datos).hexdigest()


def _contenido_lf(ruta: Path) -> bytes:
    return ruta.read_bytes().replace(b"\r\n", b"\n")


def _cache_generador() -> Path:
    base = os.environ.get("KNOCK_TOOL_CACHE") or str(Path.home() / ".cache" / "knock")
    return Path(base) / f"openapi-generator-cli-{GENERADOR_VERSION}.jar"


def obtener_generador() -> Path:
    jar = _cache_generador()
    if not jar.exists() or _sha256(jar.read_bytes()) != GENERADOR_SHA256:
        jar.parent.mkdir(parents=True, exist_ok=True)
        print(f"Descargando openapi-generator-cli {GENERADOR_VERSION}…", file=sys.stderr)
        with urllib.request.urlopen(GENERADOR_URL, timeout=120) as respuesta:  # noqa: S310 (URL fija https)
            datos = respuesta.read()
        if _sha256(datos) != GENERADOR_SHA256:
            raise SystemExit("El SHA-256 del generador descargado no coincide: no se ejecuta.")
        jar.write_bytes(datos)
    return jar


def manifiesto(carpeta: Path, sha_contrato: str) -> dict:
    archivos = {}
    # Orden por la ruta como texto: sorted(Path) no distingue mayúsculas en Windows y sí en Linux, y el manifiesto
    # cambiaba de orden según el sistema que lo generaba (el CI corre en Linux).
    rutas = sorted((r.relative_to(carpeta).as_posix(), r) for r in carpeta.rglob("*") if r.is_file() and r.name != MANIFIESTO)
    for relativa, ruta in rutas:
        archivos[relativa] = _sha256(_contenido_lf(ruta))
    return {
        "aviso": "Generado por app/tool/generar_cliente_api.py. No editar a mano.",
        "generador": f"openapi-generator-cli {GENERADOR_VERSION} (dart)",
        "contrato": "contracts/openapi.v1.json",
        "contratoSha256": sha_contrato,
        "archivos": archivos,
    }


def generar_en(salida: Path) -> None:
    datos_contrato = _contenido_lf(CONTRATO)
    normalizado = normalizar(json.loads(datos_contrato.decode("utf-8")))
    jar = obtener_generador()
    with tempfile.TemporaryDirectory(prefix="knock-api-") as tmp:
        tmp_path = Path(tmp)
        entrada = tmp_path / "openapi.3.1.json"
        entrada.write_text(json.dumps(normalizado, indent=2, ensure_ascii=False), encoding="utf-8")
        generado = tmp_path / "salida"
        generado.mkdir()
        (generado / ".openapi-generator-ignore").write_text(
            "".join(f"{nombre}\n" for nombre in IGNORAR_GENERADOS), encoding="utf-8"
        )
        resultado = subprocess.run(
            ["java", "-jar", str(jar), "generate", "-i", str(entrada), "-o", str(generado), *OPCIONES],
            capture_output=True,
            text=True,
            check=False,
        )
        if resultado.returncode != 0:
            sys.stderr.write(resultado.stdout[-4000:] + resultado.stderr[-4000:])
            raise SystemExit("openapi-generator falló")
        # Saltos de línea LF en todos los archivos, para que la comparación no dependa del sistema.
        for ruta in generado.rglob("*"):
            if ruta.is_file():
                contenido = _contenido_lf(ruta)
                if ruta.suffix == ".dart":
                    contenido = quitar_ignores(contenido.decode("utf-8")).encode("utf-8")
                ruta.write_bytes(contenido)
        datos_manifiesto = manifiesto(generado, _sha256(datos_contrato))
        (generado / MANIFIESTO).write_text(
            json.dumps(datos_manifiesto, indent=2, ensure_ascii=False) + "\n", encoding="utf-8"
        )
        if salida.exists():
            shutil.rmtree(salida)
        shutil.copytree(generado, salida)


def comparar(esperado: Path, actual: Path) -> list[str]:
    def listar(carpeta: Path) -> dict[str, bytes]:
        if not carpeta.exists():
            return {}
        return {
            r.relative_to(carpeta).as_posix(): _contenido_lf(r)
            for r in carpeta.rglob("*")
            if r.is_file() and ".dart_tool" not in r.parts and r.name != "pubspec.lock"
        }

    a, b = listar(esperado), listar(actual)
    diferencias = [f"falta: {n}" for n in sorted(a.keys() - b.keys())]
    diferencias += [f"sobra: {n}" for n in sorted(b.keys() - a.keys())]
    diferencias += [f"distinto: {n}" for n in sorted(a.keys() & b.keys()) if a[n] != b[n]]
    return diferencias


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--check", action="store_true", help="solo comprueba; no escribe")
    parser.add_argument("--contrato", type=Path, help="otro contrato (solo para pruebas del script)")
    parser.add_argument("--destino", type=Path, help="otra carpeta de salida (solo para pruebas del script)")
    args = parser.parse_args(argv)
    global CONTRATO, DESTINO
    CONTRATO = (args.contrato or CONTRATO).resolve()
    DESTINO = (args.destino or DESTINO).resolve()
    if not args.check:
        generar_en(DESTINO)
        print(f"Cliente generado en {DESTINO.as_posix()}")
        return 0
    with tempfile.TemporaryDirectory(prefix="knock-api-check-") as tmp:
        esperado = Path(tmp) / "knock_api"
        generar_en(esperado)
        diferencias = comparar(esperado, DESTINO)
    if diferencias:
        print("El cliente generado no corresponde a contracts/openapi.v1.json:")
        for linea in diferencias:
            print(f"  {linea}")
        print("Regenera con: python app/tool/generar_cliente_api.py")
        return 1
    print("OK: app/packages/knock_api corresponde a contracts/openapi.v1.json")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
