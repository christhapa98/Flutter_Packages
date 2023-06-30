// ignore_for_file: must_be_immutable

library riddhadrawer;

import 'package:flutter/material.dart';
import 'package:riddhadrawer/src/riddhadrawer_controller.dart';

class RiddhaDrawer extends StatefulWidget {
  RiddhaDrawer(
      {Key? key,
      required this.child,
      required this.drawer,
      this.roundedChild,
      this.drawerWidth})
      : super(key: key);
  Widget child;
  Widget drawer;
  bool? roundedChild;
  double? drawerWidth;

  @override
  State<RiddhaDrawer> createState() => _RiddhaDrawerState();
}

class _RiddhaDrawerState extends State<RiddhaDrawer>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController =
        RiddhaDrawerController().initAnimationController(vsync: this);
    super.initState();
  }

  _onDrawerOpenClose() {
    _animationController.isDismissed
        ? _animationController.forward()
        : _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, _) {
          var slide = widget.drawerWidth ?? 225.0 * _animationController.value;
          var scale = 1 - (_animationController.value * 0.3);
          return Stack(children: [
            Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: 1.0,
                child: ScaleTransition(
                  scale: Tween<double>(
                    begin: 0.75,
                    end: 1.0,
                  ).animate(_animationController),
                  alignment: Alignment.centerRight,
                  child: widget.drawer,
                ),
              ),
            ),
            _renderedChild(slide: slide, scale: scale)
          ]);
        });
  }

  Transform _renderedChild({double? slide, double? scale}) {
    // _openOnSlide(details) {
    //   if (details.globalPosition.dx > 0) {
    //     _onDrawerOpenClose();
    //   }
    // }

    return Transform(
        origin: const Offset(0.5, 1.0),
        filterQuality: FilterQuality.high,
        transform: Matrix4.identity()
          ..translate(slide)
          ..scale(1.0),
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          // onHorizontalDragStart: (details) {
          //   _openOnSlide(details);
          // },
          child: Scaffold(
            body: ClipRRect(
              borderRadius: widget.roundedChild == true
                  ? BorderRadius.all(_animationController.isDismissed
                      ? const Radius.circular(50.0)
                      : const Radius.circular(0.0))
                  : null,
              child: widget.child,
            ),
          ),
        ));
  }

  //Getter Methodss
  Function get openCloseDrawer => _onDrawerOpenClose();
  AnimationController get animationController => _animationController;
}
