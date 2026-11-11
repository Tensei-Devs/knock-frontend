// Lo que la feature `oficios` ofrece a otras features (spec 027, §7, y spec
// 015): el tipo `Oficio` del catálogo, su `Modalidad` y el repositorio que
// lista el catálogo. Otras features importan este archivo y no
// `oficios/domain/` ni `oficios/data/`.
export 'package:app/features/oficios/domain/modalidad.dart' show Modalidad;
export 'package:app/features/oficios/domain/oficio.dart' show Oficio;
export 'package:app/features/oficios/domain/oficios_repository.dart'
    show OficiosRepository;
export 'package:app/features/oficios/oficios_providers.dart'
    show oficiosRepositoryProvider;
