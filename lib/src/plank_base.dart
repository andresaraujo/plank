// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library plank.base;

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

  static void v(String message, {Error error}) {
    MASTER.v(message, error: error);
  }

  static void d(String message, {Error error}) {
    MASTER.d(message, error: error);
  }

  static void i(String message, {Error error}) {
    MASTER.i(message, error: error);
  }

  static void w(String message, {Error error}) {
    MASTER.w(message, error: error);
  }

  static void e(String message, {Error error}) {
    MASTER.e(message, error: error);
  }

  static PlankLogger tag(String tag) {
    for (int index = 0, size = TAGGED_LOGGERS.length; index < size; index++) {
      (LOGGERS[TAGGED_LOGGERS[index]] as TaggedLogger).tag(tag);
    }
    return MASTER;
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

  void v(String message, {Error error});

  void d(String message, {Error error});

  void i(String message, {Error error});

  void w(String message, {Error error});

  void e(String message, {Error error});
}

abstract class TaggedLogger extends PlankLogger {
  void tag(String tag);
}

class MasterPlank extends PlankLogger {
  @override
  void d(String message, {Error error}) {
    for(PlankLogger t in LOGGERS) {
      t.d(message, error: error);
    }
  }

  @override
  void e(String message, {Error error}) {
    for(PlankLogger t in LOGGERS) {
      t.e(message, error: error);
    }
  }

  @override
  void i(String message, {Error error}) {
    for(PlankLogger t in LOGGERS) {
      t.i(message, error: error);
    }
  }

  @override
  void v(String message, {Error error}) {
    for(PlankLogger t in LOGGERS) {
      t.v(message, error: error);
    }
  }

  @override
  void w(String message, {Error error}) {
    for(PlankLogger t in LOGGERS) {
      t.w(message, error: error);
    }
  }
}

class DummyLogger extends TaggedLogger {
  String _tag = "DummyLogger";

  @override
  void d(String message, {Error error}) {
    log(message, error: error);
  }

  @override
  void e(String message, {Error error}) {
    log(message, error: error);
  }

  @override
  void i(String message, {Error error}) {
    log(message, error: error);
  }

  @override
  void tag(String tag) {
    _tag = tag;
  }

  @override
  void v(String message, {Error error}) {
    log(message, error: error);
  }

  @override
  void w(String message, {Error error}) {
    log(message, error: error);
  }

  log(String message, {Error error}) {
    print("${_tag} : $message");
  }
}
