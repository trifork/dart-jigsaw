class JigsawController extends e.EventTarget {

  AbstractStrategy currentStrategy;
  JigsawModel model;
  JigsawView view;
  ReceivePort currentPort;

  List _moves;

  JigsawController(this.model, this.view);

  void init() {

    this._moves = [];
    window.setInterval(() {
        if (this._moves.length == 0) return;
        Pos p = this._moves.removeLast();
        if (p === null) _kill();
        else {
          if (!this.model.move(p)) _kill();
        }
      }, 1000);

    view.on["move"].add((e) {
        var pos = e.payload['loc'];
        model.move(pos);
      });
    view.on["shuffle"].add((e)=> model.shuffle());


    view.on["back"].add((e) => model.stepback());
    view.on["reset"].add((e) => model.reset());

    view.on['start'].add((e) {
        currentStrategy = new RandomAIStrategy();
        initStrategy();
        currentStrategy.spawn().then((sp) {
            var x = serialize(model.board);
            sp.send(x,currentPort.toSendPort());
          });
      });
  }

  void initStrategy() {
    _kill();
    currentPort = new ReceivePort();
    currentPort.receive(_receive);

  }


  _kill() {
    if (currentPort !== null) {
      currentPort.close();
      currentPort = null;
    }

  }

  _receive(Map msg,_) {
    Pos p = new Pos(msg['row'], msg['col']);
    _moves.add(p);

  }

}
