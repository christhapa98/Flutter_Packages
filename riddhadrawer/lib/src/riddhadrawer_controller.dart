import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';

class RiddhaDrawerController {
  //initiliazing animation controller
  _initAnimationController({vsync}) {
    return AnimationController(
        animationBehavior: AnimationBehavior.preserve,
        vsync: vsync,
        duration: const Duration(milliseconds: 250));
  }

  Function get initAnimationController => _initAnimationController();
}
