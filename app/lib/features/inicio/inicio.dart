// Lo que la función Inicio ofrece a otras funciones: el resultado y el contrato
// de la ubicación del teléfono (spec 045: el mapa y la entrada de la maqueta
// los reutilizan en vez de repetirlos) y el resultado de la colonia de un punto.
export 'package:app/features/inicio/domain/ubicacion_repository.dart'
    show
        Concedida,
        Denegada,
        DenegadaParaSiempre,
        ResultadoUbicacion,
        ServicioDesactivado,
        UbicacionRepository;

export 'package:app/features/inicio/domain/colonia.dart'
    show Colonia, ResultadoColonia;
