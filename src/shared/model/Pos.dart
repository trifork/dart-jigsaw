class Pos {
  final int row;
  final int col;
  const Pos(this.row,this.col);
  int operator [](int idx) {
    if (idx === 0) { return row;}
    if (idx === 1) { return col;}
    throw new IndexOutOfRangeException(idx);
  }
  String toString() => "Pos[$row,$col]";
  int hashCode() => 7+ 13*row.hashCode() + 23*col.hashCode();
  bool operator ==(o) => (o is Pos) && o.row === row && o.col === col;
}
