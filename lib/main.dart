
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'app.dart';
import 'bloc/simple_bloc_delegate.dart';
import 'model/user_model.dart';
 
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocDelegate();
  var document;
  if (kIsWeb) {
    document = Directory('/');
} else {
    document = await getApplicationDocumentsDirectory();
}
  Hive.init(document.path);
  Hive.registerAdapter(AuthUserAdapter());
  await Hive.openBox<AuthUser>('user');
  await Hive.openBox('seenBox');
  runApp(MyApp());
}