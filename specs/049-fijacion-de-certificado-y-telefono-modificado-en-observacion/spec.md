# Spec 049 — Fijación de certificado y señales de teléfono o app modificados, solo en observación

> **Estado:** Borrador · **Repositorio:** knock-frontend · **Rector:** `constitution.md`
> **Claves de trabajo:** KNOCK-266 · **Sprint:** 5 · **Responsable:** por asignar
> **Otra parte en:** — (no cambia el servidor)
> **Fuentes (consultadas el 2026-11-28):** [autoridades certificadoras de Azure](https://learn.microsoft.com/en-us/azure/security/fundamentals/azure-certificate-authority-details) · [cambios del TLS administrado de Azure](https://learn.microsoft.com/en-us/azure/security/fundamentals/managed-tls-changes) · [`SecurityContext` de Dart](https://api.dart.dev/dart-io/SecurityContext/SecurityContext.html) · specs 009 y 047
> **Skills:** `flutter-clean-architecture`, `testing-strategy-frontend`, `security-core`

## 1. Objetivo
Aprender, **sin cortar la conexión ni bloquear a nadie**, dos cosas: si una futura fijación de certificado dejaría sin conexión a la app, y qué señales de teléfono o app modificados aparecen en los teléfonos de prueba.

### Riesgos que mandan en el diseño
- **La conexión puede romperse.** El certificado del servidor lo administra Azure y puede cambiar de certificado, de autoridad intermedia o de raíz sin que Knock lo decida. Azure está migrando raíces de su TLS administrado y su documentación advierte que la fijación estática se desaconseja por el riesgo operativo. Una app ya instalada con un juego de raíces viejo quedaría sin conexión **hasta que la persona actualice**, y no se podría corregir enviándole una orden por esa misma conexión.
- **El teléfono de pruebas usa microG** y puede tener un sistema o arranque no certificados. Es esperable que alguna señal salga positiva ahí. Bloquear por esas señales podría dejar sin app al teléfono con el que se demuestra el proyecto.

## 2. Historia y casos de prueba
**Historia:** Como equipo de Knock, queremos medir antes de exigir, para no dejar sin servicio a personas legítimas.

**Parte A — certificado**
- **CA-01:** Dado el interruptor `KNOCK_OBSERVAR_TLS` sin definir, entonces no hay comprobación, conexiones extra ni datos guardados. · Verificación: prueba unitaria.
- **CA-02:** Dado el interruptor encendido y una dirección `https` de la API, cuando arranca la app, entonces como máximo una vez cada 24 horas abre **una conexión aparte** al puerto de la API que solo confía en las raíces del juego, la cierra sin enviar datos y guarda `coincide`, `no_coincide` o `sin_dato`. · Verificación: prueba unitaria con un conector falso.
- **CA-03:** Dado un servidor de prueba cuya cadena no llega a ninguna raíz del juego, pero que el teléfono acepta, entonces el resultado es `no_coincide`; dado un fallo de red, de DNS, de tiempo (5 segundos) o un certificado que tampoco la comprobación normal acepta, es `sin_dato`. · Verificación: pruebas unitarias.
- **CA-04:** Dado cualquier resultado o excepción de la comprobación, entonces las peticiones, el canal en vivo y las imágenes se comportan igual que sin ella, y el arranque no la espera. · Verificación: prueba de seguridad del cliente.
- **CA-05:** Dado el código, cuando se revisa, entonces ningún camino usa el resultado para rechazar una conexión ni acepta certificados inválidos (spec 009, R-03). · Verificación: prueba de arquitectura.
- **CA-06:** Dado el juego de raíces, cuando se prueba, entonces cada certificado coincide con la huella registrada con su fuente, hay raíces de al menos dos autoridades distintas, ninguna es hoja ni intermedia y ninguna está vencida. · Verificación: prueba unitaria.

**Parte B — teléfono o app modificados**
- **CA-07:** Dado el interruptor `KNOCK_OBSERVAR_DISPOSITIVO` sin definir, entonces no se recoge nada. · Verificación: prueba unitaria.
- **CA-08:** Dado el interruptor encendido en Android, entonces calcula las señales `claves_de_prueba`, `binario_su`, `app_depurable`, `firma_distinta` e `instalador`; cada una vale `si`, `no` o `sin_dato` (`instalador` informa una categoría: tienda, otro o sin dato). · Verificación: pruebas unitarias con el canal simulado y recorrido en teléfono.
- **CA-09:** Dada cualquier combinación de señales o un fallo del canal, entonces ninguna función cambia, no se cierra la sesión y no se muestra un bloqueo ni una advertencia. · Verificación: prueba de widget.

**Comunes**
- **CA-10:** Dados los datos guardados y los registros, cuando se inspeccionan, entonces solo contienen resultados, fecha y versión de la app; ningún identificador del teléfono, certificado completo, lista de apps, ruta de archivos, dirección IP ni token. Nada se envía fuera del teléfono. · Verificación: prueba de seguridad del cliente.
- **CA-11:** Dada una compilación de diagnóstico (`KNOCK_DIAGNOSTICO=true`), entonces una pantalla muestra los últimos resultados para anotarlos; sin ella no existe la ruta. · Verificación: prueba de widget y de rutas.

## 3. Alcance / No-alcance
**Dentro:** Android; la dirección de la API de Knock; observación local en teléfonos de prueba.

**Fuera**
- **Exigir** la fijación o bloquear por señales. Requieren otra spec o una enmienda firmada.
- Fijar Firebase, mapas, imágenes u otros servicios de terceros.
- Enviar resultados a un servidor, paneles y alertas.
- Servicios o bibliotecas de terceros que envíen datos del teléfono a su proveedor.

## 4. Contrato API y eventos
No aplica. La comprobación no llama a ninguna ruta: solo establece y cierra la conexión TLS.

## 5. Modelo de datos local
`knock.observacion` en preferencias: último resultado de cada parte, fecha y versión de la app. No es sensible y no se usa para decidir nada.

## 6. Seguridad, privacidad y amenazas
| Amenaza | Control | Caso |
|---|---|---|
| La observación corta la conexión | Conexión aparte; el resultado no se usa para decidir | CA-04, CA-05 |
| Dar por bueno un certificado inválido | No se usa ninguna excepción de certificados | CA-05 |
| Juego de raíces mal armado | Huellas, fuente y dos autoridades | CA-06 |
| Un teléfono legítimo queda bloqueado | Las señales no cambian nada | CA-09 |
| Recoger datos del teléfono | Solo resultados y todo local | CA-10 |
| Creer que las señales protegen | Son heurísticas que una persona con control del teléfono puede evadir; se escribe como límite | — |

## 7. Pantallas, textos y accesibilidad
Solo la pantalla de diagnóstico, que no existe en la app publicada.

## 8. Pruebas, gates y límites
Unitarias, seguridad del cliente, arquitectura y recorrido en teléfono. Las pruebas usan certificados de prueba propios, nunca el servidor real. Puertas: `flutter analyze`, `dart format`, `flutter test`, `sdd_lint --trace 049`, `codemap.py --check`.

## 9. Arquitectura y componentes
- **Certificado:** en `core/red/`, una comprobación con `SecureSocket` y un `SecurityContext` sin raíces del sistema, cargado con el juego de la app. Sin dependencia nueva. Se parte de que las conexiones de Dart no aplican la configuración de seguridad de red de Android, así que fijar solo ahí no bastaría; T-01 lo confirma.
- **Juego candidato**, tomado de la lista oficial de Azure y por confirmar en T-01: DigiCert Global Root G2 y G3, DigiCert TLS RSA 4096 y ECC P384 Root G5, Microsoft RSA y ECC Root Certificate Authority 2017, y Microsoft TLS RSA y ECC Root G2. **No** se fijan hojas ni intermedias. DigiCert Global Root CA no entra: la fuente indica que los certificados administrados migran fuera de ella.
- T-01 anota la cadena que el entorno entrega ese día y comprueba que el juego la cubre. Esa observación puntual no garantiza cadenas futuras.
- **Señales:** un método en el canal nativo de `MainActivity`, sin dependencia nueva. La firma esperada llega por `--dart-define`; con la firma de aplicaciones de Google Play es la del certificado de Play, no la de la llave de subida. Sin ese valor, `firma_distinta` es `sin_dato`.

### Condiciones mínimas para proponer exigir la fijación (no se implementan aquí)
1. Resultados `coincide` durante el periodo acordado, en varias redes y con al menos una renovación del certificado observada o una revisión fechada de los anuncios de Azure.
2. Interruptor de compilación apagado por omisión y reversión probada.
3. **Fecha de caducidad** dentro de la app: pasada esa fecha vuelve a la validación normal del sistema.
4. Cubrir el canal en vivo, o escribir que queda fuera.
5. Prueba negativa en teléfono y revisión de la lista oficial antes de cada publicación, con una persona responsable.

## 10. Dependencias con otras specs
009 (solo HTTPS y certificados válidos, que no cambia) y 047 (canal en vivo).

## 11. Definición de terminado
CA-01 a CA-11 con pruebas en verde, CI en verde, revisión de una persona, recorrido en un teléfono con microG y, si hay, en uno con servicios de Google, resultados anotados con fecha y `Memoria.md` al día. Esto **no** cuenta como fijación de certificado activa ni como detección que proteja.

## 12. Decisiones pendientes de quien aprueba
- **D-01:** ¿Se acepta que el entregable sea solo observación? *Propuesta: sí.* Si el profesor exige fijación activa, hace falta otra spec y aceptar por escrito el riesgo de conexión.
- **D-02:** ¿Se hacen las dos partes? *Propuesta: sí, en dos PR; primero la A.*
- **D-03:** ¿Se muestra alguna advertencia a la persona por señales positivas? *Propuesta: no mientras no se conozcan los falsos positivos.*
- **D-04:** ¿La compilación publicada lleva encendidos los interruptores? Sin envío al servidor, en un teléfono ajeno el equipo no vería nada. *Propuesta: apagados al publicar; encendidos solo en compilaciones de prueba.*

## 13. Decisiones tomadas sin consulta, riesgos y dudas
- **Conexión aparte** en vez de observar la conexión real: así un error de la comprobación no toca el servicio. Límite: puede no pasar por el mismo servidor que la petición real.
- **Sin dependencia de detección.** Alternativa: una biblioteca de terceros, que exige revisar licencia y qué datos envía.
- **Sin probar:** que la comprobación se comporte igual en todas las versiones de Android y en el teléfono con microG.
- **Estimación sin medir:** parte A, 3 a 4 horas; parte B, 3 a 4 horas; recorrido y anotación, 1 hora. Exigir la fijación no está estimado como parte de esta spec.

## Aprobación
- [ ] Revisor 1 — nombre: ________ fecha: ________
- [ ] Sin conflicto con la constitución
- **Estados:** Borrador → Aprobada (una persona; habilita el código) → Implementada (tras el merge)
