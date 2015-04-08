# plank

A simple and extensible logger

You can add new loggers extending [PlankLogger] or [TaggedLogger] and installing 
the instance using `Plank.install`.

## Usage

```dart

import 'package:plank/plank.dart';
import 'package:logging/logging.dart' show Level;


void main() {
  //Optional, defaults to Level.ALL
  Plank.setLevel(Level.ALL);

  //Install the loggers you want to use, handy for dev-prod environments
  Plank.install(new SimpleLogger());
  Plank.install(new PrettyLogger(showTag: true, colorize: false));

  //Optional tags the next logs calls
  //Plank.tag("MY_TAG");

  Plank.i("This is an info message");

  Plank.w("This is a warning message");

  Plank.d("This is a debug message");

  Plank.v("This is a verbose message");

  Plank.c("This is a config message");

  try {
    throw new StateError("Somethin' wrong?");
  } catch (error, stackTrace) {
    Plank.e("This is an error message", error, stackTrace);
  }

  Plank.wtf("This is a terrible failure message");
}


```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/andresaraujo/plank/issues
