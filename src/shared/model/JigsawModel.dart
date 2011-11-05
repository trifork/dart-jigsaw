class JigsawModel extends EventTarget {
  final Map<Pos, Pos> _permutation;
  final int _size;

  JigsawModel(this._size): super(null, new JigsawModelEvents()),
    this._permutation = {} {
    reset();
  }

  int get size() => _size;

  reset() {
    _forEachPos((p) {
        _change(p, p, this[p]);
        _permutation[p] = p;
      });
  }

  void _forEachPos(f) {
    for (int i=0;i<size;i++) {
      for (int j=0;j<size;j++) {
        f(new Pos(i,j));
      }
    }
  }

  Pos operator [](Pos p) => this._permutation[p];

  Pos operator []=(Pos p, Pos v) {
    Pos old = this[p];
    Event e = _change(p,v,old);
    if (!e.defaultPrevented) {
      this._permutation[p] = v;
    }
    return old;
  }

  Event _change(Pos k, Pos n, Pos o) {
    Event e = new EventImpl("change", {"key":k,"new":n,"old":o});
    this.dispatch(e);
    return e;
  }

  void shuffle() {
    int idx = size*size;
    _forEachPos((p) {
        Pos rnd = _randomPos(idx);
        _change(p, rnd, this[p]);
        _permutation[p] = rnd;
        idx--;
      });
  }

  Pos _randomPos(int max) {
    int rnd = _rndInt(max);
    return new Pos(floor(rnd / 3), rnd % 3);
  }

  int _rndInt(int max) {
   return floor(Math.random()*max);
  }

  String toString() => "Jigsaw[${str(this._permutation)}]";



}
