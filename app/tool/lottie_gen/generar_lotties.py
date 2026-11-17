#!/usr/bin/env python3
"""Genera las animaciones Lottie propias de Knock (sin descargas de terceros).

Uso (desde app/):  python tool/lottie_gen/generar_lotties.py
Escribe JSON ligeros en assets/lottie/. Colores: naranja de Knock #E9682D y
neutros (#948779 y claros con opacidad) que se ven bien en tema claro y oscuro.
"""
import json
import math
import os

FR = 60
OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "assets", "lottie")

ORANGE = "#E9682D"
ORANGE_L = "#F5A26B"
GRAY = "#948779"
WHITE = "#FFFFFF"


def rgb(h):
    h = h.lstrip("#")
    return [round(int(h[i:i + 2], 16) / 255, 3) for i in (0, 2, 4)] + [1]


def r2(v):
    return round(v, 2)


# ---------------------------------------------------------------- propiedades
EASES = {
    "io": ((0.42, 0.0), (0.58, 1.0)),
    "out": ((0.0, 0.0), (0.4, 1.0)),
    "in": ((0.6, 0.0), (1.0, 1.0)),
    "back": ((0.34, 1.56), (0.64, 1.0)),
    "lin": ((0.0, 0.0), (1.0, 1.0)),
}


def S(v):
    return {"a": 0, "k": v}


def A(kfs):
    """kfs: [(frame, valor, ease)]; el ease aplica al tramo que SALE del fotograma."""
    out = []
    for i, kf in enumerate(kfs):
        t, v = kf[0], kf[1]
        e = kf[2] if len(kf) > 2 else "io"
        v = [r2(x) for x in v] if isinstance(v, (list, tuple)) else [r2(v)]
        k = {"t": t, "s": v}
        if i < len(kfs) - 1:
            (ox, oy), (ix, iy) = EASES[e]
            k["o"] = {"x": [ox], "y": [oy]}
            k["i"] = {"x": [ix], "y": [iy]}
        out.append(k)
    return {"a": 1, "k": out}


def P(v):
    if isinstance(v, dict):
        return v
    if isinstance(v, (list, tuple)):
        return S([r2(x) for x in v])
    return S(r2(v))


# ---------------------------------------------------------------- formas
def ell(w, h=None, c=(0, 0)):
    return {"ty": "el", "p": P(list(c)), "s": P([w, h if h is not None else w]), "nm": "el"}


def rect(w, h, rad=0, c=(0, 0)):
    return {"ty": "rc", "p": P(list(c)), "s": P([w, h]), "r": P(rad), "nm": "rc"}


def path(v, i=None, o=None, closed=False):
    n = len(v)
    i = i or [[0, 0]] * n
    o = o or [[0, 0]] * n
    return {"ty": "sh", "nm": "sh", "ks": S({"i": i, "o": o, "v": v, "c": closed})}


def fill(color, op=100):
    return {"ty": "fl", "c": S(rgb(color)), "o": P(op), "r": 1, "nm": "fl"}


def stroke(color, w, op=100):
    return {"ty": "st", "c": S(rgb(color)), "o": P(op), "w": P(w), "lc": 2, "lj": 2, "nm": "st"}


def trim(start=0, end=100):
    return {"ty": "tm", "s": P(start), "e": P(end), "o": P(0), "m": 1, "nm": "tm"}


def tr(p=(0, 0), a=(0, 0), s=(100, 100), r=0, o=100):
    return {"ty": "tr", "p": P(p), "a": P(a), "s": P(s), "r": P(r), "o": P(o), "sk": P(0), "sa": P(0)}


def g(items, **kw):
    return {"ty": "gr", "nm": "g", "it": list(items) + [tr(**kw)]}


def lottie(name, op, groups):
    layer = {
        "ddd": 0, "ind": 1, "ty": 4, "nm": name, "sr": 1,
        "ks": {"o": S(100), "r": S(0), "p": S([100, 100, 0]), "a": S([100, 100, 0]), "s": S([100, 100, 100])},
        "ao": 0, "shapes": groups[::-1], "ip": 0, "op": op, "st": 0, "bm": 0,
    }
    return {"v": "5.7.0", "fr": FR, "ip": 0, "op": op, "w": 200, "h": 200, "nm": name, "ddd": 0, "assets": [], "layers": [layer]}


