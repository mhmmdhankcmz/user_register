import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user_register/anasayfa.dart';
import 'package:user_register/girisEkrani.dart';
import 'package:user_register/profilSayfasi.dart';

class YazilarSayfasi extends StatefulWidget {
  const YazilarSayfasi({Key? key}) : super(key: key);

  @override
  State<YazilarSayfasi> createState() => _YazilarSayfasiState();
}

class _YazilarSayfasiState extends State<YazilarSayfasi> {

  var t1 = TextEditingController();
  var t2 = TextEditingController();

  var gelenYaziBaslik = "";
  var gelenYaziIcerik = "";

  FirebaseAuth kullanici = FirebaseAuth.instance;


  void yaziListele(){

    FirebaseFirestore.instance.collection('Yazilar').doc(t1.text).get().then((gelenVeri){
      setState((){
        gelenYaziBaslik = gelenVeri.data()!['baslik'];
        gelenYaziIcerik = gelenVeri.data()!['icerik'];
      });
    }) ;

  }


  void yaziEkle(){
    setState(() {
      FirebaseFirestore.instance.collection('Yazilar').doc(t1.text).set({'kullaniciid': kullanici.currentUser?.uid,'baslik':t1.text, 'icerik': t2.text,}).whenComplete(() => print("yazı eklendi"));
    });


  }
  void yaziGuncelle(){
    FirebaseFirestore.instance.collection('Yazilar').doc(t1.text).update({'baslik':t1.text, 'icerik': t2.text});
  }
  void yaziSil(){
    FirebaseFirestore.instance.collection('Yazilar').doc(t1.text).delete();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Yazı Ekleme"),
        actions: [
          IconButton(
            onPressed: (){
              FirebaseAuth.instance.signOut().then((user) {
                //giriş sayfasına git
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>GirisEkrani()), (route) => false);
              });
            }, icon: Icon(Icons.exit_to_app_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                  height: 40,
                  child: TextField(
                    controller: t1,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Konu ",
                      labelText: "Konu Girin",
                    ),
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                  child: TextField(
                    controller: t2,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Metin",
                      labelText: "Metin Girin",
                    ),
                  )
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(onPressed: (){setState(() {
                    yaziEkle();
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilEkrani()));
                  }); }, child: Text("Ekle")),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(onPressed: (){yaziGuncelle();
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilEkrani()));}, child: Text("Güncelle")),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(onPressed: (){yaziSil();
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilEkrani()));}, child: Text("Sil")),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(onPressed: (){yaziListele();
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilEkrani()));}, child: Text("Getir")),
                ),
              ],

            ),
            Card(
              child: ListTile(
                title: Text(gelenYaziBaslik),
                subtitle: Text(gelenYaziIcerik),
              ),
            )
          ],
        ),
      ),
    );
  }
}
