import 'package:game_2048_f/src/model/tile.dart';
import 'package:collection/collection.dart';

bool canSwipeLeft(List<List<Tile>> rows) => rows.any(canSwipe);
bool canSwipeRight(List<List<Tile>> rows) =>
    rows.map((e) => e.reversed.toList()).any(canSwipe);
bool canSwipeUp(Iterable<List<Tile>> cols) => cols.any(canSwipe);
bool canSwipeDown(Iterable<List<Tile>> cols) =>
    cols.map((e) => e.reversed.toList()).any(canSwipe);

bool canSwipe(List<Tile> tiles) {
  for (int i = 0; i < tiles.length; i++) {
    if (tiles[i].val == 0) {
      if (tiles.skip(i + 1).any((e) => e.val != 0)) {
        return true;
      }
    } else {
      Tile? nextNonZero = tiles.skip(i + 1).firstWhereOrNull((e) => e.val != 0);
      if (nextNonZero != null && nextNonZero.val == tiles[i].val) {
        return true;
      }
    }
  }
  return false;
}

