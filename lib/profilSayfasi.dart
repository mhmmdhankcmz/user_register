import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user_register/anasayfa.dart';
import 'package:user_register/girisEkrani.dart';
import 'package:user_register/yazilarSayfasi.dart';

class ProfilEkrani extends StatelessWidget {
  var kAdi = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${kAdi!.email} ",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Anasayfa()),
                    (route) => false);
              },
              icon: Icon(Icons.home)),
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut().then((user) {
                //giriş sayfasına git
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => GirisEkrani()),
                    (route) => false);
              });
            },
            icon: Icon(Icons.power_settings_new),
          ),
        ],
      ),
      body: Container(
        child: TumYazilar(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => YazilarSayfasi()));
        },
        child: Icon(
          Icons.add,
        ),
        tooltip: 'yazı ekle',
      ),
    );
  }
}

class TumYazilar extends StatefulWidget {
  @override
  _TumYazilarState createState() => _TumYazilarState();
}

class _TumYazilarState extends State<TumYazilar> {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth kullanici = FirebaseAuth.instance;
    Query blogYazilari = FirebaseFirestore.instance
        .collection('Yazilar')
        .where('kullaniciid', isEqualTo: kullanici.currentUser!.uid);

    return StreamBuilder<QuerySnapshot>(
      stream: blogYazilari.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Birşeyler Yanlış Gitti');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(
            "Yükleniyor...",
            style: TextStyle(
                fontSize: 30, fontStyle: FontStyle.italic, color: Colors.green),
          );
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Card(
                child: ListTile(
                  title: Text(
                    "BaşLık :  ${data['baslik']} ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "İçerik :  ${data['icerik']} ",
                    style: TextStyle(color: Colors.black),
                  ),
                  textColor: Colors.green,
                  tileColor: Colors.white10,
                  shape: OutlineInputBorder(),
                  selectedTileColor: Colors.lightGreen,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class Profil extends StatefulWidget {
  const Profil({Key? key}) : super(key: key);

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
