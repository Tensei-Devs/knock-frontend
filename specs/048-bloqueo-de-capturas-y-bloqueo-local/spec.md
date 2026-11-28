# Spec 048 — Bloqueo de capturas en pantallas sensibles y bloqueo local opcional

> **Estado:** Borrador · **Repositorio:** knock-frontend · **Rector:** `constitution.md`
> **Claves de trabajo:** KNOCK-266 · **Sprint:** 5 · **Responsable:** por asignar
> **Otra parte en:** — (no cambia el servidor)
> **Fuentes:** specs 009, 012, 014 y 016 (R-18, D-05 y D-13) · [`local_auth`](https://pub.dev/packages/local_auth) y [`local_auth_android`](https://pub.dev/packages/local_auth_android) (consultados el 2026-11-28)
> **Skills:** `flutter-clean-architecture`, `testing-strategy-frontend`, `security-core`

## 1. Objetivo
Reducir que datos sensibles queden en capturas, grabaciones o en la vista de apps recientes, y permitir que quien lo quiera pida huella, rostro o el PIN del teléfono para abrir Knock.

## 2. Historia y casos de prueba
**Historia:** Como persona usuaria, quiero que mis datos sensibles no queden en capturas y poder cerrar Knock con el desbloqueo de mi teléfono, para protegerme si alguien más lo toma.

**Parte A — capturas**
- **CA-01:** Dada una pantalla sensible (§7), cuando se muestra en Android, entonces la ventana queda marcada como segura (`FLAG_SECURE`). · Verificación: prueba de widget con el canal simulado y comprobación manual en teléfono.
- **CA-02:** Dada una pantalla no sensible sin ninguna sensible debajo ni encima, entonces la ventana no está marcada. · Verificación: prueba de widget.
- **CA-03:** Dadas dos pantallas sensibles apiladas, un diálogo o una hoja sobre una de ellas, cuando se cierra lo de arriba, entonces la marca sigue; y se quita solo al salir de la última, también con el gesto de regresar o al cerrar sesión. · Verificación: prueba unitaria del contador y de widget.
- **CA-04:** Dado `--dart-define=BLOQUEO_CAPTURAS=false`, cuando se compila, entonces ninguna pantalla se marca; sin definirlo, el bloqueo está encendido. El flujo de publicación no lo apaga. · Verificación: prueba unitaria y revisión del flujo.
- **CA-05:** Dado iOS, web, una prueba o un fallo del canal, cuando se entra a una pantalla sensible, entonces funciona sin error. · Verificación: prueba unitaria.

**Parte B — bloqueo local**
- **CA-06:** Dada la app recién instalada, entonces el bloqueo local está apagado y la app no pide autenticación. · Verificación: prueba unitaria.
- **CA-07:** Dado un teléfono con huella, rostro, PIN, patrón o contraseña, cuando la persona enciende «Bloquear Knock» y se autentica, entonces queda encendido; si cancela o falla, sigue apagado. Apagarlo también pide autenticarse. · Verificación: prueba de widget con autenticador falso.
- **CA-08:** Dado el bloqueo encendido y una sesión abierta, cuando la app arranca o vuelve tras el tiempo de D-02 en segundo plano, entonces muestra la pantalla de bloqueo antes de pintar contenido y pide autenticación; hasta lograrla no se ve ninguna pantalla, ni al abrir un enlace o un aviso. · Verificación: pruebas de widget y de rutas.
- **CA-09:** Dado un fallo o una cancelación, entonces se queda en la pantalla de bloqueo con «Desbloquear» y «Cerrar sesión», sin pedir en bucle. · Verificación: prueba de widget.
- **CA-10:** Dado «Cerrar sesión» desde el bloqueo, entonces se borra la sesión y todo lo que borra el cierre de sesión normal, se apaga el bloqueo y se vuelve a la entrada. · Verificación: prueba de seguridad del cliente.
- **CA-11:** Dado un teléfono sin ningún desbloqueo configurado, cuando se abre el ajuste, entonces está deshabilitado con su explicación; y si la persona lo quita después de encender el bloqueo, la app no deja ver el contenido sin sesión nueva: ofrece «Cerrar sesión». · Verificación: prueba de widget.
- **CA-12:** Dado el bloqueo, cuando se revisan almacenamiento, registros y peticiones, entonces solo se guarda la preferencia en el almacén seguro; la app no recibe, guarda ni envía datos biométricos. · Verificación: prueba de seguridad del cliente.
- **CA-13:** Dados español e inglés, lector de pantalla y texto al 200 %, entonces la pantalla de bloqueo y el ajuste cumplen: textos del ARB y controles de 48 dp como mínimo. · Verificación: prueba de accesibilidad.

## 3. Alcance / No-alcance
**Dentro:** Android; marca segura en las pantallas de §7 y bloqueo local opcional.

**Fuera**
- Impedir que alguien fotografíe la pantalla con otro aparato.
- iOS, panel y landing.
- PIN propio de Knock, bloqueo obligatorio, cifrado adicional de datos y cualquier regla del servidor. El bloqueo local no sustituye la sesión.

## 4. Contrato API y eventos
No aplica: no hay rutas ni campos nuevos.

## 5. Modelo de datos local
Una preferencia `knock.bloqueo.activo` en el almacén seguro (spec 009). Se borra al cerrar sesión. El tiempo en segundo plano se calcula en memoria; si el sistema cerró la app, cuenta como arranque.

## 6. Seguridad, privacidad y amenazas
| Amenaza | Control | Caso |
|---|---|---|
| Datos sensibles en capturas, grabaciones o recientes | Ventana segura | CA-01 a CA-03 |
| Alguien toma el teléfono desbloqueado | Bloqueo local opcional | CA-07, CA-08 |
| Ver contenido por un enlace o un aviso saltando el bloqueo | El bloqueo está por encima de las rutas | CA-08 |
| La persona queda encerrada fuera de su cuenta | «Cerrar sesión» siempre disponible y entrada por SMS | CA-09 a CA-11 |
| Tratar datos biométricos | Los maneja el sistema; la app solo recibe sí o no | CA-12 |
| Un teléfono modificado salta estos controles | Riesgo aceptado: son controles del lado del cliente | — |

## 7. Pantallas, textos y accesibilidad
**Pantallas sensibles propuestas** (D-01): código de SMS en la entrada; visita con código del cliente y captura del código por el técnico; consentimiento, captura y revisión de la verificación de identidad; datos de la cuenta; direcciones.

| Situación | Español | Inglés |
|---|---|---|
| Ajuste | Bloquear Knock con el desbloqueo de tu teléfono | Lock Knock with your phone’s screen lock |
| Sin desbloqueo en el teléfono | Primero configura un PIN, patrón o huella en tu teléfono. | First set up a PIN, pattern or fingerprint on your phone. |
| Pantalla de bloqueo | Knock está bloqueado · Desbloquear · Cerrar sesión | Knock is locked · Unlock · Sign out |
| Motivo del diálogo | Confirma que eres tú para abrir Knock. | Confirm it’s you to open Knock. |

## 8. Pruebas, gates y límites
Unitarias, widget, seguridad del cliente, accesibilidad y recorrido manual en un teléfono físico (huella y PIN, regresar de segundo plano, captura rechazada y vista de recientes). Puertas: `flutter analyze`, `dart format`, `flutter test`, `sdd_lint --trace 048`, `codemap.py --check`.

**Límite para la demostración:** una pantalla marcada se ve en negro en grabaciones y al duplicar el teléfono en una computadora, y no admite capturas para evidencia. Para eso se usa una compilación con `BLOQUEO_CAPTURAS=false`, que nunca se publica.

## 9. Arquitectura y componentes
- **Capturas:** un método nuevo en el canal `knock/pantalla` de `MainActivity`, un puerto en `core/plataforma/` y un contador compartido por las pantallas sensibles. Sin dependencia nueva.
- **Bloqueo:** `local_auth` (BSD-3-Clause, editor flutter.dev; versión consultada 3.0.2) detrás de un puerto, con `biometricOnly` en falso para admitir el PIN del teléfono. Según su documentación, `MainActivity` pasa a `FlutterFragmentActivity` (conservando el canal), se declara `USE_BIOMETRIC` y el tema de arranque debe ser compatible con AppCompat para no fallar en Android 8 y anteriores. Antes de agregarla se revisan licencias transitivas, vulnerabilidades y mantenimiento y se registra en `Memoria.md`.

## 10. Dependencias con otras specs
- 009 (almacén seguro y cierre de sesión), 012 (permisos), 014 (diseño).
- **016:** su D-05 decidió **no** usar `FLAG_SECURE` para no romper capturas de soporte, y D-13 y R-18 dicen que las capturas manuales siguen permitidas. Aprobar esta spec cambia esa decisión y exige una enmienda de la 016, que firma una persona.
- El aviso de privacidad debe decir que la biometría la maneja el teléfono y no sale de él (spec 004, landing).
- Permiso nuevo: según la spec 011 vale 10 puntos de la app.

## 11. Definición de terminado
CA-01 a CA-13 con pruebas en verde, CI en verde, recorrido en teléfono, revisión de una persona y `Memoria.md` al día.

## 12. Decisiones pendientes de quien aprueba
- **D-01:** ¿Cambias la decisión D-05 de la spec 016? ¿La lista de §7 es la correcta? ¿Entra el chat? *Propuesta: sí al cambio, con esa lista y sin el chat.*
- **D-02:** Tiempo en segundo plano para volver a pedir. *Propuesta: 60 segundos, para no pedirlo al volver de la cámara o de compartir.*
- **D-03:** ¿Se hacen las dos partes o solo la A? La A no agrega dependencia ni permiso. *Propuesta: A primero y B en otro PR.*

## 13. Decisiones tomadas sin consulta, riesgos y dudas
- **Bloqueo opcional y apagado por omisión.** Alternativa: obligatorio.
- **Sin PIN propio:** usa el del teléfono, así Knock no guarda ningún PIN.
- **Riesgo:** el diálogo del sistema, la cámara y el selector pueden mandar la app a segundo plano; el recorrido en teléfono debe confirmar que no hay bucles.
- **Sin probar:** el comportamiento en el teléfono de pruebas con microG. `local_auth` se apoya en el desbloqueo de Android, pero hay que verlo ahí.
- **Estimación sin medir:** parte A, 2 a 3 horas; parte B, 4 a 6 horas. Sin contar CI ni revisión.

## Aprobación
- [ ] Revisor 1 — nombre: ________ fecha: ________
- [ ] Sin conflicto con la constitución
- **Estados:** Borrador → Aprobada (una persona; habilita el código) → Implementada (tras el merge)
