import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_pallete.dart';
import '../core/theme/theme.dart';
import '../firebase_options.dart';
import '../services/http_service.dart';
import '../services/navigation.dart';
import '../services/secure_storage.dart';

SecureStorage storage = SecureStorage();
HTTPService httpService = HTTPService();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: AppPallete.primaryColor,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .whenComplete(() => runApp(MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: Apptheme.darkThemeMode,
          initialRoute: '/',
          routes: Navigation.routes)));
}
