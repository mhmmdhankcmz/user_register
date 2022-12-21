import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user_register/girisEkrani.dart';
import 'package:user_register/profilSayfasi.dart';
import 'package:user_register/yazilarSayfasi.dart';

class Anasayfa extends StatelessWidget {
  const Anasayfa({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Anasayfa"),
        actions: [
          IconButton(
            onPressed: (){
                //giriş sayfasına git
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>ProfilEkrani()), (route) => true);
            }, icon: const Icon(Icons.account_circle),
          ),
          IconButton(
            onPressed: (){
              FirebaseAuth.instance.signOut().then((user) {
                //giriş sayfasına git
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const GirisEkrani()), (route) => false);
              });
            }, icon: const Icon(Icons.power_settings_new),
          ),
        ],
      ),
      body: const UserInformation(),
    );
  }
}

class UserInformation extends StatefulWidget {
  const UserInformation({Key? key}) : super(key: key);

  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('Yazilar').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Birşeyler Yanlış Gitti');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Yükleniyor..." ,style: TextStyle(fontSize: 30,fontStyle: FontStyle.italic,color: Colors.green),);
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: GestureDetector(
                onTap: (){
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilEkrani())); // yazıyı daha fazla görüntüleyebilmek için girilecek sayfa
                },
                child: Card(
                  child: ListTile(
                    title: Text("BaşLık :  ${data['baslik']}"),
                    subtitle: Text("İçerik :  ${data['icerik']}"),
                    textColor: Colors.green,
                    tileColor: Colors.white10,
                    shape: const OutlineInputBorder(),
                    selectedTileColor: Colors.lightGreen,
                  ),
                ),
              ),
            );
          }).toList(),
        );

      },
    );
  }
}