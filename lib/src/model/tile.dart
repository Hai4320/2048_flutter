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
  resetAnimation(){
    animationX = AlwaysStoppedAnimation(x.toDouble());
    animationY = AlwaysStoppedAnimation(y.toDouble());
    animationValue = AlwaysStoppedAnimation(val);
    scale = const AlwaysStoppedAnimation(1.0);
  }
}