# ---------------------------------------------------------------- animaciones
def buscando_mapa():
    op = 180
    mapa = [
        g([rect(150, 150, 24, (100, 100)), fill(GRAY, 16), stroke(GRAY, 3, 40)]),
        g([path([[40, 78], [160, 78]]), path([[40, 124], [160, 124]]), path([[88, 30], [88, 170]]), path([[134, 30], [134, 170]]),
           path([[30, 150], [88, 124]]), stroke(GRAY, 5, 45)]),
        g([rect(28, 22, 6, (60, 52)), rect(30, 24, 6, (112, 100)), rect(26, 22, 6, (150, 150)), rect(30, 24, 6, (56, 148)), fill(GRAY, 22)]),
    ]
    pines = []
    for (x, y, t0) in [(112, 56, 40), (62, 100, 105), (112, 148, 150)]:
        pines.append(g([ell(14, c=(0, 0)), fill(ORANGE)], p=(x, y),
                       s=A([(0, [0, 0], "out"), (t0, [0, 0], "back"), (t0 + 16, [100, 100], "io"), (op - 14, [100, 100], "in"), (op, [0, 0])]),
                       o=100))
        pines.append(g([ell(5), fill(WHITE)], p=(x, y),
                       s=A([(0, [0, 0], "out"), (t0, [0, 0], "back"), (t0 + 16, [100, 100], "io"), (op - 14, [100, 100], "in"), (op, [0, 0])])))
    lupa = g([
        g([ell(40), stroke(ORANGE, 7), fill(ORANGE, 14)]),
        g([path([[14, 14], [34, 34]]), stroke(ORANGE, 9)]),
    ], p=A([(0, [66, 70], "io"), (45, [128, 62], "io"), (90, [122, 124], "io"), (135, [72, 128], "io"), (180, [66, 70])]),
        r=A([(0, -6, "io"), (45, 8, "io"), (90, -4, "io"), (135, 6, "io"), (180, -6)]), a=(0, 0))
    return lottie("buscando_mapa", op, mapa + pines + [lupa])


def puntos():
    op = 72
    gs = []
    for i, x in enumerate([62, 100, 138]):
        d = i * 8
        y = A([(0, [x, 112], "out"), (d, [x, 112], "out"), (d + 14, [x, 84], "in"), (d + 28, [x, 112], "out"), (op, [x, 112])])
        s = A([(0, [100, 100], "io"), (d, [100, 100], "io"), (d + 14, [90, 112], "io"), (d + 28, [100, 100], "io"), (op, [100, 100])])
        gs.append(g([ell(22), fill(ORANGE if i != 1 else ORANGE_L)], p=y, s=s))
    return lottie("puntos", op, gs)


def exito():
    op = 120
    gs = []
    cols = [ORANGE, ORANGE_L, GRAY, ORANGE, WHITE]
    n = 16
    for k in range(n):
        ang = (k / n) * 2 * math.pi + (0.18 if k % 2 else 0)
        rad = 62 + (k % 4) * 9
        dx, dy = math.cos(ang) * rad, math.sin(ang) * rad
        t0 = 20
        sz = 6 + (k % 3) * 2
        shape = rect(sz, sz * 0.55, 2) if k % 2 == 0 else ell(sz * 0.8)
        gs.append(g([shape, fill(cols[k % len(cols)])],
                    p=A([(0, [100, 100], "out"), (t0, [100, 100], "out"), (t0 + 34, [100 + dx, 100 + dy], "out"), (t0 + 70, [100 + dx * 1.08, 100 + dy * 1.08 + 18])]),
                    r=A([(0, 0, "io"), (t0, 0, "lin"), (t0 + 70, 220 + k * 20)]),
                    s=A([(0, [0, 0], "io"), (t0, [0, 0], "back"), (t0 + 6, [100, 100], "io"), (t0 + 70, [100, 100])]),
                    o=A([(0, 100, "io"), (t0 + 30, 100, "in"), (t0 + 70, 0)])))
    gs.append(g([ell(104), stroke(ORANGE, 4)], p=(100, 100),
                s=A([(0, [60, 60], "io"), (16, [60, 60], "out"), (60, [150, 150])]),
                o=A([(0, 0, "io"), (16, 0, "out"), (20, 55, "out"), (60, 0)])))
    gs.append(g([ell(96), fill(ORANGE)], p=(100, 100),
                s=A([(0, [0, 0], "back"), (20, [112, 112], "io"), (30, [100, 100])])))
    gs.append(g([path([[72, 102], [92, 122], [130, 80]]), stroke(WHITE, 11), trim(0, A([(0, 0, "io"), (22, 0, "out"), (44, 100)]))]))
    return lottie("exito", op, gs)


