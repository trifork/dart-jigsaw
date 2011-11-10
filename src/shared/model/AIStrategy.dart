class AIStrategy extends AbstractStrategy {
  AIStrategy(String name): super(name);

  void init(){}

  void run(SendPort sp) {
    while (!this.board.isSolved()) {
      Pos pos = nextMove(this.board);
      if (pos !== null) {
        sp.send({"row":pos.row, "col":pos.col});
        this.board.move(pos);
      } else {
        return;
      }
    }
  }

  abstract Pos nextMove(Board board);

}
