import 'package:app/features/previa/domain/vista_mapa.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/painting.dart' show Size;

/// Estado del mapa de la previa: la [vista] actual y las acciones de los
/// botones acercar, alejar y «volver a mi ubicación» (spec 027, R-18).
class ControladorMapa {
  /// `null` hasta que el mapa conoce su tamaño.
  final vista = ValueNotifier<VistaMapa?>(null);

  Size _caja = Size.zero;

  /// Tamaño visible del mapa.
  Size get caja => _caja;

  /// El mapa avisa su tamaño en cada medición. La primera vez fija la vista
  /// inicial; si cambia (por ejemplo al girar el teléfono) la acota después
  /// del cuadro, sin tocar el árbol mientras se mide.
  void ajustarCaja(Size nueva) {
    if (nueva == _caja) return;
    final primera = vista.value == null;
    _caja = nueva;
    if (primera) {
      vista.value = VistaMapa.inicial(nueva.width, nueva.height);
      return;
    }
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final v = vista.value;
      if (v != null && _caja == nueva) {
        vista.value = v.acotada(nueva.width, nueva.height);
      }
    });
  }

  void acercar() => _zoom(VistaMapa.pasoDeZoom);

  void alejar() => _zoom(1 / VistaMapa.pasoDeZoom);

  void _zoom(double factor) {
    final v = vista.value;
    if (v == null) return;
    vista.value = v.zoomEn(
      factor,
      _caja.width / 2,
      _caja.height * .34,
      _caja.width,
      _caja.height,
    );
  }

  /// Vuelve a la vista inicial (el punto «Tú estás aquí» de ejemplo).
  void ubicarme() {
    if (vista.value == null) return;
    vista.value = VistaMapa.inicial(_caja.width, _caja.height);
  }

  /// Arrastra y hace zoom con los gestos del dedo.
  void gesto({
    required double dx,
    required double dy,
    double factor = 1,
    double fx = 0,
    double fy = 0,
  }) {
    var v = vista.value;
    if (v == null) return;
    v = v.desplazada(dx, dy, _caja.width, _caja.height);
    if (factor != 1) {
      v = v.zoomEn(factor, fx, fy, _caja.width, _caja.height);
    }
    vista.value = v;
  }

  void dispose() => vista.dispose();
}
