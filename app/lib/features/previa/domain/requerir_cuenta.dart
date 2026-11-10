import 'package:app/core/router/rutas.dart';

/// Único punto para las acciones que necesitan cuenta (spec 027, R-08):
/// llevar a `/entrar` con el destino al que volver.
///
/// [navegar] hace el cambio de ruta (en la pantalla, `context.go`). El
/// [destino] se valida: si no es una ruta interna permitida se ignora y, tras
/// entrar, la persona llega a Inicio.
void requerirCuenta({
  String? destino,
  required void Function(String ruta) navegar,
}) => navegar(rutaDeEntrada(destino));
