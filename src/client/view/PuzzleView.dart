class PuzzleView extends e.EventTarget {
  JigsawModel model;
  Element _element;
  PuzzleView(this.model, this._element):super(null, new e.EventTargetEvents());

  init() {
    this._element.on.click.add(_clickHandler);
  }

  _locFilter(s) => s.indexOf("loc") >= 0;

  _clickHandler(e) {
    Element t = e.target;
    String loc = first(t.classes.filter(_locFilter));

    this.dispatch(new JEvent("move", {"loc":_class2pos(loc)}));
  }

  swap(Pos old, Pos n) {
    String old_loc = "loc${old.row}${old.col}";
    String new_loc = "loc${n.row}${n.col}";
    Element old_piece = document.query(".$old_loc");
    Element new_piece = document.query(".$new_loc");

    old_piece.classes.remove(old_loc);
    old_piece.classes.add(new_loc);

    new_piece.classes.remove(new_loc);
    new_piece.classes.add(old_loc);

  }

  Pos _class2pos(String s) {//"loc01"
    int r = Math.parseInt(s.substring(3,4));
    int c = Math.parseInt(s.substring(4,5));
    return new Pos(r,c);
  }

}



class JEvent extends e.EventImpl implements e.Event {
  JEvent(String type, p): super(type,p);
}