def escudo():
    op = 168
    v = [[100, 34], [152, 54], [152, 98], [100, 164], [48, 98], [48, 54]]
    i = [[0, 0], [0, 0], [0, -26], [30, 12], [0, 0], [0, 0]]
    o = [[0, 0], [0, 0], [0, 26], [-30, -12], [0, -26], [0, 0]]
    # curvas: el tramo 152,98 -> 100,164 y 100,164 -> 48,98
    i = [[0, 0], [0, 0], [0, 0], [26, 8], [0, 26], [0, 0]]
    o = [[0, 0], [0, 0], [0, 26], [-26, 8], [0, 0], [0, 0]]
    sh = path(v, i, o, closed=True)
    op_ = A([(0, 100, "lin"), (136, 100, "in"), (164, 0)])
    gs = [
        g([sh, fill(ORANGE, A([(0, 0, "io"), (50, 0, "io"), (74, 18, "io"), (164, 18)]))], o=op_),
        g([sh, stroke(ORANGE, 9), trim(0, A([(0, 0, "io"), (52, 100, "io")]))], o=op_,
          p=(100, 100), a=(100, 100), s=A([(0, [100, 100], "io"), (88, [100, 100], "io"), (102, [106, 106], "io"), (118, [100, 100])])),
        g([path([[78, 100], [96, 118], [126, 80]]), stroke(ORANGE, 10), trim(0, A([(0, 0, "io"), (62, 0, "out"), (86, 100)]))], o=op_),
    ]
    return lottie("escudo", op, gs)


def subiendo_foto():
    op = 120
    gs = [
        g([rect(112, 88, 16, (100, 84)), stroke(GRAY, 6), fill(GRAY, 10)]),
        g([path([[56, 112], [82, 78], [100, 98], [114, 82], [144, 112]], closed=True), fill(GRAY, 42)]),
        g([ell(16), fill(ORANGE)], p=(130, 62)),
        g([rect(104, 9, 4.5, (100, 166)), fill(GRAY, 30)]),
        g([rect(104, 9, 4.5, (100, 166)), fill(ORANGE)], a=(48, 166), p=(48, 166),
          s=A([(0, [0, 100], "io"), (96, [100, 100], "io"), (120, [100, 100])]),
          o=A([(0, 100, "lin"), (104, 100, "in"), (118, 0)])),
        g([g([ell(34), fill(ORANGE)]),
           g([path([[0, 9], [0, -8]]), path([[-8, 0], [0, -9], [8, 0]]), stroke(WHITE, 5)])],
          p=A([(0, [146, 128], "out"), (50, [146, 118], "io"), (100, [146, 128])]),
          s=A([(0, [100, 100])]) if False else (100, 100)),
    ]
    return lottie("subiendo_foto", op, gs)


def _vacio_base(name, op, gs):
    return lottie(name, op, gs)


