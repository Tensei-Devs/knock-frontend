# Spec 012 — Notificaciones push y permisos del teléfono

> **Estado:** Aprobada · **Repositorio:** knock-frontend · **Rector:** `constitution.md`

## 1. Objetivo
Definir la infraestructura común de las notificaciones y de los permisos del teléfono, sin implementar los avisos concretos de negocio.

## 2. Alcance
**Dentro**
- Registro del identificador del teléfono para notificaciones.
- Apertura de la pantalla destino al tocar una notificación.
- Reglas de contenido de las notificaciones.
- Solicitud de permisos al usarlos y comportamiento si se niegan.

**Fuera**
- Los avisos concretos de cotizaciones, mensajes y visitas.
- El envío desde el backend.

## 3. Requisitos
- **R-01:** La app registra el identificador de notificaciones del teléfono al iniciar sesión y lo desregistra al cerrar sesión.
- **R-02:** Cada notificación abre la pantalla que le corresponde.
- **R-03:** Los textos de las notificaciones no incluyen información sensible, como códigos de visita o direcciones.
- **R-04:** Si la persona está dentro del chat, el mensaje llega en vivo y no se muestra la notificación.
- **R-05:** Cada persona elige qué avisos recibir en la configuración.
- **R-06:** Cada permiso se pide cuando se necesita, con una explicación previa de para qué sirve.
- **R-07:** La app funciona sin los permisos opcionales y ofrece una alternativa (por ejemplo, el código postal si se niega la ubicación).
- **R-08:** No se pide el permiso de contactos.

## 4. Criterios de aceptación
- **CA-01:** Dada una persona que inicia sesión, cuando acepta las notificaciones, entonces el identificador queda registrado.
- **CA-02:** Dado un cierre de sesión, cuando termina, entonces el identificador se desregistra.
- **CA-03:** Dada una notificación tocada, cuando se abre la app, entonces va a la pantalla destino.
- **CA-04:** Dado el permiso de ubicación negado, cuando se usa la función, entonces la app pide el código postal.
- **CA-05:** Dado un texto de notificación, cuando se revisa, entonces no contiene datos sensibles.

## 5. Contrato
Consume el endpoint de registro de dispositivos del backend y fija el formato de la carga de las notificaciones (tipo y destino).

## 6. Amenazas y controles
| Amenaza | Control |
|---|---|
| Información sensible en la pantalla de bloqueo | Los textos no incluyen códigos ni direcciones |
| Notificaciones de otra persona tras cambiar de cuenta | Desregistro del identificador al cerrar sesión |
| Pedir permisos de más | Solo los necesarios, pedidos al usarlos y sin permiso de contactos |

## 7. Plan de pruebas
| Tipo | ¿Aplica? | Motivo |
|---|---|---|
| Unitarias | Sí | Registro y desregistro del identificador |
| Widget / componente | Sí | Aviso previo y alternativa al negar un permiso |
| Integración | Sí | Apertura de la pantalla destino desde una notificación de prueba |
| Seguridad negativa | Sí | Cierre de sesión y datos sensibles en textos |
| Accesibilidad | Sí | Texto de los avisos de permisos |
| Arquitectura | No | Se cubre en la spec 001 |

## 8. Decisiones
- **Pedir permisos al usarlos:** la persona entiende para qué sirve cada uno y la app no se rompe si lo niega.
- **Sin permiso de contactos:** se usa el selector del sistema, que no lo necesita.

## 9. Riesgos y dudas abiertas
- **Nota (2026-11-12, spec 037):** el registro del dispositivo sigue contra `RegistroDispositivosSimulado` hasta que backend publique `POST /api/v1/dispositivos`. Backend 037 liga el registro al `sid` de la sesión, el último registro gana y se borra al cerrar sesión y al terminar la sesión por cualquier vía; esta spec ya desregistra al cerrar sesión (R-01) y no cambia su contrato.
- Las notificaciones dependen de un servicio de terceros (Firebase Cloud Messaging).
- Ninguna duda abierta por ahora; se agregan aquí las que surjan al revisar la spec.

## Nota de enmienda (2026-11-26, baja del dispositivo)

- **Estado de esta enmienda:** propuesta **SIN FIRMA**; vale desde que se firma la línea «Enmienda 2026-11-26 (rutas publicadas)» de la sección Aprobación. La aprobación original y las enmiendas ya firmadas se conservan.
- **Momento de redacción:** se redacta el 2026-11-26, **después** de que la ruta existe en el backend (contrato `docs/openapi.*.json` de `origin/develop` de knock-backend). La app registra hoy contra `RegistroDispositivosSimulado` (§9).
- **Contrato (backend 037, R-01 y R-02):** al cerrar sesión la app llama a `DELETE /api/v1/dispositivos/{id}` con el `id` que devolvió `POST /api/v1/dispositivos` (`201` la primera vez, `200` al repetir).

| Método y ruta | Respuesta | Errores que la app distingue |
|---|---|---|
| `DELETE /api/v1/dispositivos/{id}` | `204`, también si ya no existe | `401`, `429`, `503 devices_unavailable` |

- **CA-E01:** Dada una sesión con un dispositivo registrado, cuando la persona cierra sesión, entonces la app pide el borrado con ese `id` antes de descartar la sesión local. · Verificación: prueba unitaria del controlador de registro.
- El backend también borra el dispositivo cuando la sesión termina por cualquier vía (backend 037, R-02).
- **Decisión pendiente:** si el borrado falla (`401`, `429`, `503` o sin red), ¿se cierra la sesión local de todos modos? Propuesta: sí, sin reintento, por el borrado del servidor.
- **Decisión pendiente:** dónde se guarda el `id` entre arranques (esta spec no lo fija).

## Aprobación
- [x] Revisor 1 — nombre: José Julián Hernández Hernández fecha: 2026-11-04
- [x] Sin conflicto con la constitución
- [x] Enmienda 2026-11-26 (rutas publicadas) — nombre: Julián Hernández fecha: 2026-11-26
- **Estados:** Borrador → Aprobada (una persona; habilita el código) → Implementada (tras el merge)
