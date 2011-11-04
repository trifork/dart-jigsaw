class HeartbeatServer extends Isolate {

  String _host;
  int _port;
  HTTPServer _server;
  Map _requestHandlers;
  Timer _heartbeat;
  String _id;
  SendPort _monitorPort;

  void main() {

    this.port.receive((message, SendPort replyTo) {
        _monitorPort = message['monitorPort'];
        _heartbeat = new Timer((t) => _sendHeartBeat(_monitorPort,t), 500, true);
        _id = message['id'];
        _host = message['host'];
        _port = message['port'];

        this._requestHandlers = {};

        replyTo.send('starting', null);
        _server = new HTTPServer();
        try {
          _server.listen(_host, _port, _requestReceivedHandler);
          replyTo.send('started');
        } catch (var e, var st) {
          replyTo.send("error ${e}, ${st}");
        }
      });
  }

  _sendHeartBeat(SendPort replyTo, Timer t) {
    replyTo.send({"msg": 'heartbeat', 'id':_id});
  }

  void _requestReceivedHandler(HTTPRequest request, HTTPResponse response) {
    // if (_logRequests) {
    //   String method = request.method;
    //   String uri = request.uri;
    //   print("Request: $method $uri");
    //   print("Request headers:");
    //   request.headers.forEach(
    //       (String name, String value) => print("$name: $value"));
    //   print("Request parameters:");
    //   request.queryParameters.forEach(
    //       (String name, String value) => print("$name = $value"));
    //   print("");
    // }

    var requestHandler =_requestHandlers[request.path];
    if (requestHandler != null) {
      requestHandler(request, response);
    } else {
      noHandlerFound(request,response);
    }
  }

  void noHandlerFound(HTTPRequest request, HTTPResponse response) {
    _notFoundHandler(request,response);
  }

  List<int> _redirectPage;

  static final String redirectPageHtml = """
<html>
<head><title>Redirecting</title></head>
<body><h1>Redirecting...</h1></body>
</html>""";

  void redirectPageHandler(HTTPRequest request, HTTPResponse response, String redirectPath) {
    if (_redirectPage == null) {
      _redirectPage = redirectPageHtml.charCodes();
    }
    response.statusCode = HTTPStatus.OK;
    response.setHeader("Content-Type", "text/html; charset=UTF-8");
    response.contentLength = _redirectPage.length;
    response.writeList(_redirectPage, 0, _redirectPage.length);
    response.writeDone();
  }



  // Serve the not found page.
  void _notFoundHandler(HTTPRequest request, HTTPResponse response) {
    fileHandler(request,response,"src/public/404.html");
    response.statusCode = HTTPStatus.NOT_FOUND;
  }



  void sendJSONResponse(HTTPResponse response, Map responseData) {
    response.setHeader("Content-Type", "application/json; charset=UTF-8");
    response.writeString(JSON.stringify(responseData));
    response.writeDone();
  }


  HeartbeatServer() : super(), _requestHandlers = {};


  // Serve the content of a file.
  void fileHandler(
      HTTPRequest request, HTTPResponse response, [String fileName = null]) {
    final int BUFFER_SIZE = 4096;
    if (fileName == null) {
      fileName = request.path.substring(1);
    }
    File file = new File(fileName);
    if (file.existsSync()) {
      file.openSync();
      int totalRead = 0;
      List<int> buffer = new List<int>(BUFFER_SIZE);

      String mimeType = "text/html; charset=UTF-8";
      int lastDot = fileName.lastIndexOf(".", fileName.length);
      if (lastDot != -1) {
        String extension = fileName.substring(lastDot);
        if (extension == ".css") { mimeType = "text/css"; }
        if (extension == ".js") { mimeType = "application/javascript"; }
        if (extension == ".ico") { mimeType = "image/vnd.microsoft.icon"; }
        if (extension == ".png") { mimeType = "image/png"; }
      }
      response.setHeader("Content-Type", mimeType);
      response.contentLength = file.lengthSync();

      void writeFileData() {
        while (totalRead < file.lengthSync()) {
          var read = file.readListSync(buffer, 0, BUFFER_SIZE);
          totalRead += read;

          // Write this buffer and get a callback when it makes sense
          // to write more.
          bool allWritten = response.writeList(buffer, 0, read, writeFileData);
          if (!allWritten) break;
        }

        if (totalRead == file.lengthSync()) {
          response.writeDone();
        }
      }

      writeFileData();
    } else {
      print("File not found: $fileName");
      _notFoundHandler(request, response);
    }
  }


  // Unexpected protocol data.
  void _protocolError(HTTPRequest request, HTTPResponse response) {
    response.statusCode = HTTPStatus.INTERNAL_ERROR;
    response.contentLength = 0;
    response.writeDone();
  }
  void addHandler(String path, void handler(HTTPRequest request, HTTPResponse response)) {
    _requestHandlers[path] = handler;
  }


}
