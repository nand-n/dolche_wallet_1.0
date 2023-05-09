import 'package:dio/dio.dart';
import 'package:dolche_wallet/Components/Forgot/Verify/ChangeForgottenPassword.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class ForgotYourPassword extends StatefulWidget {
  const ForgotYourPassword({super.key});

  @override
  State<ForgotYourPassword> createState() => _ForgotYourPasswordState();
}

class _ForgotYourPasswordState extends State<ForgotYourPassword> {
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  // padding: const EdgeInsets.all(10),
                  padding: const EdgeInsets.only(
                      left: 92.92, right: 91.5, bottom: 56.37),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Register To Dolche',
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            // fontStyle: FontStyle.normal,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(HexColor("282B4F"))),
                      child: const Text('Send Code'),
                      onPressed: () {
                        // print(nameController.text);
                        // print(passwordController.text);
                        forgotPasswordRequest(
                          emailController.text,
                        );
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => Homepage(),
                        //     ));
                      },
                    )),
              ],
            )));
  }

  void forgotPasswordRequest(String email) async {
    Dio dio = Dio();
    String baseUrl = 'http://10.0.2.2:3001/forgot-password';
    // String baseUrl = 'https://dolche-api.onrender.com/register';

    // var Data = {"email": "nahi@mail.com", "password": "nahi002"};
    var Data = {
      "email": email,
    };
    try {
      var response = await dio
          .post(
        baseUrl,
        data: Data,
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      )
          .then(
        (value) {
          return Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChangeForgotenPassword()));
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }
}
