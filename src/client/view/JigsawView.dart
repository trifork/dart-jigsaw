class JigsawView extends e.EventTarget {
  JigsawModel model;

  PuzzleView puzzleView;
  /*TimerView*/ var timerView;

  JigsawView(this.model): super(null, new e.EventTargetEvents()),
    this.puzzleView = new PuzzleView(this.model, document.query("#jigsaw")),
    this.timerView = null {
    this.puzzleView.parent = this;
  }

  init() {
    model.on.change.add(_handleModelChange);
    this.puzzleView.init();

    document.query("#shuffle").
      on.click.add((e) => this.dispatch(new JEvent("shuffle",null)));

    document.query("#reset").
      on.click.add((e) => this.dispatch(new JEvent("reset",null)));


    document.query("#back").
      on.click.add((e) => this.dispatch(new JEvent("back",null)));

    document.query("#start").
      on.click.add((e) => this.dispatch(new JEvent("start",null)));
  }

  _handleModelChange(e) {
    var data = e.payload;
    if (data['old'] !== null) {//this is a move
      puzzleView.swap(data['old'], data['new']);
    }
  }
}
