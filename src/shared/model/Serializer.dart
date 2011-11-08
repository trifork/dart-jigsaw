
serialize(positions) {
  var res = {};
  for(var k in positions.getKeys()) {
    var v = positions[k];
    var inner = res.putIfAbsent(k.row,() => {});
    inner[k.col] = {"row":v.row, "col":v.col};
  }
  return res;
}

deserialize(m) {
  Map res = {};
  for (var row in m.getKeys()) {
    var m_row = m[row];
    for (var col in m_row.getKeys()) {
      var val = m_row[col];
      res[new Pos(row,col)] = new Pos(val["row"], val["col"]);
    }
  }
  return res;
}
