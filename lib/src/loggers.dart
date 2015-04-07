library plank.loggers;

import 'package:logging/logging.dart' as l;
import 'package:plank/plank.dart';

class SimpleLogger extends PlankLogger {
  l.Logger _log;


  SimpleLogger({String name: 'SimpleLogger'}) {
    _log = new l.Logger(name);
    _log.onRecord.listen(log);
  }

  void log(l.LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  }

  @override
  void d(String message, [Object error, StackTrace stackTrace]) {
    _log.fine(message, error, stackTrace);
  }

  @override
  void e(String message, [Object error, StackTrace stackTrace]) {
    _log.severe(message, error, stackTrace);
  }

  @override
  void i(String message, [Object error, StackTrace stackTrace]) {
    _log.info(message, error, stackTrace);
  }

  @override
  void v(String message, [Object error, StackTrace stackTrace]) {
    _log.config(message, error, stackTrace);
  }

  @override
  void w(String message, [Object error, StackTrace stackTrace]) {
    _log.warning(message, error, stackTrace);
  }
}

class DummyLogger extends TaggedLogger {
  String _tag = "DummyLogger";

  @override
  void tag(String tag) {
    _tag = tag;
  }

  @override
  void d(String message, [Object error, StackTrace stackTrace]) {
    log(message, error, stackTrace);
  }

  @override
  void e(String message, [Object error, StackTrace stackTrace]) {
    log(message, error, stackTrace);
  }

  @override
  void i(String message, [Object error, StackTrace stackTrace]) {
    log(message, error, stackTrace);
  }

  @override
  void v(String message, [Object error, StackTrace stackTrace]) {
    log(message, error, stackTrace);
  }

  @override
  void w(String message, [Object error, StackTrace stackTrace]) {
    log(message, error, stackTrace);
  }

  log(String message, [Object error, StackTrace stackTrace]) {
    print("${_tag} : $message");
  }
}
