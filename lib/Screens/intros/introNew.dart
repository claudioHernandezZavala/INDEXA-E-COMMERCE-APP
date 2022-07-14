import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:indexa/bounciPageRoute.dart';
import 'package:lottie/lottie.dart';

import '../../constants.dart';
import 'intro_Nueva.dart';

class registerProcess extends StatefulWidget {
  const registerProcess({Key? key}) : super(key: key);

  @override
  State<registerProcess> createState() => _registerProcessState();
}

class _registerProcessState extends State<registerProcess> {
  int currentIndex = 0;
  TextEditingController nombre = TextEditingController();
  TextEditingController numero = TextEditingController();
  TextEditingController direccion = TextEditingController();
  final key = GlobalKey<FormState>();
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
                key: key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 45,
                    ),
                    const Text("Antes de empezar,configuremos tu cuenta"),
                    Image.asset(
                      "assets/registerpic1.gif",
                      width: double.infinity,
                      height: 190,
                    ),
                    const Text("¿Como deberia de llamarte?"),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 250,
                      child: TextFormField(
                        controller: nombre,
                        validator: (value) {
                          return value!.isEmpty
                              ? "Un nombre es requerido"
                              : null;
                        },
                        decoration: const InputDecoration(
                          hintText: "Nombre",
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text("¿Cual es tu numero?"),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 250,
                      child: TextFormField(
                        controller: numero,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          return value!.isEmpty
                              ? "Un numero es requerido"
                              : null;
                        },
                        decoration: const InputDecoration(
                          hintText: "Numero",
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text("¿Cual es tu direccion?"),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 250,
                      child: TextFormField(
                        controller: direccion,
                        validator: (value) {
                          return value!.isEmpty
                              ? "Una direccion es requerido"
                              : null;
                        },
                        decoration: const InputDecoration(
                          hintText: "Direccion",
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (key.currentState!.validate()) {
                            showDialog(
                              context: context,
                              builder: (ctx2) {
                                return AlertDialog(
                                  content: Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white,
                                    ),
                                    child: Lottie.network(
                                        "https://assets10.lottiefiles.com/packages/lf20_xueypr0w.json",
                                        width: 150,
                                        height: 150),
                                  ),
                                );
                              },
                            );

                            FirebaseFirestore.instance
                                .collection("usuarios/")
                                .doc(FirebaseAuth.instance.currentUser?.uid)
                                .update({
                              "Nombre": nombre.text,
                              "Numero": int.parse(numero.text),
                              "Direccion": [direccion.text]
                            }).then((value) {
                              Navigator.of(context).pop();
                              showsnacksuccesful(context);
                            }).whenComplete(() {
                              Navigator.of(context).pushAndRemoveUntil(
                                  BouncyPageRoute(IntroSlides()),
                                  (route) => false);
                            });
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color?>(color3),
                        ),
                        icon: const Icon(Icons.check_box),
                        label: const Text("Listo"),
                      ),
                    )
                  ],
                )),
          ),
        ));
  }

  void showsnacksuccesful(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Operacion Existosa"),
      ),
    );
  }
}