def vacio_actividad():
    op = 180
    gs = [
        g([rect(96, 124, 16, (100, 108)), stroke(GRAY, 6), fill(GRAY, 10)]),
        g([rect(40, 16, 7, (100, 46)), fill(ORANGE)]),
    ]
    for k, y in enumerate([84, 114, 144]):
        gs.append(g([path([[92, y], [128, y]]), stroke(GRAY, 6, 55)]))
        t0 = 24 + k * 40
        gs.append(g([ell(16), stroke(GRAY, 4, 70)], p=(72, y)))
        gs.append(g([path([[-4, 0], [-1, 3.5], [5, -4]]), stroke(ORANGE, 4.5)], p=(72, y),
                    s=A([(0, [0, 0], "io"), (t0, [0, 0], "back"), (t0 + 14, [100, 100], "io"), (156, [100, 100], "in"), (172, [0, 0])])))
    gs.append(g([ell(26), fill(ORANGE_L, 0)], p=(100, 100)))
    return lottie(name_ := "vacio_actividad", op, gs)


def vacio_mensajes():
    op = 150
    bubble = path([[56, 62], [144, 62], [144, 120], [96, 120], [76, 142], [76, 120], [56, 120]],
                  i=[[0, 0]] * 7, o=[[0, 0]] * 7, closed=True)
    gs = []
    inner = [
        g([rect(100, 64, 20, (100, 92)), stroke(GRAY, 6), fill(GRAY, 10)]),
        g([path([[70, 120], [66, 144], [92, 124]]), fill(GRAY, 10), stroke(GRAY, 6)]),
        g([rect(14, 8, 0, (86, 123)), fill(GRAY, 0)]),
    ]
    for k, x in enumerate([78, 100, 122]):
        d = k * 12
        inner.append(g([ell(13), fill(ORANGE)], p=A([(0, [x, 92], "out"), (d, [x, 92], "out"), (d + 14, [x, 84], "io"), (d + 28, [x, 92], "io"), (op, [x, 92])]),
                       o=A([(0, 55, "io"), (d, 55, "io"), (d + 14, 100, "io"), (d + 28, 55, "io"), (op, 55)])))
    gs.append(g(inner, a=(100, 100), p=A([(0, [100, 100], "io"), (75, [100, 95], "io"), (150, [100, 100])])))
    return lottie("vacio_mensajes", op, gs)


def vacio_busqueda():
    op = 160

    def chispa(cx, cy, s, d):
        return g([path([[0, -8], [0, 8]]), path([[-8, 0], [8, 0]]), stroke(ORANGE, 4)], p=(cx, cy),
                 s=A([(0, [s, s], "io"), (d, [s, s], "io"), (d + 20, [s * 1.35, s * 1.35], "io"), (d + 40, [s * 0.4, s * 0.4], "io"), (op, [s, s])]),
                 o=A([(0, 100, "io"), (d + 40, 40, "io"), (op, 100)]))
    lupa = g([
        g([ell(70), stroke(GRAY, 9), fill(GRAY, 10)]),
        g([path([[25, 25], [50, 50]]), stroke(ORANGE, 11)]),
        g([path([[-12, -8], [0, -20]], i=[[0, 0], [0, 0]], o=[[0, 0], [0, 0]]), stroke(GRAY, 4, 60)]),
    ], p=(92, 90), a=(0, 0),
        r=A([(0, -7, "io"), (40, 7, "io"), (80, -7, "io"), (120, 7, "io"), (160, -7)]))
    return lottie("vacio_busqueda", op, [lupa, chispa(150, 54, 100, 0), chispa(50, 150, 70, 30), chispa(152, 140, 60, 70)])


GENERADORES = {
    "buscando_mapa": buscando_mapa,
    "puntos": puntos,
    "exito": exito,
    "escudo": escudo,
    "subiendo_foto": subiendo_foto,
    "vacio_actividad": vacio_actividad,
    "vacio_mensajes": vacio_mensajes,
    "vacio_busqueda": vacio_busqueda,
}


def main():
    os.makedirs(OUT, exist_ok=True)
    for nombre, fn in GENERADORES.items():
        ruta = os.path.join(OUT, nombre + ".json")
        with open(ruta, "w", encoding="utf-8", newline="\n") as f:
            json.dump(fn(), f, separators=(",", ":"))
        print(f"{nombre}.json  {os.path.getsize(ruta) / 1024:.1f} KB")


if __name__ == "__main__":
    main()
