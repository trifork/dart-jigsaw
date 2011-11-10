class RandomAIStrategy extends AIStrategy {
  final int maxCount = 10;
  int count = 0;
  RandomAIStrategy():super("Random");

  Pos nextMove(board) {
    if (count++ == maxCount) return null;
    List<Pos> valid = board.validMoves(board.holeLocation);
    return valid[randomInt(valid.length)];
  }
}
