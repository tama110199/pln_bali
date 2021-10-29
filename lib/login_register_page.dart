import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pln_bali/utils/colors.dart';
import 'package:pln_bali/utils/font_styles.dart';

TextEditingController _namaController =
    TextEditingController(text: "Ramadhan Pratama");
TextEditingController _emailController =
    TextEditingController(text: "tama110199@gmail.com");
TextEditingController _passwordController =
    TextEditingController(text: "110199");
TextEditingController _valPasswordController =
    TextEditingController(text: "110199");

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isVisiblePass = false;
  bool isLoginPage = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // snackBar Widget
  tampilSnackBar(String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: abuTua,
        content: Text(
          '$message',
          style: fontStyle1,
        ),
        duration: Duration(milliseconds: 2000),
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        orientation: Orientation.portrait);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: abuTua,
        height: 1.sh,
        width: 1.sw,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Container(
                    height: 250,
                    child: Image.asset("assets/images/logo_putih.png"),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: loginWidget(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: registerWidget(),
            ),
          ],
        ),
      ),
    );
  }

  Widget loginWidget() {
    return AnimatedContainer(
      height: (isLoginPage) ? 0.7.sh : 0.sh,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40.r),
          topLeft: Radius.circular(40.r),
        ),
      ),
      duration: Duration(milliseconds: 500),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              "Login",
              style: fontStyle2.copyWith(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: abuMuda),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: abuMuda),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  labelText: "Email",
                  labelStyle: fontStyle1.copyWith(color: abuMuda),
                  hintText: "andibudi@gmail.com",
                  hintStyle: fontStyle1.copyWith(color: abuMuda, fontSize: 16),
                  prefixIcon: Icon(
                    FontAwesomeIcons.userAlt,
                    size: 16,
                    color: abuMuda,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: abuMuda),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: abuMuda),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  labelText: "Password",
                  labelStyle: fontStyle1.copyWith(color: abuMuda),
                  prefixIcon: Icon(
                    FontAwesomeIcons.lock,
                    size: 16,
                    color: abuMuda,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      (isVisiblePass)
                          ? FontAwesomeIcons.eye
                          : FontAwesomeIcons.eyeSlash,
                    ),
                    onPressed: () {
                      setState(() {
                        isVisiblePass = !isVisiblePass;
                      });
                    },
                  ),
                ),
                keyboardType: TextInputType.visiblePassword,
                obscureText: !isVisiblePass,
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            ElevatedButton(
              onPressed: () async {
                String email = _emailController.text.trim();
                String password = _passwordController.text.trim();

                if (email.isEmpty) {
                  tampilSnackBar('Nomor HP masih kosong. Silahkan input.');
                } else if (password.isEmpty) {
                  tampilSnackBar('Password masih kosong. Silahkan input.');
                } else {
                  setState(() {
                    isLoading = true;
                  });

                  try {
                    await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: "$email", password: "$password");
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      tampilSnackBar("Akun tidak ditemukan. Silahkan daftar.");
                    } else if (e.code == 'wrong-password') {
                      tampilSnackBar("Password anda salah. Coba lagi.");
                    }
                  }

                  setState(() {
                    isLoading = false;
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Login",
                  style: fontStyle1.copyWith(fontSize: 20, letterSpacing: 2),
                ),
              ),
              style: ElevatedButton.styleFrom(
                  primary: abuTua,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
            ),
            SizedBox(
              height: 16.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Belum punya akun ?",
                  style: fontStyle2,
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isLoginPage = false;
                    });
                  },
                  child: Text(
                    "Daftar Sekarang",
                    style: fontStyle2.copyWith(
                      color: abuTua,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget registerWidget() {
    return AnimatedContainer(
      height: (!isLoginPage) ? 0.7.sh : 0.sh,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40.r),
          topLeft: Radius.circular(40.r),
        ),
      ),
      duration: Duration(milliseconds: 500),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      isLoginPage = true;
                    });
                  },
                  icon: Icon(
                    FontAwesomeIcons.arrowAltCircleLeft,
                    size: 32,
                    color: abuTua,
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                Text(
                  "Daftar",
                  style: fontStyle2.copyWith(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16.h,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: TextField(
                controller: _namaController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: abuMuda),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: abuMuda),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  labelText: "Nama",
                  labelStyle: fontStyle1.copyWith(color: abuMuda),
                  hintText: "Andi Budi",
                  hintStyle: fontStyle1.copyWith(color: abuMuda, fontSize: 16),
                  prefixIcon: Icon(
                    FontAwesomeIcons.userAlt,
                    size: 16,
                    color: abuMuda,
                  ),
                ),
                keyboardType: TextInputType.name,
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: abuMuda),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: abuMuda),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  labelText: "Email",
                  labelStyle: fontStyle1.copyWith(color: abuMuda),
                  hintText: "andibudi@gmail.com",
                  hintStyle: fontStyle1.copyWith(color: abuMuda, fontSize: 16),
                  prefixIcon: Icon(
                    FontAwesomeIcons.userAlt,
                    size: 16,
                    color: abuMuda,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: abuMuda),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: abuMuda),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  labelText: "Password",
                  labelStyle: fontStyle1.copyWith(color: abuMuda),
                  prefixIcon: Icon(
                    FontAwesomeIcons.lock,
                    size: 16,
                    color: abuMuda,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      (isVisiblePass)
                          ? FontAwesomeIcons.eye
                          : FontAwesomeIcons.eyeSlash,
                    ),
                    onPressed: () {
                      setState(() {
                        isVisiblePass = !isVisiblePass;
                      });
                    },
                  ),
                ),
                keyboardType: TextInputType.visiblePassword,
                obscureText: !isVisiblePass,
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: TextField(
                controller: _valPasswordController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: abuMuda),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: abuMuda),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  labelText: "Validasi Password",
                  labelStyle: fontStyle1.copyWith(color: abuMuda),
                  prefixIcon: Icon(
                    FontAwesomeIcons.lock,
                    size: 16,
                    color: abuMuda,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      (isVisiblePass)
                          ? FontAwesomeIcons.eye
                          : FontAwesomeIcons.eyeSlash,
                    ),
                    onPressed: () {
                      setState(() {
                        isVisiblePass = !isVisiblePass;
                      });
                    },
                  ),
                ),
                keyboardType: TextInputType.visiblePassword,
                obscureText: !isVisiblePass,
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            ElevatedButton(
              onPressed: () async {
                String nama = _namaController.text.trim();
                String email = _emailController.text.trim();
                String password = _passwordController.text.trim();
                String valPassword = _valPasswordController.text.trim();

                if (email.isEmpty) {
                  tampilSnackBar('Nomor HP masih kosong. Silahkan input.');
                } else if (password.isEmpty) {
                  tampilSnackBar('Password masih kosong. Silahkan input.');
                } else if (valPassword.isEmpty) {
                  tampilSnackBar(
                      'Validasi password masih kosong. Silahkan input.');
                } else if (valPassword != password) {
                  tampilSnackBar(
                      'Validasi password tidak cocok. Silahkan periksa.');
                } else {
                  setState(() {
                    isLoading = true;
                  });

                  try {
                    UserCredential userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: "$email", password: "$password");

                    String uidUser = userCredential.user!.uid;

                    Map<String, dynamic> dataUser = {
                      "nama": nama,
                      "email": email,
                    };

                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(uidUser)
                        .set(dataUser)
                        .then((value) {
                      tampilSnackBar("Akun berhasil dibuat.");
                    });
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'email-already-in-use') {
                      tampilSnackBar("Email yang ada gunakan telah terdaftar.");
                    }
                  } catch (e) {
                    print(e);
                  }

                  setState(() {
                    isLoading = false;
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: (isLoading)
                    ? Container(
                        height: 32.h,
                        width: 32.h,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      )
                    : Text(
                        "Daftar",
                        style:
                            fontStyle1.copyWith(fontSize: 20, letterSpacing: 2),
                      ),
              ),
              style: ElevatedButton.styleFrom(
                  primary: abuTua,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
            ),
          ],
        ),
      ),
    );
  }
}