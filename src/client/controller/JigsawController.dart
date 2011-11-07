class JigsawController extends e.EventTarget {

  JigsawModel model;
  JigsawView view;
  JigsawController(this.model, this.view);

  void init() {
    view.on["move"].add((e) {
        var pos = e.payload['loc'];
        model.move(pos);
      });
    //    view.on["shuffle"].add((e) => model.shuffle());
    view.on["back"].add((e) => model.stepback());
    view.on["start"].add((e) => model.reset());

  }
}
