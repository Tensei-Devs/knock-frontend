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
