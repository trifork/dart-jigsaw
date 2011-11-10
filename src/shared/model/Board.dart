class Board implements Map<Pos, Pos> {
  final Map<Pos, Pos> _permutation;
  final Pos holeKey;
  final int _size;

  Map get perm() => _permutation;

  Board.from(Map<Pos,Pos> perm):
    this._permutation = perm,
    this.holeKey = new Pos(0,0),
    this._size = floor(Math.sqrt(perm.length));

  Board(this._size):
    this._permutation = {},
    this.holeKey = new Pos(0,0)
      {
        forEachPos((p) => this._permutation[p] = p);
      }

  int get size() => _size;

  Pos get holeLocation() => this[this.holeKey];

  bool move(Pos newLoc) {
    Pos old = this.holeLocation;
    if (isValidMove(newLoc, old)) {
      swap(newLoc,old);
      return true;
    }
    return false;
  }

  void swap(Pos p1, Pos p2) {
    Pos k1 = key_for_value(_permutation,p1);
    Pos k2 = key_for_value(_permutation,p2);
    _permutation[k1] = p2;
    _permutation[k2] = p1;
  }

  bool isSolved() {
    bool fin = true;
    forEachPos((p) {
        fin = fin && (p == this[p]);
      });
    return fin;
  }

  List<Pos> validMoves(Pos from) {
    var moves = [new Pos(from.row-1,from.col),
                 new Pos(from.row+1,from.col),
                 new Pos(from.row,from.col-1),
                 new Pos(from.row,from.col+1)];
    return moves.filter((p) => isValidMove(p,from));
  }


  bool isValidMove(Pos newPos, Pos from) {
    return inBoard(newPos) && areAdjacent(from,newPos);
  }

  bool inBoard(Pos p) {
    return p.row >= 0 && p.col >= 0 && p.row < _size && p.col < _size;
  }

  bool areAdjacent(Pos p1, Pos p2) {
    return (abs(p1.row - p2.row) + abs(p1.col - p2.col)) == 1;
  }

  void forEachPos(f) {
    for (int i=0;i<size;i++) {
      for (int j=0;j<size;j++) {
        f(new Pos(i,j));
      }
    }
  }


  bool containsValue(Pos value) => _permutation.containsValue(value);
  bool containsKey(Pos key) => _permutation.containsKey(key);
  Pos operator [](Pos key) => _permutation[key];
  void operator []=(Pos key, Pos value) {
    _permutation[key] = value;
  }

  Pos putIfAbsent(Pos key, Pos ifAbsent()) {
    return _permutation.putIfAbsent(key, ifAbsent);
  }
  Pos remove(Pos key) => _permutation.remove(key);
  void clear() => _permutation.clear();

  void forEach(void f(Pos key, Pos value)) => _permutation.forEach(f);

  Collection<Pos> getKeys() => _permutation.getKeys();
  Collection<Pos> getValues() => _permutation.getValues();

  int get length() => _permutation.length;
  bool isEmpty() => _permutation.isEmpty();

  String toString() => str(_permutation);

}
