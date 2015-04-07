// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library plank.base;

import 'package:logging/logging.dart' show LogRecord, Logger, Level;

final List<PlankLogger> LOGGERS = [];
final List<int> TAGGED_LOGGERS = [];
final MasterPlank MASTER = new MasterPlank();

/**
 * A simple and extensible logger
 *
 *    Plank.install(new DummyLogger());
 *    Plank.tag("MyTag");
 *    Plank.i("content");
 */
class Plank {

  /**
   * Logs a verbose message
   */
  static void v(String message, [Object error, StackTrace stackTrace]) {
    MASTER.v(message, error, stackTrace);
  }

  /**
   * Logs a debug message
   */
  static void d(String message, [Object error, StackTrace stackTrace]) {
    MASTER.d(message, error, stackTrace);
  }

  /**
   * Logs an info message
   */
  static void i(String message, [Object error, StackTrace stackTrace]) {
    MASTER.i(message, error, stackTrace);
  }

  /**
   * Logs a warning message
   */
  static void w(String message, [Object error, StackTrace stackTrace]) {
    MASTER.w(message, error, stackTrace);
  }

  /**
   * Logs an error message
   */
  static void e(String message, [Object error, StackTrace stackTrace]) {
    MASTER.e(message, error, stackTrace);
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
   * Throws an [ArgumentError] if [plankLogger] is the same as [MASTER] logger
   */
  static void install(PlankLogger plankLogger) {
    if (plankLogger == null) {
      throw new StateError("plankLogger == null");
    }
    if (plankLogger == MASTER) {
      throw new ArgumentError("Cannot install Master logger into itself.");
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

  void v(String message, [Object error, StackTrace stackTrace]);

  void d(String message, [Object error, StackTrace stackTrace]);

  void i(String message, [Object error, StackTrace stackTrace]);

  void w(String message, [Object error, StackTrace stackTrace]);

  void e(String message, [Object error, StackTrace stackTrace]);
}

abstract class TaggedLogger extends PlankLogger {
  void tag(String tag);
}

class MasterPlank  {
  final Logger logger;

  MasterPlank() : logger = Logger.root {
    logger.onRecord.listen((LogRecord record) {

      for (PlankLogger t in LOGGERS) {
        if (record.level == Level.FINE) {
          t.d(record.message, record.error, record.stackTrace);
        }else if (record.level == Level.SEVERE) {
          t.e(record.message, record.error, record.stackTrace);
        }else if (record.level == Level.WARNING) {
          t.w(record.message, record.error, record.stackTrace);
        }else if (record.level == Level.INFO) {
          t.i(record.message, record.error, record.stackTrace);
        }else if (record.level == Level.CONFIG) {
          t.v(record.message, record.error, record.stackTrace);
        }else {
          t.v(record.message, record.error, record.stackTrace);
        }
      }
    });
  }

  //@override
  void d(String message, [Object error, StackTrace stackTrace]) {
    //for (PlankLogger t in LOGGERS) {
    //  t.d(message, error, stackTrace);
    //}
    logger.fine(message, error, stackTrace);
  }

  //@override
  void e(String message, [Object error, StackTrace stackTrace]) {
    //for (PlankLogger t in LOGGERS) {
    //  t.e(message, error, stackTrace);
    //}
    logger.severe(message, error, stackTrace);
  }

  //@override
  void i(String message, [Object error, StackTrace stackTrace]) {
    //for (PlankLogger t in LOGGERS) {
    //  t.i(message, error, stackTrace);
    //}
    logger.info(message, error, stackTrace);
  }

  //@override
  void v(String message, [Object error, StackTrace stackTrace]) {
    //for (PlankLogger t in LOGGERS) {
    //  t.v(message, error, stackTrace);
    //}
    logger.config(message, error, stackTrace);
  }

 // @override
  void w(String message, [Object error, StackTrace stackTrace]) {
    //for (PlankLogger t in LOGGERS) {
    //  t.w(message, error, stackTrace);
    //}
    logger.warning(message, error, stackTrace);
  }
}
