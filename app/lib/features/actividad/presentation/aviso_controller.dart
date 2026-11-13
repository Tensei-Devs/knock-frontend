import 'package:app/core/errores/failure.dart';
import 'package:app/features/actividad/actividad_providers.dart';
import 'package:app/features/actividad/domain/aviso.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Qué texto se puede enviar (spec 022, CA-01 y CA-16).
@immutable
sealed class TextoDeAviso {
  const TextoDeAviso();
}

/// El texto del servidor, tal cual (R-04).
final class AvisoDelServidor extends TextoDeAviso {
  const AvisoDelServidor(this.texto);

  final String texto;
}

/// Sin conexión o con error: el respaldo local, armado solo con
/// [DatosAvisoLocal] (R-12). La pantalla avisa que no se registró.
final class AvisoDeRespaldo extends TextoDeAviso {
  const AvisoDeRespaldo(this.datos);

  final DatosAvisoLocal datos;
}

/// 409 `visit_not_notifiable` (`AvisoNoPermitidoFailure`): no se abre ningún
/// canal.
final class AvisoNoPermitido extends TextoDeAviso {
  const AvisoNoPermitido();
}

/// Ni texto del servidor ni copia vigente.
final class AvisoSinDatos extends TextoDeAviso {
  const AvisoSinDatos(this.falla);

  final Failure falla;
}

/// Pide el texto **una vez** al abrir la hoja (R-07). Si el servidor dice
/// traer código o dirección, el texto no se usa (CA-15).
final textoDeAvisoProvider = FutureProvider.autoDispose
    .family<TextoDeAviso, String>((ref, visitaId) async {
      Failure falla;
      try {
        final mensaje = await ref
            .read(avisoRepositoryProvider)
            .pedirAviso(visitaId);
        // Defensa extra: aunque diga que no, se revisa contra el código de la
        // copia local de la visita (R-06).
        final codigo =
            (await ref.read(visitaLocalRepositoryProvider).leer(visitaId))
                ?.codigo;
        final traeCodigo =
            codigo != null && textoContieneCodigo(mensaje.texto, codigo);
        if (mensaje.esSeguro && !traeCodigo) {
          return AvisoDelServidor(mensaje.texto);
        }
        falla = const DatosInvalidosFailure();
      } on AvisoNoPermitidoFailure {
        // Solo `visit_not_notifiable` bloquea el aviso; otro 409 cae en el
        // respaldo con su advertencia (CA-16).
        return const AvisoNoPermitido();
      } on Failure catch (error) {
        falla = error;
      }
      final datos = await ref
          .read(respaldoAvisoRepositoryProvider)
          .leer(visitaId);
      if (datos != null && datos.vigente(ref.read(relojSolicitudProvider)())) {
        return AvisoDeRespaldo(datos);
      }
      return AvisoSinDatos(falla);
    });

/// Los contactos de confianza del teléfono, con alta, edición y baja
/// (spec 022, CA-04 a CA-08).
class ContactosController extends AsyncNotifier<List<ContactoConfianza>> {
  @override
  Future<List<ContactoConfianza>> build() =>
      ref.read(contactosConfianzaRepositoryProvider).listar();

  /// Guarda o reemplaza; devuelve el error si no se puede (no lanza).
  Future<ErrorContacto?> guardar({
    required String nombre,
    required String celular,
    String? id,
  }) async {
    final actuales = state.value ?? await future;
    final error = puedeGuardarse(
      actuales,
      nombre: nombre,
      celular: celular,
      idEditado: id,
    );
    if (error != null) return error;
    try {
      await ref
          .read(contactosConfianzaRepositoryProvider)
          .guardar(
            ContactoConfianza(
              id:
                  id ??
                  ref
                      .read(relojSolicitudProvider)()
                      .microsecondsSinceEpoch
                      .toString(),
              nombre: nombre,
              celular: celular,
            ),
          );
    } on ContactoNoGuardado catch (rechazo) {
      return rechazo.error;
    }
    state = AsyncData(
      await ref.read(contactosConfianzaRepositoryProvider).listar(),
    );
    return null;
  }

  Future<void> borrar(String id) async {
    await ref.read(contactosConfianzaRepositoryProvider).borrar(id);
    state = AsyncData(
      await ref.read(contactosConfianzaRepositoryProvider).listar(),
    );
  }
}

final contactosProvider =
    AsyncNotifierProvider<ContactosController, List<ContactoConfianza>>(
      ContactosController.new,
    );
