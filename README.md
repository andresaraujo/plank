# plank

A simple and extensible logger

## Usage

```dart

import 'package:plank/plank.dart';
import 'package:logging/logging.dart' show Level;


void main() {
  
  //Optional, defaults to Level.ALL
  Plank.setLevel(Level.WARNING);
  
  //Install the loggers you want to use, handy for dev-prod environments
  Plank.install(new SimpleLogger());
  Plank.install(new PrettyLogger(showTag: true, colorize: false));

  //Optional tags the next logs calls
  Plank.tag("MY_TAG");
  
  //Logs as Level.INFO
  Plank.i("This is an info message");
  
  //Logs as Level.WARNING
  Plank.w("This is a warning message");
  
  //Logs as Level.FINE
  Plank.d("This is a debug message");
  
  //Logs as Level.FINER
  Plank.v("This is a verbose message");
  
  //Logs as Level.CONFIG
  Plank.c("This is a config message");

  try {
    throw new StateError("Somethin' wrong?");
  } catch(error, stackTrace) {
    //Logs as Level.SEVERE
    Plank.e("This is an error message", error,  stackTrace);
  }
  
  //Logs as Level.SHOUT
  Plank.wtf("This is a terrible failure message");
}


```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/andresaraujo/plank/issues
