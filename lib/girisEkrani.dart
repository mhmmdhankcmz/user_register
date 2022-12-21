import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user_register/kayitEkrani.dart';
import 'package:user_register/profilSayfasi.dart';

class GirisEkrani extends StatefulWidget {
  const GirisEkrani({Key? key}) : super(key: key);

  @override
  State<GirisEkrani> createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {

  late String email,sifre;

  var formAnahtari = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Giriş Ekrani"),
      ),
      body: Form(
        key: formAnahtari,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (alinanEmail){
                    email = alinanEmail;
                  },
                  validator:(alinanEmail) =>EmailValidator.validate(alinanEmail!) ? null : "Geçerli Email Giriniz" ,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  obscureText: true,
                  onChanged: (alinanSifre){
                    sifre = alinanSifre;
                  },
                  validator: (alinanSifre){
                    return alinanSifre!.length >=6 ? null : "En az 6 karakter olmalı";
                  },
                  decoration: InputDecoration(
                    labelText: "Şifre",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.all(8.0),
                  height: 70,
                  width: double.infinity,
                  child: ElevatedButton(onPressed: (){ girisYap(); }, child: Text("Giriş Yap"))
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> KayitEkrani()));
                  print("kayıt sayfasına git");

                },
                child: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.all(8.0),
                    child: Text("Hesabım Yok" ,style: TextStyle(fontSize: 18,color: Colors.green),)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //email ve şifreye göre doğrulama yapıp giriş yapacak
  void girisYap() {
    if(formAnahtari.currentState!.validate()){
      //giriş yap
      FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: sifre).then((user){
        //eğre başarılıysa Ana sayfaya git
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>ProfilEkrani()), (route) => false);
        
      }).catchError((hata){
        Fluttertoast.showToast(msg: hata);
      });
    }
  }
}
