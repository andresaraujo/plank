library plank.loggers;

import 'package:logging/logging.dart' as l;
import 'package:ansicolor/ansicolor.dart';
import 'dart:async';
import 'package:plank/plank.dart';

class SimpleLogger extends TaggedLogger {
  String _tag = "";
  l.Logger _log;


  SimpleLogger() {
    _log = l.Logger.root;
    _log.onRecord.listen(log);
  }

  @override
  void tag(String tag) {
    _tag = tag;
  }

  void log(l.LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
    if(rec.error != null) {
      print(rec.error);
      print(rec.stackTrace);
    }
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
enum LogLevel {ERROR, WARNING, INFO, VERBOSE, DEBUG}
class PrettyLogger extends SimpleLogger {

  static const String TOP_LEFT_CORNER = '╔';
  static const String BOTTOM_LEFT_CORNER = '╚';
  static const String MIDDLE_CORNER = '╟';
  static const String HORIZONTAL_DOUBLE_LINE = '║';
  static const String DOUBLE_DIVIDER = "════════════════════════════════════════════";
  static const String SINGLE_DIVIDER = "────────────────────────────────────────────";
  static const String TOP_BORDER = TOP_LEFT_CORNER + DOUBLE_DIVIDER + DOUBLE_DIVIDER;
  static const String BOTTOM_BORDER = BOTTOM_LEFT_CORNER + DOUBLE_DIVIDER + DOUBLE_DIVIDER;
  static const String MIDDLE_BORDER = MIDDLE_CORNER + SINGLE_DIVIDER + SINGLE_DIVIDER;

  AnsiPen pen = new AnsiPen()..red(bold: true);
  bool colorize;
  bool showTag;
  bool showTraces;
  int tracesToShow;

  PrettyLogger({this.colorize: false, this.showTag: true, this.showTraces: true, this.tracesToShow: 2});

  logChunk(l.Level level, String chunk) {
    if(level == l.Level.SEVERE) {
      pen.xterm(203);
    }else if(level == l.Level.WARNING){
      pen.xterm(221);
    }else{
      pen.reset();
    }

    if(colorize){
      print(pen(chunk));
    }else {
      print(chunk);
    }

  }

  logTopBorder(l.Level level) {
    logChunk(level, TOP_BORDER);
  }

  logTag(l.Level level) {
    logChunk(level, HORIZONTAL_DOUBLE_LINE + " " + _tag);
  }

  logHeaderContent(l.Level level, StackTrace stackTrace) {

    List<String> trace = [];
    if(stackTrace != null) {
      trace.addAll(stackTrace.toString().trim().split("\n"));
    }

    String offset = "";
    for (int i = tracesToShow - 1; i >= 0; i--) {
      if(i  > trace.length -1) continue;

      StringBuffer builder = new StringBuffer();
      builder
        ..write("║ ")
        ..write(offset)
        ..write(trace[i]);
      offset += "   ";
      logChunk(level, builder.toString());
    }
  }

  logBottomBorder(l.Level level) {
    logChunk(level, BOTTOM_BORDER);
  }

  logDivider(l.Level level) {
    logChunk(level, MIDDLE_BORDER);
  }

  logContent(l.Level level, String chunk, Object error) {
    if(error != null ) {
      String errorMessage = error.toString().trim().split("\n").first;
      chunk = "${errorMessage}\n\n$chunk";
    }
    List<String> lines = chunk.split("\n");
    for (String line in lines) {
      logChunk(level, HORIZONTAL_DOUBLE_LINE + " " + line);
    }
  }

  @override
  log(l.LogRecord record) {
    logTopBorder(record.level);

    if(showTag)
      logTag(record.level);

    if(showTag || record.stackTrace!= null) {
      logHeaderContent(record.level, record.stackTrace);
      logDivider(record.level);
    }

    logContent(record.level, record.message, record.error);
    logBottomBorder(record.level);
  }
}

class LogRecord {
  final String message;
  final Object error;
  final StackTrace stackTrace;
  final DateTime time;

  LogRecord(this.message, this.error, this.stackTrace): time = new DateTime.now();

  //String toString() => '[${level.name}] $loggerName: $message';
}
