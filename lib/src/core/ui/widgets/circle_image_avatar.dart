import 'package:barbershop_schedule/src/core/constants/constants.dart';
import 'package:flutter/material.dart';

class CircleImageAvatar extends StatelessWidget {
  final String? image;
  final double size;
  const CircleImageAvatar({super.key, this.image, required this.size});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size,
      backgroundColor: Colors.transparent,
      backgroundImage: image != null
          ? NetworkImage(image!)
          : const AssetImage(AssetsImage.perfilTransparente)
              as ImageProvider<Object>,
    );
  }
}
