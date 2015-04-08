// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library plank.base;

import 'package:logging/logging.dart' show LogRecord, Logger, Level;
import 'dart:async';

final List<PlankLogger> LOGGERS = [];
final List<int> TAGGED_LOGGERS = [];

/**
 * A simple and extensible logger
 *
 *    Plank.install(new DummyLogger());
 *    Plank.tag("MyTag");
 *    Plank.i("content");
 */
class Plank {
  static final Logger _logger = Logger.root;
  static Stream<LogRecord> _logStream;

  static void setLevel(Level level) {
    _logger.level = level;
  }

  static void onRecord(LogRecord record) {
    for (PlankLogger t in LOGGERS) {
      if (record.level == Level.FINE) {
        t.d(record);
      }else if (record.level == Level.SEVERE) {
        t.e(record);
      }else if (record.level == Level.WARNING) {
        t.w(record);
      }else if (record.level == Level.INFO) {
        t.i(record);
      }else if (record.level == Level.CONFIG) {
        t.c(record);
      }else if (record.level == Level.FINER) {
        t.v(record);
      }else if (record.level == Level.SHOUT) {
        t.wtf(record);
      }else {
        t.i(record);
      }
    }
  }

  /**
   * Logs a verbose message
   */
  static void v(String message, [Object error, StackTrace stackTrace]) {
    _logger.finer(message, error, stackTrace);
  }

  /**
   * Logs a debug message
   */
  static void d(String message, [Object error, StackTrace stackTrace]) {
    _logger.fine(message, error, stackTrace);
  }

  /**
   * Logs an info message
   */
  static void i(String message, [Object error, StackTrace stackTrace]) {
    _logger.info(message, error, stackTrace);
  }

  /**
   * Logs a config message
   */
  static void c(String message, [Object error, StackTrace stackTrace]) {
    _logger.info(message, error, stackTrace);
  }

  /**
   * Logs a warning message
   */
  static void w(String message, [Object error, StackTrace stackTrace]) {
    _logger.warning(message, error, stackTrace);
  }

  /**
   * Logs an error message
   */
  static void e(String message, [Object error, StackTrace stackTrace]) {
    _logger.severe(message, error, stackTrace);
  }

  /**
   * Logs a terrible failure message
   */
  static void wtf(String message, [Object error, StackTrace stackTrace]) {
    _logger.shout(message, error, stackTrace);
  }

  /**
   * Adds a tag to be used on the next log calls
   */
  static void tag(String tag) {
    for (int index = 0, size = TAGGED_LOGGERS.length; index < size; index++) {
      (LOGGERS[TAGGED_LOGGERS[index]] as TaggedLogger).tag(tag);
    }
  }

  /**
   * Adds [plankLogger] to the list of loggers
   *
   * Throws a [StateError] if [plankLogger] is null
   */
  static void install(PlankLogger plankLogger) {
    if(_logStream == null){
      _logStream = _logger.onRecord;
      _logStream.listen(onRecord);
    }
    if (plankLogger == null) {
      throw new StateError("plankLogger == null");
    }
    if (plankLogger is TaggedLogger) {
      TAGGED_LOGGERS.add(LOGGERS.length);
    }
    LOGGERS.add(plankLogger);
  }

  /**
   * Removes the provided [plankLogger] from the list of loggers
   *
   * Throws an [ArgumentError] if [plankLogger] is not in the list of loggers
   */
  static void remove(PlankLogger plankLogger) {
    for (int i = 0, size = LOGGERS.length; i < size; i++) {
      if (LOGGERS[i] == plankLogger) {
        TAGGED_LOGGERS.removeAt(i);
        LOGGERS.removeAt(i);
        return;
      }
    }
    throw new ArgumentError("Cannot remove plankLogger which is not installed: ${plankLogger}");
  }

  /**
   * Removes all the loggers from the list of loggers
   */
  void removeAll() {
    TAGGED_LOGGERS.clear();
    LOGGERS.clear();
  }
}

abstract class PlankLogger {

  void v(LogRecord record);

  void d(LogRecord record);

  void i(LogRecord record);

  void c(LogRecord record);

  void w(LogRecord record);

  void e(LogRecord record);

  void wtf(LogRecord record);
}

abstract class TaggedLogger extends PlankLogger {
  void tag(String tag);
}
