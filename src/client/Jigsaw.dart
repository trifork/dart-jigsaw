// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/**
 * Very simple sample app showing use of the [SliderMenu] view.
 */
class Jigsaw  {

  static final Jigsaw APP = const Jigsaw();
  static final int JIGSAW_SIZE = 3;
  const Jigsaw();

  JigsawModel _model;
  JigsawView  _view;
  JigsawController _controller;

  void ready() {
    //document.query("#go").on.click.add(_handleGo);
    _model = new JigsawModel(JIGSAW_SIZE, "images/porche.png");
    _view = new JigsawView(this.model);
    _controller = new JigsawController(this.model,this.view);

    _controller.init();
    _view.init();
    _model.init();

  }

  JigsawModel get model() => _model;
  JigsawView get view() => _view;
  JigsawController get ctrl() => _controller;


  static void main() {

    Dom.ready(Jigsaw.APP.ready);
  }
}
