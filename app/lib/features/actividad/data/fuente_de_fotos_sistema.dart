import 'package:app/features/actividad/domain/solicitud_repository.dart';
import 'package:image_picker/image_picker.dart';

/// Cámara y selector de fotos del sistema (spec 015, R-03 y D-12).
///
/// `image_picker` los abre por intención: la app no declara `CAMERA` ni
/// permisos de almacenamiento y no guarda nada en la galería. La reducción y
/// el borrado de EXIF los hace `BorradorRepository.agregarFoto`.
class FuenteDeFotosSistema implements FuenteDeFotos {
  FuenteDeFotosSistema([ImagePicker? selector])
    : _selector = selector ?? ImagePicker();

  final ImagePicker _selector;

  @override
  Future<List<int>?> tomarConCamara() async {
    final foto = await _selector.pickImage(source: ImageSource.camera);
    return foto?.readAsBytes();
  }

  @override
  Future<List<List<int>>> elegirDeGaleria(int maximo) async {
    if (maximo <= 0) return const [];
    final fotos = maximo == 1
        ? [?await _selector.pickImage(source: ImageSource.gallery)]
        : await _selector.pickMultiImage(limit: maximo);
    return [for (final foto in fotos.take(maximo)) await foto.readAsBytes()];
  }
}
