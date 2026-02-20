class Logger {
  static bool _enabled = true;

  static void enable(bool value) => _enabled = value;

  static void debug(String message) {
    if (_enabled) {
      print('[DEBUG] $message');
    }
  }

  static void error(String message) {
    if (_enabled) {
      print('[ERROR] $message');
    }
  }

  static void info(String message) {
    if (_enabled) {
      print('[INFO] $message');
    }
  }
}