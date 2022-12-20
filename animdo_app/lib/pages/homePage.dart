// import 'dart:js_util';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class homePage extends StatefulWidget {
  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage>
    with SingleTickerProviderStateMixin {
  double btnRadius = 100;
  final Tween<double> _pageScale = Tween<double>(begin: 0.0, end: 1.0);

  AnimationController? _starAnimController;

  @override
  void initState() {
    super.initState();
    _starAnimController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));

        _starAnimController!.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _pageBackground(),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _circleAimatedBtn(),
                starIcon(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _pageBackground() {
    return TweenAnimationBuilder(
      curve: Curves.easeInOutCubicEmphasized,
      tween: _pageScale,
      duration: const Duration(seconds: 1),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: Container(
        color: Colors.blue,
      ),
    );
  }

  Widget _circleAimatedBtn() {
    return Center(
      child: GestureDetector(
        onTap: () {
          setState(() {
            btnRadius += btnRadius == 200 ? -100 : 100;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(seconds: 2),
          curve: Curves.bounceInOut,
          height: btnRadius,
          width: btnRadius,
          decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.circular(btnRadius)),
          child: const Center(
              child: Text(
            'Basic!',
            style: TextStyle(color: Colors.white),
          )),
        ),
      ),
    );
  }

  Widget starIcon() {
    return AnimatedBuilder(
        animation: _starAnimController!.view,
        builder: (context, child) {
          return Transform.rotate(
            angle: _starAnimController!.value * 2 * pi,
            child: child,
          );
        },
        child: const Icon(
          Icons.star,
          size: 100,
          color: Colors.white,
        ));
  }
}
