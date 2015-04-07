// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library plank.example;

import 'package:plank/plank.dart';

main() {
  Plank.install(new SimpleLogger());
  Plank.install(new PrettyLogger(showTag: true, colorize: false));

  Plank.tag("MY_TAG");
  Plank.i("This is an info message");
  Plank.w("This is a warning message");

  try {
    throw new StateError("Somethin' wrong?");
  } catch(e, s) {
    Plank.e("This is an error message", e,  s);
  }
}