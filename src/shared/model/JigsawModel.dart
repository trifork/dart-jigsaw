class JigsawModel extends EventTarget {
  final Board _board;
  String imageUrl;
  List _history;

  JigsawModel(int size,this.imageUrl):
  super(null, new JigsawModelEvents()),
    this._board = new Board(size),
    this._history = [];

  init() {
    _board.forEachPos((p) {
        _change(p,null);
        this._board[p] = p;
      });
  }

  Board get board() => _board;
  int get size() => _board._size;

  reset() {
    board.forEachPos((p) => _swap(p, _board[p]));
    this._history = [];
  }

  Pos get hole() => this.board.holeLocation;

  bool move(Pos newLoc) {
    Pos old = this.hole;
    if (board.isValidMove(newLoc, old)) {
      _swap(newLoc,old);
      return true;
    }
    return false;
  }

  void _swap(Pos newPos, Pos old) {
    Event e = _change(newPos,old);
    if (!e.defaultPrevented) {
      _history.add(old);
      _board.swap(newPos, old);
    }
  }

  void stepback() {
    if (_history.length==0) return;
    move(_history.removeLast());
    _history.removeLast();//pop this move
  }

  Event _change(Pos n, Pos o) {
    Event e = new Event("change", {"new":n,"old":o});
    this.dispatch(e);
    return e;
  }

  // void shuffle() {
  //   int idx = size*size*size;
  //   for (int i=0;i<idx;i++) {
  //     List<Pos> v = validMoves(this.hole);
  //     int r = _randInt(v.length);
  //     this.hole = v[r];
  //   }
  // }

  String toString() => "Jigsaw[${str(this._board)}]";
}
