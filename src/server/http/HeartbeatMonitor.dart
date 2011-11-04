class HeartbeatMonitor {

  Map _heartbeats;
  Map<int,Timer> _hbTimers;
  int _nextId;
  HeartbeatMonitor(): _heartbeats={},_hbTimers={},_nextId=0;

  clear() {
    _hbTimers.forEach((id,t)  {
        t.cancel();
        _heartbeats.remove(id);
      });
    _hbTimers.clear();
  }

  monitor(ReceivePort rp, [frequency=500, callback=null]) {
    var id = _nextId;
    rp.receive((_,__) => _handleReceive(id,frequency));
    _heartbeats[_nextId] = {"port": rp, "callback":callback, "id":_nextId, "frequency":frequency};
    _setTimer(_nextId,frequency);
    _nextId += 1;
  }

  _setTimer(id,freq) {
    var t = _hbTimers[id];
    if (t != null) {
      t.cancel();
    }
    _hbTimers[id] = new Timer((t)=>_check(id,t),freq,false);
  }

  _handleReceive(id,freq) {
    _setTimer(id,freq);
  }

  _check(id, timer) {
    var hb = _heartbeats[id];
    if (hb['callback'](hb)) {
      _setTimer(id,hb['frequency']);
    } else {
      _heartbeats[id] = null;
      _hbTimers[id] = null;
    }
  }

}
