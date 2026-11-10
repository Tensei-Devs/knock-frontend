import 'package:app/features/cuenta/domain/perfil.dart';
import 'package:flutter/material.dart';

/// Avatar con las iniciales del nombre (HU-002: sin foto se usan iniciales).
class AvatarIniciales extends StatelessWidget {
  const AvatarIniciales({required this.perfil, this.radio = 28, super.key});

  final Perfil perfil;
  final double radio;

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Avatar de ${perfil.nombre}',
    excludeSemantics: true,
    child: CircleAvatar(
      radius: radio,
      child: Text(perfil.iniciales, style: TextStyle(fontSize: radio * 0.7)),
    ),
  );
}
