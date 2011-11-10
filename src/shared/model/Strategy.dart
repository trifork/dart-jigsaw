interface Strategy {
  void init();
  String get name();
  void run(SendPort p);
}
