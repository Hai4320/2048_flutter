import 'package:flutter/material.dart';

class Tile{
  int x;
  int y;
  int val;

  late Animation<double> animationX;
  late Animation<double> animationY;
  late Animation<int> animationValue;
  late Animation<double> scale;

  Tile({required this.x, required this.y, required this.val}){
   resetAnimation();

  }
  void resetAnimation(){
    animationX = AlwaysStoppedAnimation(x.toDouble());
    animationY = AlwaysStoppedAnimation(y.toDouble());
    animationValue = AlwaysStoppedAnimation(val);
    scale = const AlwaysStoppedAnimation(1.0);
  }

   void moveTo(Animation<double> parent, int x, int y) {
    Animation<double> curved = CurvedAnimation(parent: parent, curve: const Interval(0.0, 0.5));
    animationX = Tween(begin: this.x.toDouble(), end: x.toDouble()).animate(curved);
    animationY = Tween(begin: this.y.toDouble(), end: y.toDouble()).animate(curved);
  }

  void bounce(Animation<double> parent) {
    scale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(parent: parent, curve: const Interval(0.5, 1)));
  }

  void changeNumber(Animation<double> parent, int newValue) {
    animationValue = TweenSequence([
      TweenSequenceItem(tween: ConstantTween(val), weight: .01),
      TweenSequenceItem(tween: ConstantTween(newValue), weight: .99),
    ]).animate(CurvedAnimation(parent: parent, curve: const Interval(0.5, 1.0)));
  }

  void appear(Animation<double> parent) {
    scale = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: parent, curve: const Interval(0.5, 1.0)));
  }

}