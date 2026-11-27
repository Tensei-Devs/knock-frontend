// Lo que la función Entrada ofrece a otras funciones: las reglas del celular y
// del código de 6 dígitos (spec 045: la entrada de la maqueta las reutiliza en
// vez de repetirlas).
export 'package:app/features/entrada/domain/validacion_entrada.dart'
    show
        digitosDeCelular,
        digitosDeCodigo,
        esCelularValido,
        esCodigoValido,
        formatearCelular;

// La apelación de una cuenta suspendida (spec 033) reutiliza el marco y los
// mensajes de la entrada.
export 'package:app/features/entrada/presentation/mensaje_de_error.dart';
export 'package:app/features/entrada/presentation/widgets/marco_de_entrada.dart';
export 'package:app/features/entrada/presentation/widgets/pie_de_codigo.dart';
