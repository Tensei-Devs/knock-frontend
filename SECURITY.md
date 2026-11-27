# Política de seguridad — Knock

## Reportar una vulnerabilidad
**No publiques detalles en issues, PR ni otros canales abiertos.** Reporta en privado al líder del equipo (Tech Lead, `@JulianH2`).
Incluye: componente y versión, pasos para reproducir, impacto y, si puedes, una prueba de concepto sin datos reales.

| Paso | Plazo objetivo |
|---|---|
| Acuse de recibo | 2 días hábiles |
| Clasificación (severidad y explotabilidad, CVSS 4.0) | 5 días hábiles |
| Corrección de críticas / altas | 7 / 14 días |
| Aviso a quien reportó y crédito (si lo desea) | al publicar la corrección |

Proyecto académico en piloto: no hay programa de recompensas. No hagas pruebas contra producción ni con datos de otras personas;
usa un entorno local y cuentas de prueba.

## Versiones con soporte
Solo la versión más reciente de cada componente (`app-v*`, `panel-v*`, `landing-v*`).

## Cómo gestionamos hallazgos
- **Bloqueo:** una vulnerabilidad crítica o alta explotable en el contexto de ejecución bloquea el merge. El CI corre Semgrep, OSV-Scanner, dependency-review, Gitleaks y, en el panel, `npm audit`.
- **Falsos positivos y riesgos aceptados:** solo con evidencia y registro en [`security/exceptions.yaml`](security/exceptions.yaml) (responsable, alcance, vencimiento ≤ 90 días, plan). El CI falla con excepciones vencidas o supresiones sin `EXC-NNN`.
- **Datos sensibles:** INE, selfie, CURP, dirección y teléfono se tratan según la constitución §6. Un incidente con estos datos se escala de inmediato al Tech Lead.
- Un escáner sin alertas no prueba que el sistema sea seguro: cada historia incluye su análisis de amenazas y pruebas de seguridad negativa.
