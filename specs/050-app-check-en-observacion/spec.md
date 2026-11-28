# Spec 050 — App Check en la app, en modo de observación

> **Estado:** Borrador · **Repositorio:** knock-frontend · **Rector:** `constitution.md`
> **Claves de trabajo:** KNOCK-266 · **Sprint:** 5 · **Responsable:** por asignar
> **Otra parte en:** knock-backend, spec 065 (la puerta de entrada observa y no rechaza)
> **Fuentes (consultadas el 2026-11-28):** [App Check en Flutter](https://firebase.google.com/docs/app-check/flutter/default-providers) · [`firebase_app_check`](https://pub.dev/packages/firebase_app_check) · specs 002, 009 y 026
> **Skills:** `flutter-clean-architecture`, `api-client-contract`, `testing-strategy-frontend`, `security-core`

## 1. Objetivo
Que la app pueda enviar a la API de Knock la prueba de App Check (en Android, con Play Integrity) para que el servidor la mida, **sin que ninguna función dependa de conseguirla**.

## 2. Historia y casos de prueba
**Historia:** Como equipo de Knock, queremos que la app mande su comprobación cuando pueda, para medir antes de exigir.

- **CA-01:** Dado `KNOCK_APP_CHECK` sin definir, entonces App Check no se activa, no se pide ningún token y ninguna petición lleva el encabezado. · Verificación: prueba unitaria.
- **CA-02:** Dado el interruptor encendido y un token disponible, cuando sale una petición a la URL base de la API, entonces lleva `X-Firebase-AppCheck`. · Verificación: prueba unitaria del transporte.
- **CA-03:** Dada una petición a cualquier otro destino (otro anfitrión, esquema o puerto), entonces no lleva el encabezado. · Verificación: prueba de seguridad del cliente.
- **CA-04:** Dado que el token no se consigue (sin servicios de Google, sin red, error del proveedor o sin configuración de Firebase), entonces la petición sale sin el encabezado y la función sigue igual, sin mensajes a la persona. · Verificación: pruebas unitarias.
- **CA-05:** Dado un proveedor que tarda, entonces cada petición espera como máximo 2 segundos; tras un fallo no se vuelve a pedir el token en 5 minutos, y las peticiones de ese lapso salen sin espera. · Verificación: prueba unitaria con reloj falso.
- **CA-06:** Dada una compilación de publicación, entonces usa Play Integrity; el proveedor de depuración solo puede activarse en compilaciones de depuración. Ningún token de depuración está en el repositorio ni en el CI. · Verificación: prueba unitaria y búsqueda de secretos del CI.
- **CA-07:** Dados registros, caché, almacenamiento de la app y reportes de errores, entonces no aparece el token. · Verificación: prueba de seguridad del cliente.
- **CA-08:** Dado el teléfono con microG y el interruptor encendido, cuando se entra con SMS y se recorre la app, entonces todo funciona igual que apagado; se anota si se consiguió el token. · Verificación: recorrido manual con fecha.

## 3. Alcance / No-alcance
**Dentro:** Android; peticiones HTTP a la API de Knock hechas con el transporte común.

**Fuera**
- Exigir la comprobación y activar «Aplicar» en la consola de Firebase para **cualquier** producto, **incluido Authentication**: podría impedir la entrada por SMS a teléfonos que no consiguen la comprobación.
- El canal `/hubs/chat`, iOS, panel y landing.
- Tokens de un solo uso.

## 4. Contrato API y eventos
Encabezado opcional `X-Firebase-AppCheck` en las peticiones a la API. No cambia ningún cuerpo ni respuesta.

## 5. Modelo de datos local
La app no guarda el token por su cuenta; la renovación y la caché las maneja la biblioteca de Firebase.

## 6. Seguridad, privacidad y amenazas
| Amenaza | Control | Caso |
|---|---|---|
| El token sale hacia un tercero | Solo hacia la URL base de la API | CA-03 |
| Una falla de Google deja la app sin funcionar | Falla abierta, con tope de espera y pausa | CA-04, CA-05 |
| Un token de depuración filtrado | Solo en depuración y fuera del repositorio | CA-06 |
| El token en registros | No se registra | CA-07 |
| Dejar fuera a un teléfono sin certificación | Nada se exige; se prueba en el de microG | CA-04, CA-08 |

## 7. Pantallas, textos y accesibilidad
Sin pantallas ni textos nuevos en la app.

## 8. Pruebas, gates y límites
Unitarias, seguridad del cliente y recorrido manual. El CI no pide tokens reales. Puertas: `flutter analyze`, `dart format`, `flutter test`, `sdd_lint --trace 050`, `codemap.py --check`.

## 9. Arquitectura y componentes
Un puerto `ProveedorDeAppCheck` en `core/` y su implementación con `firebase_app_check` (BSD-3-Clause; versión consultada 0.5.2, que pide `firebase_core` 5.1.0 o compatible, la que ya usa la app). El encabezado se agrega en el transporte común hacia la API. Antes de agregar la dependencia se revisan sus paquetes transitivos, licencias y vulnerabilidades y se registra en `Memoria.md`.

## 10. Dependencias con otras specs
- Backend 065. La app puede publicarse antes o después: sin él, el encabezado se ignora.
- **Configuración manual del líder:** registrar la app en App Check, vincular Play Integrity con el proyecto de Google Play y registrar las huellas SHA-256 que correspondan (la de la firma de Play para lo publicado). La documentación indica además que en ciertos teléfonos hay que habilitar el veredicto de integridad básica en Google Play Console.
- El aviso de privacidad debe mencionar la comprobación de integridad con Google (spec 004, landing).
- Según la spec 011, una integración externa nueva vale 10 puntos de la app.

## 11. Definición de terminado
CA-01 a CA-07 con pruebas en verde, CA-08 anotado, CI en verde, revisión de una persona y `Memoria.md` al día. Con el interruptor apagado no se puede decir que App Check está activo.

## 12. Decisiones pendientes de quien aprueba
- **D-01:** ¿Se acepta la dependencia y la configuración en Firebase y Google Play? Si el CI no reconoce la licencia de los paquetes nuevos, habrá que ampliar la excepción de licencias, que es un archivo protegido y necesita autorización.
- **D-02:** ¿La compilación publicada lleva el interruptor encendido? *Propuesta: solo después de pasar CA-08 y de actualizar el aviso de privacidad.*

## 13. Decisiones tomadas sin consulta, riesgos y dudas
- **Falla abierta con tope y pausa.** Alternativa: no esperar nunca y mandar el token solo si ya está en caché.
- **Sin el canal en vivo**, porque el servidor no lo observa.
- **Sin probar:** que el teléfono con microG consiga token. Play Integrity pide dispositivo certificado para sus veredictos altos, así que es probable que no. Tampoco está probado que instalarlo deje igual la entrada por SMS: por eso CA-08.
- Una app instalada fuera de Google Play puede no obtener un veredicto válido.
- **Estimación sin medir:** 3 a 5 horas de app y pruebas, más 1 a 2 horas de configuración y recorrido.

## Aprobación
- [ ] Revisor 1 — nombre: ________ fecha: ________
- [ ] Sin conflicto con la constitución
- **Estados:** Borrador → Aprobada (una persona; habilita el código) → Implementada (tras el merge)
