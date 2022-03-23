import 'package:flutter/material.dart';
import 'package:game_2048_f/src/constant/colors.dart';
import 'package:game_2048_f/src/constant/swipe.dart';
import 'package:game_2048_f/src/model/tile.dart';
import 'package:collection/collection.dart';

class GameLayout extends StatefulWidget {
  const GameLayout({Key? key}) : super(key: key);

  @override
  State<GameLayout> createState() => _GameLayoutState();
}

class _GameLayoutState extends State<GameLayout> with TickerProviderStateMixin {
  late AnimationController animationController;
  List<List<Tile>> grid = List.generate(
      4, (y) => List.generate(4, (x) => Tile(x: x, y: y, val: 0)));
  List<Tile> toAdd = [];
  Iterable<Tile> get flattenedGrid =>
      grid.expand((e) => e); // chuyen list nxn thanh list thang
  Iterable<List<Tile>> get gridCol => List.generate(4, (x) => List.generate(4, (y) => grid[y][x]));


  _doSwipe(void Function() swipeFunc){
    
    setState(() {
      swipeFunc();
      _addNewTile();
      animationController.forward(from: 0); 
    });

  }
  _addNewTile(){
    List<Tile> empty = flattenedGrid.where((e) => e.val==0).toList();
    empty.shuffle();
    toAdd.add(Tile(x: empty.first.x, y: empty.first.y, val: 2)..appear(animationController));
  }


  @override
  void initState() {
    super.initState();
    grid[1][2].val = 4;
    grid[3][1].val = 2;
    grid[3][2].val = 2;
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed){
        toAdd.forEach((e) {grid[e.y][e.x].val = e.val;});
        flattenedGrid.forEach((element) {
          element.resetAnimation();
        });
        toAdd.clear();
      }
    });
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
    stackItems.addAll([flattenedGrid, toAdd].expand((e)=> e).map((e) => AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return e.animationValue.value == 0
              ? const SizedBox()
              : Positioned(
                  left: e.animationX.value * tileSize,
                  top: e.animationY.value * tileSize,
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
                      e.val!=0?e.val.toString():"",
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
            child: GestureDetector(
              onVerticalDragEnd: (d){
                if (d.velocity.pixelsPerSecond.dy<-250 && canSwipeUp(gridCol)){
                  _doSwipe(swipeUp);
                  //up
                } else if (d.velocity.pixelsPerSecond.dy>250&&canSwipeDown(gridCol)){
                   _doSwipe(swipeDown);
                  //down
                }
              },
              onHorizontalDragEnd: (d){
                 if (d.velocity.pixelsPerSecond.dx<-300&&canSwipeLeft(grid)){
                    _doSwipe(swipeLeft);
                  //left
                } else if (d.velocity.pixelsPerSecond.dx>300&&canSwipeRight(grid)){
                   _doSwipe(swipeRight);
                  //right
                }

              },
              child: Stack(
                children: stackItems,
              ),
            )),
      ),
    );
  }
  void swipeLeft() => grid.forEach(mergeTiles);
  void swipeRight() => grid.map((e) => e.reversed.toList()).forEach(mergeTiles);
  void swipeUp() => gridCol.forEach(mergeTiles);
  void swipeDown() => gridCol.map((e) => e.reversed.toList()).forEach(mergeTiles);
  void mergeTiles(List<Tile> tiles) {
  for (int i = 0; i < tiles.length; i++) {
    Iterable<Tile> toCheck = tiles.skip(i).skipWhile((value) => value.val == 0);
    if (toCheck.isNotEmpty) {
      Tile t = toCheck.first;
      Tile? merge = toCheck.skip(1).firstWhereOrNull((x) => x.val != 0);
      if (merge != null && merge.val != t.val) {
        merge = null;
      }
      if (tiles[i] != t || merge != null) {
        int resultValue = t.val;
        t.moveTo(animationController, tiles[i].x, tiles[i].y);
        if (merge != null) {
          resultValue += merge.val;
          // move the merge tile
          merge.moveTo(animationController, tiles[i].x, tiles[i].y);
          merge.bounce(animationController);
          merge.changeNumber(animationController, resultValue);
          merge.val = 0;
          t.changeNumber(animationController,0);
        }
        t.val = 0;
        tiles[i].val = resultValue;
      }
    }
  }
}

}
