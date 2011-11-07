class JigsawModel extends EventTarget {
  final Map<Pos, Pos> _permutation;
  final int _size;
  Pos _hole;
  String imageUrl;
  List _history;

  //to be moved
  abs(n) => n<0 ? -n : n;
  filter(m, p) {
    Map r = {};
    m.forEach((k,v) {
        if (p(k,v)) {
          r[k] = v;
        }});
    return r;
  }

  Pos _keyForValue(Pos v) {
    Pos found;
    Map m = filter(this._permutation, (k,vk) => vk == v);
    if (m.length == 0) {return null;}
    return first(m.getKeys());
  }
  //

  JigsawModel(this._size,this.imageUrl): super(null, new JigsawModelEvents()),
    this._permutation = {},
    this._history = [],
    this._hole = new Pos(0,0);

  init() {
    _forEachPos((p) {
        _change(p,null);
        this._permutation[p] = p;
      });
  }



  Pos get hole() => this._permutation[this._hole];

  void set hole(Pos newPos) {
    Pos old = this.hole;
    if (isValidMove(newPos, old)) {
      _swap(newPos,old);
    }
  }

  void _swap(Pos newPos, Pos old) {
    Pos new_k = _keyForValue(newPos);
    Pos old_k = _keyForValue(old);
    Event e = _change(newPos,old);
      if (!e.defaultPrevented) {
        _history.add([old, newPos]);
        this._permutation[old_k] = newPos;
        this._permutation[new_k] = old;
      }
  }

  void stepback() {
    var m = _history.removeLast();
    this.hole = m[0];
    _history.removeLast();//pop this move
  }


  List<Pos> validMoves(Pos from) {
    var moves = [new Pos(from.row-1,from.col),
                 new Pos(from.row+1,from.col),
                 new Pos(from.row,from.col-1),
                 new Pos(from.row,from.col+1)];
    return moves.filter((p) => isValidMove(p,from));
  }

  bool isValidMove(Pos newPos, Pos from) => _inBoard(newPos) && _adjacent(from,newPos);

  bool _inBoard(Pos p) {
    return p.row >= 0 && p.col >= 0 && p.row < size && p.col < size;
  }
  bool _adjacent(Pos p1, Pos p2) {
    return (abs(p1.row - p2.row) + abs(p1.col - p2.col)) == 1;
  }

  int get size() => _size;

  reset() {
    _forEachPos((p) {
        _swap(p, this._permutation[p]);
      });
  }

  void _forEachPos(f) {
    for (int i=0;i<size;i++) {
      for (int j=0;j<size;j++) {
        f(new Pos(i,j));
      }
    }
  }

  Event _change(Pos n, Pos o) {
    Event e = new Event("change", {"new":n,"old":o});
    this.dispatch(e);
    return e;
  }

  void shuffle() {
    int idx = size*size*size;
    for (int i=0;i<idx;i++) {
      List<Pos> v = validMoves(this.hole);
      int r = _randInt(v.length);
      this.hole = v[r];
    }
  }

  // Pos _randomPos(int max) {
  //   int rnd = _rndInt(max);
  //   return new Pos(floor(rnd / size), floor(rnd % size));
  // }

  int _randInt(int max) {
   return floor(Math.random()*max);
  }

  String toString() => "Jigsaw[${str(this._permutation)}]";



}
