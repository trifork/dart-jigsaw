class RoutingServer extends FileServer {

  Map _handl;

  RoutingServer(String pubPath): super(pubPath), _handl= {} {
    pp("Routing server");
    p(_handl);
    // var h = handlers();
    // if (h !== null) {
    //   _handlers = h;
    // } else if (_handlers === null) {
    //   _handlers = {};
    // }
    //_handlers.forEach(addHandler);

  }


  void _requestReceivedHandler(HTTPRequest request, HTTPResponse response) {
    p(request.path);
    var requestPathHandlers =_handl[request.path];
    if (requestPathHandlers == null) {
      noHandlerFound(request,response);
      return;
    }
    var requestHandler = requestPathHandlers[request.method];
    if (requestHandler == null) {
      noHandlerFound(request,response);
      return;
    }
    var res = requestHandler(request, response);
    if (res != null) {
      var page = res.charCodes();
      response.statusCode = HTTPStatus.OK;
      response.setHeader("Content-Type", "text/html; charset=UTF-8");
      response.contentLength = page.length;
      response.writeList(page, 0, page.length);
      response.writeDone();
    }
  }

  void GET(path, handler) {
    var hp = _handlers[path];
    if (hp == null) {
      hp = _handlers[path] = {};
    }
    hp["GET"] = handler;
  }




}
