class FileServer extends HeartbeatServer {
  final String publicPath;
  FileServer(this.publicPath);

  void noHandlerFound(HTTPRequest request, HTTPResponse response) {
    var path = "${publicPath}${request.path}";
    fileHandler(request,response,path);
  }
}
