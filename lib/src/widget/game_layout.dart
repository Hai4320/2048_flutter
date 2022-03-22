import 'package:flutter/material.dart';
import 'package:game_2048_f/src/constant/colors.dart';
import 'package:game_2048_f/src/model/tile.dart';

class GameLayout extends StatefulWidget {
  const GameLayout({Key? key}) : super(key: key);

  @override
  State<GameLayout> createState() => _GameLayoutState();
}

class _GameLayoutState extends State<GameLayout> with TickerProviderStateMixin {
  late AnimationController animationController;
  List<List<Tile>> grid = List.generate(
      4, (y) => List.generate(4, (x) => Tile(x: x, y: y, val: 0)));

  Iterable<Tile> get flattenedGrid =>
      grid.expand((e) => e); // chuyen list nxn thanh list thang

  @override
  void initState() {
    super.initState();
    grid[1][2].val = 4;
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    flattenedGrid.forEach((e) => e.resetAnimation());
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var mainSize = (size.width <= size.height) ? size.width : size.height;
    var gridSize = mainSize - 16 * 2;
    var tileSize = (gridSize - 4 * 2) / 4;
    var radius = 8.0;
    List<Widget> stackItems = [];
    stackItems.addAll(flattenedGrid.map((e) => Positioned(
          left: e.x * tileSize,
          top: e.y * tileSize,
          width: tileSize,
          height: tileSize,
          child: Center(
              child: Container(
            width: tileSize - 4 * 2,
            height: tileSize - 4 * 2,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                color: AppColors.boxColor),
          )),
        )));
    stackItems.addAll(flattenedGrid.map((e) => AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return e.animationValue.value == 0
              ? const SizedBox()
              : Positioned(
                  left: e.x * tileSize,
                  top: e.y * tileSize,
                  width: tileSize,
                  height: tileSize,
                  child: Center(
                      child: Container(
                    width: tileSize - 4 * 2,
                    height: tileSize - 4 * 2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(radius),
                        color: AppColors.tileColors[e.val]),
                    child: Center(
                        child: Text(
                      e.val.toString(),
                      style: const TextStyle(fontSize: 20),
                    )),
                  )),
                );
        })));
    return Scaffold(
      body: Center(
        child: Container(
            width: gridSize,
            height: gridSize,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: AppColors.backColor,
                borderRadius: BorderRadius.circular(radius)),
            child: Stack(
              children: stackItems,
            )),
      ),
    );
  }
}
