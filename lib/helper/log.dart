class Log {
  static bool debug = true;

  static void console(Object msg) {
    if (debug) {
      print(msg);
    }
  }
}
