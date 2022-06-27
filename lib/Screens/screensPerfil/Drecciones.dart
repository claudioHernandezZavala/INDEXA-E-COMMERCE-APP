import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:indexa/funciones/funciones_firebase.dart';
import 'package:indexa/usuario/infoUsuario.dart';
import 'package:lottie/lottie.dart';

import '../../constants.dart';

class ScreenDirecciones extends StatefulWidget {
  final DocumentReference refprimera;
  const ScreenDirecciones({Key? key, required this.refprimera})
      : super(key: key);

  @override
  State<ScreenDirecciones> createState() => _ScreenDireccionesState();
}

class _ScreenDireccionesState extends State<ScreenDirecciones> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection("usuarios/")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .snapshots(includeMetadataChanges: true)
        .listen((event) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  late infoUser info;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Direcciones"),
      ),
      body: FutureBuilder(
        future: getInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.white,
              child: Lottie.network(
                  "https://assets10.lottiefiles.com/packages/lf20_xueypr0w.json"),
            );
          }

          if (!snapshot.hasData) {
            return Column(
              children: [
                Lottie.network(
                    "https://assets10.lottiefiles.com/packages/lf20_xueypr0w.json"),
                const Text("Aun no has agregado direcciones")
              ],
            );
          }
          if (snapshot.hasData) {
            info = snapshot.data as infoUser;
          }
          return ListView.builder(
              itemCount: info.direccion.length,
              padding: const EdgeInsets.all(15),
              itemBuilder: (ctx, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    title: Text(
                      "Direccion #${index + 1}",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    tileColor: color3,
                    trailing: IconButton(
                      onPressed: () {
                        info.direccion.removeAt(index);
                        info.referencia.update({"Direccion": info.direccion});
                      },
                      icon: const Icon(
                        Icons.highlight_remove,
                        size: 35,
                      ),
                      color: Colors.red,
                    ),
                    subtitle: Text(
                      "${info.direccion[index]}",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context2) {
                var control1 = TextEditingController();
                return ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: AlertDialog(
                      // backgroundColor: Colors.white,
                      title: const Text("Escribe una nueva direccion"),
                      content: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.9),
                              Colors.white.withOpacity(0.6),
                            ],
                            begin: AlignmentDirectional.topStart,
                            end: AlignmentDirectional.bottomEnd,
                          ),
                        ),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: control1,
                              onSaved: (value) {},
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(context2).pop();
                                    },
                                    icon: const Icon(
                                      Icons.dangerous,
                                      size: 35,
                                      color: Colors.red,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(context2).pop();

                                      showDialog(
                                          context: context,
                                          builder: (ctx2) {
                                            info.direccion.add(control1.text);
                                            return FutureProgressDialog(
                                              info.referencia.update({
                                                "Direccion": info.direccion
                                              }),
                                              message: const Text('Agregando'),
                                              progress: Lottie.network(
                                                  "https://assets10.lottiefiles.com/packages/lf20_xueypr0w.json"),
                                            );
                                          });
                                    },
                                    icon: const Icon(
                                      Icons.check,
                                      size: 35,
                                      color: Colors.green,
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
