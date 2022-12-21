import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:user_register/kayitEkrani.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // firebase i çalıştırıyor
  await Firebase.initializeApp(
   // options: DefaultFirebaseOptions.curretPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: KayitUygulama()
    );
  }
}

class KayitUygulama extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return KayitEkrani();
  }

}
