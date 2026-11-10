# Tareas 014 — Alinear la UI con la maqueta

> **Estado:** en curso (spec Aprobada, KNOCK-242). Cada etapa va en su propio commit.

| Tarea | Qué se hace | Cubre | Estado |
|---|---|---|---|
| T-01 | Agregar Nunito 800 y 900, declararlas y fijar la escala de textos | R-01 · CA-01 | hecha |
| T-02 | Tokens de radios, alturas, espaciado y sombras; `ColoresKnock` | R-02 · R-04 · CA-02 · CA-03 | hecha |
| T-03 | Temas de botones, campos, barras, hoja y tarjeta; `TarjetaKnock`, `GrupoDeFilas`, `FilaKnock`, `EstadoKnock` | R-03 · R-05 · CA-04 | hecha |
| T-04 | Migrar entrada: celular, código y completar perfil | R-06 · CA-05 | hecha |
| T-05 | Migrar Inicio, Explorar, Actividad, Oficios, Mi cuenta y la barra inferior | R-06 · CA-06 | hecha |
| T-06 | Comprobar que no cambia lógica, rutas ni contratos y que la suite existente pasa | CA-07 · CA-08 | hecha (salida en el PR) |
| T-07 | Capturas de la app en un teléfono físico, en claro y en oscuro, junto a su par P-NN, con las diferencias anotadas | CA-09 | pendiente (necesita teléfono y decisión sobre su verificación) |
| T-08 | Regenerar `docs/architecture/*` con `scripts/codemap.py`, actualizar `Memoria.md` y abrir el PR con «Uso de IA» y la etiqueta `puntos-app-N` | spec §9 decisión 10 | pendiente |

## Definición de terminado
- Los criterios de aceptación de `spec.md` están cubiertos por pruebas en verde o por su comando con la salida en el PR.
- El CI está en verde, un par revisó el cambio y `Memoria.md` está al día.
