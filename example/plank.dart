// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library plank.example;

import 'package:plank/plank.dart';


main() {
  Plank.install(new DummyLogger());
  Plank.install(new SimpleLogger());
  Plank.tag("test tag");
  Plank.i("test");
  Plank.e("some weird error here");
}