import 'dart:async';

import 'package:clean_up/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


const supabaseUrl = 'https://hdrrqcdfxokgwslyjlns.supabase.co';
const supabaseKey = String.fromEnvironment('SUPABASE_KEY');



Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();


  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);

  //initialize Firebase Messaging
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  //requesting permission for notifications
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }


  }


