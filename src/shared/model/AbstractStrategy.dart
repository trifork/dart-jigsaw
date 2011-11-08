class AbstractStrategy extends Isolate implements Strategy {
  final String _name;

  Board board;

  AbstractStrategy(this._name):super();

  String get name() => _name;

  main() {
    this.port.receive((m, SendPort sp) {
        this.board = new Board.from(deserialize(m));
        init();
        run(sp);
      });
  }

  abstract init();
  abstract run(SendPort p);
}
