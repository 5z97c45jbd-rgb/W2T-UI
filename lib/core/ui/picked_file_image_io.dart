import 'dart:io';

import 'package:flutter/widgets.dart';

bool existsSync(String path) => File(path).existsSync();

ImageProvider fileImage(String path) => FileImage(File(path));
