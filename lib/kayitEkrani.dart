import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user_register/anasayfa.dart';
import 'package:user_register/girisEkrani.dart';

class KayitEkrani extends StatefulWidget {
  const KayitEkrani({Key? key}) : super(key: key);

  @override
  State<KayitEkrani> createState() => _KayitEkraniState();
}

class _KayitEkraniState extends State<KayitEkrani> {
  late String email, emailDogrulama, sifre;


  var _formAnahtari = GlobalKey<FormState>();

  //Email ve şifreye göre firebase e kullancıı ekle
 Future <void> kayitEkle() async {
    if(email == emailDogrulama){
      if (_formAnahtari.currentState!.validate()) {
        setState(() {
          FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: sifre)
              .then((user) {
                FirebaseFirestore.instance.collection("Kullanicilar").doc(email).set({'Email':email,'Sifre':sifre}).whenComplete(() => print("Kullanıcı FireStore a eklendi"));
            //başarılıysa anasayfaya git
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => Anasayfa()),
                    (Route<dynamic> route) => false);
          }).catchError((hata) {
            // hata mesajı göster
            Fluttertoast.showToast(msg: hata.toString());
          });
        });
      }
    }else{
      alertTextKarsilastirma();
    }

  }

  void alertTextKarsilastirma(){

    showDialog(context: context, builder: (context){
      return AlertDialog(
        content: Text(" E postalar Aynı Değil !!!!!",style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold,color: Colors.red),),
      );
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kayıt Ol"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>GirisEkrani()));},
              icon: Icon(Icons.account_circle),
          ),
        ],
      ),
      body: Form(
        key: _formAnahtari,
        child: SingleChildScrollView(
          child: Container(          
            padding: const EdgeInsets.all(12.0),
            child: Column(

              children: [
                TextFormField(
                  onChanged: (alinanMail) {
                    setState(() {
                      email = alinanMail;
                    });
                  },

                  validator: (alinanMail) =>EmailValidator.validate(alinanMail!) ? null :"geçerli email giriniz",
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email Girin",
                    hintText: "Geçerli Email girin",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  onChanged: (alinanDogrulamaMail) {
                    setState(() {
                      emailDogrulama = alinanDogrulamaMail;
                    });
                  },

                  validator: (alinanDogrulamaMail) =>EmailValidator.validate(alinanDogrulamaMail!) ? null :"geçerli email giriniz",
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Tekrar Email Girin",
                    hintText: "Geçerli Email girin",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),

                TextFormField(
                  onChanged: (alinanSifre) {
                    sifre = alinanSifre;
                  },
                  validator: (alinanSifre) {
                    return alinanSifre!.length >= 6
                        ? null
                        : "en az 6 karkter giriniz";
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Şifre Girin",
                    hintText: "Geçerli Şifre girin",
                    border: OutlineInputBorder(),
                  ),
                ),
                Container(
                    padding: EdgeInsets.all(8.0),
                    height: 70,
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          kayitEkle();
                        },
                        child: Text("Kayıt ol"))),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SizedBox(
                    height: 20,
                    child: Container(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => GirisEkrani()));
                              print("basıldı");
                              //-----giriş sayfasına girsin
                            },
                            child: Text(
                              "Zaten hesabım var",
                              style: TextStyle(fontSize: 14,color: Colors.green),
                            ))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
