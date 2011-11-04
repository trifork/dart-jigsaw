#library("dart-jigsaw.server");
#import("../dlib/http.dart");
#import("../dlib/pprint.dart");
#import("../dlib/events_base.dart");
#import("../dlib/utils.dart");

#source("server/http/HeartbeatServer.dart");
#source("server/http/HeartbeatMonitor.dart");
#source("server/http/FileServer.dart");
#source("server/http/RoutingServer.dart");
#source("server/JigsawServer.dart");

main () {

  var s = new JigsawServer();

  var rp = new ReceivePort();
  var mon = new HeartbeatMonitor();
  _handleMsg(msg) {
    p(msg);
    if (msg=="started") {
      print("Start...");
    }
  }
  _callback(dat) {
    var r = dat['port'];
    p(dat);
    print("NO HEARBEAT... cleaning...");
    mon.clear();
    rp.close();
    r.close();
  }

  s.spawn().then((SendPort sp) {
      var r = new ReceivePort();
      mon.monitor(r, frequency:1000,callback:_callback);
      rp.receive((msg,_)=>_handleMsg(msg));
      sp.send({"host":"127.0.0.1","port":8081,"id":2, "monitorPort":r.toSendPort()}, rp);
    });


}
