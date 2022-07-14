import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:indexa/Screens/screensPerfil/Drecciones.dart';
import 'package:indexa/bounciPageRoute.dart';
import 'package:lottie/lottie.dart';

import '../../../constants.dart';
import '../../funciones/funciones_firebase.dart';
import '../../usuario/infoUsuario.dart';
import '../../widgets/noUser.dart';

class Perfil extends StatefulWidget {
  const Perfil({Key? key}) : super(key: key);

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  String nombre = "";
  String direccion = "", ubicacion = "";
  String rtn = "";
  bool suscrito = false;
  int numero = 0;
  // var info;
  final formkey = GlobalKey<FormState>();
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
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (mounted) {
        if (user == null) {
          setState(() {});
        } else {}
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return FirebaseAuth.instance.currentUser == null
        ? NoUserWidget(
            width: width,
            heigth: h,
          )
        : Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              backgroundColor: color3,
              title: const Text("My profile"),
              titleTextStyle: styleLetrasAppBar,
              centerTitle: true,
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
                  if (snapshot.hasData) {
                    //info = snapshot.data as infoUser;
                  }
                  // if (!snapshot.hasData) {
                  //   return Column(
                  //     children: [
                  //       Lottie.network(
                  //           "https://assets10.lottiefiles.com/packages/lf20_xueypr0w.json"),
                  //       Text("Ocurrio un error")
                  //     ],
                  //   );
                  // }
                  // if (snapshot.hasError) {
                  //   return Column(
                  //     children: [
                  //       Lottie.network(
                  //           "https://assets10.lottiefiles.com/packages/lf20_xueypr0w.json"),
                  //       Text("Ocurrio un error")
                  //     ],
                  //   );
                  // }
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(
                      20,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Hola,${(snapshot.data as infoUser).nombre}"),
                          const SizedBox(
                            height: 50,
                          ),
                          ListTile(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    var nombreNuevo = TextEditingController();
                                    return BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 3, sigmaY: 3),
                                      child: AlertDialog(
                                        backgroundColor: Colors.white,
                                        title: const Text(
                                            "Ingresa el nuevo nombre"),
                                        content: TextFormField(
                                          controller: nombreNuevo,
                                        ),
                                        actions: [
                                          IconButton(
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                            },
                                            icon: const Icon(Icons.delete),
                                            color: Colors.red,
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                              showDialog(
                                                  context: context,
                                                  builder: (ctx2) {
                                                    return FutureProgressDialog(
                                                      (snapshot.data
                                                              as infoUser)
                                                          .referencia
                                                          .update({
                                                        "Nombre":
                                                            nombreNuevo.text
                                                      }),
                                                      progress: Lottie.network(
                                                          "https://assets10.lottiefiles.com/packages/lf20_xueypr0w.json"),
                                                    );
                                                  });
                                            },
                                            icon: const Icon(Icons.check_box),
                                            color: Colors.green,
                                          )
                                        ],
                                      ),
                                    );
                                  });
                            },
                            title: const Text("Nombre"),
                            leading: const Icon(
                              Icons.person,
                              color: Colors.teal,
                            ),
                            subtitle:
                                Text("${(snapshot.data as infoUser).nombre}"),
                            trailing: const Icon(
                              Icons.edit,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.of(context)
                                  .push(BouncyPageRoute(ScreenDirecciones(
                                refprimera:
                                    (snapshot.data as infoUser).referencia,
                              )));
                            },
                            title: const Text("Direcciones"),
                            leading: const Icon(
                              Icons.map_outlined,
                              color: Colors.teal,
                            ),
                            subtitle: const Text("Administra tus direcciones"),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          ListTile(
                            title: const Text("Numero"),
                            leading: const Icon(
                              Icons.numbers,
                              color: Colors.teal,
                            ),
                            subtitle:
                                Text("${(snapshot.data as infoUser).numero}"),
                            trailing: const Icon(
                              Icons.edit,
                              color: Colors.teal,
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    var numeroNuevo = TextEditingController();
                                    return BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 3, sigmaY: 3),
                                      child: AlertDialog(
                                        backgroundColor: Colors.white,
                                        title: const Text(
                                            "Ingresa el nuevo numero"),
                                        content: TextFormField(
                                          controller: numeroNuevo,
                                        ),
                                        actions: [
                                          IconButton(
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                            },
                                            icon: const Icon(Icons.delete),
                                            color: Colors.red,
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                              showDialog(
                                                  context: context,
                                                  builder: (ctx2) {
                                                    return FutureProgressDialog(
                                                      (snapshot.data
                                                              as infoUser)
                                                          .referencia
                                                          .update({
                                                        "Numero": int.parse(
                                                            numeroNuevo.text)
                                                      }),
                                                      progress: Lottie.network(
                                                          "https://assets10.lottiefiles.com/packages/lf20_xueypr0w.json"),
                                                    );
                                                  });
                                            },
                                            icon: const Icon(Icons.check_box),
                                            color: Colors.green,
                                          )
                                        ],
                                      ),
                                    );
                                  });
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ListTile(
                            onTap: () {
                              FirebaseAuth.instance.signOut();
                            },
                            title: const Text("Cerrar sesion"),
                            leading: const Icon(
                              Icons.logout_outlined,
                              color: Colors.teal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // child: Form(
                    //   key: formkey,
                    //   child: Column(
                    //     children: [
                    //       Padding(
                    //         padding: const EdgeInsets.only(
                    //             top: 15, left: 10, right: 10),
                    //         child: Text(
                    //             "This information is only for your orders",
                    //             style: estiloLetras18),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.all(15),
                    //         child: TextFormField(
                    //           initialValue:
                    //               info.nombre.isNotEmpty ? info.nombre : null,
                    //           validator: (value) {
                    //             return value!.isEmpty
                    //                 ? "Nmae is required"
                    //                 : null;
                    //           },
                    //           onSaved: (value) {
                    //             nombre = value!;
                    //           },
                    //           decoration: InputDecoration(
                    //               hintText: 'Name',
                    //               labelText: 'Name',
                    //               floatingLabelBehavior:
                    //                   FloatingLabelBehavior.always,
                    //               prefixIcon: const Icon(Icons.text_fields),
                    //               filled: true,
                    //               focusedBorder: OutlineInputBorder(
                    //                 borderRadius: BorderRadius.circular(15),
                    //                 borderSide: const BorderSide(
                    //                     color: Colors.black, width: 2),
                    //               ),
                    //               labelStyle: const TextStyle(
                    //                   color: Colors.white, fontSize: 20),
                    //               floatingLabelStyle: const TextStyle(
                    //                   color: Colors.black,
                    //                   backgroundColor: Colors.transparent,
                    //                   fontSize: 25,
                    //                   fontWeight: FontWeight.bold),
                    //               fillColor: color3.withOpacity(0.8),
                    //               border: OutlineInputBorder(
                    //                   borderRadius: BorderRadius.circular(15))),
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.all(15),
                    //         child: TextFormField(
                    //           minLines: 6,
                    //           maxLines: null,
                    //           initialValue: info.direccion.isNotEmpty
                    //               ? info.direccion[0]
                    //               : null,
                    //           onSaved: (value) {
                    //             direccion = value!;
                    //           },
                    //           decoration: InputDecoration(
                    //               hintText: 'Address',
                    //               labelText: 'Address',
                    //               filled: true,
                    //               focusedBorder: OutlineInputBorder(
                    //                 borderRadius: BorderRadius.circular(15),
                    //                 borderSide: const BorderSide(
                    //                     color: Colors.black, width: 2),
                    //               ),
                    //               labelStyle: const TextStyle(
                    //                   color: Colors.white, fontSize: 20),
                    //               floatingLabelStyle: const TextStyle(
                    //                   color: Colors.black,
                    //                   backgroundColor: Colors.transparent,
                    //                   fontSize: 25,
                    //                   fontWeight: FontWeight.bold),
                    //               fillColor: color3.withOpacity(0.8),
                    //               border: OutlineInputBorder(
                    //                   borderRadius: BorderRadius.circular(15))),
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.all(15),
                    //         child: TextFormField(
                    //           initialValue: info.numero.toString().isNotEmpty
                    //               ? info.numero.toString()
                    //               : null,
                    //           validator: (value) {
                    //             return value!.isEmpty
                    //                 ? "Number required"
                    //                 : null;
                    //           },
                    //           onSaved: (value) {
                    //             if (value != null) {
                    //               if (value.isEmpty) {
                    //                 numero = 0;
                    //               } else {
                    //                 numero = int.parse(value);
                    //               }
                    //             }
                    //           },
                    //           keyboardType: TextInputType.number,
                    //           decoration: InputDecoration(
                    //               labelText: 'Phone Number',
                    //               floatingLabelBehavior:
                    //                   FloatingLabelBehavior.always,
                    //               hintText: 'Phone Number',
                    //               prefixIcon: const Icon(Icons.numbers),
                    //               filled: true,
                    //               focusedBorder: OutlineInputBorder(
                    //                 borderRadius: BorderRadius.circular(15),
                    //                 borderSide: const BorderSide(
                    //                     color: Colors.black, width: 2),
                    //               ),
                    //               labelStyle: const TextStyle(
                    //                   color: Colors.white, fontSize: 20),
                    //               floatingLabelStyle: const TextStyle(
                    //                   color: Colors.black,
                    //                   backgroundColor: Colors.transparent,
                    //                   fontSize: 25,
                    //                   fontWeight: FontWeight.bold),
                    //               fillColor: color3.withOpacity(0.8),
                    //               border: OutlineInputBorder(
                    //                   borderRadius: BorderRadius.circular(15))),
                    //         ),
                    //       ),
                    //       const SizedBox(
                    //         height: 10,
                    //       ),
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Text(
                    //             "Recibir actualizaciones",
                    //             style: estiloLetras18,
                    //           ),
                    //           Switch(
                    //               value: info.suscrito,
                    //               activeColor: Colors.green,
                    //               onChanged: (bool value) {
                    //                 if (value == false) {
                    //                   FirebaseMessaging.instance
                    //                       .unsubscribeFromTopic("NewDrop");
                    //                   info.referencia
                    //                       .update({"suscrito": value});
                    //                   setState(() {
                    //                     info.suscrito = value;
                    //                   });
                    //                 } else {
                    //                   FirebaseMessaging.instance
                    //                       .subscribeToTopic("NewDrop");
                    //
                    //                   info.referencia
                    //                       .update({"suscrito": value});
                    //                   setState(() {
                    //                     info.suscrito = value;
                    //                   });
                    //                 }
                    //
                    //                 setState(() {
                    //                   // v = value;
                    //                 });
                    //               }),
                    //         ],
                    //       ),
                    //       const SizedBox(
                    //         height: 25,
                    //       ),
                    //       TextButton(
                    //         onPressed: () {
                    //           if (validateForm()) {
                    //             info.referencia.set({
                    //               'Nombre': nombre,
                    //               'Direccion': direccion,
                    //               'Numero': numero,
                    //             }, SetOptions(merge: true)).whenComplete(() =>
                    //                 Fluttertoast.showToast(
                    //                     msg: "Cambios guardados",
                    //                     backgroundColor: Colors.green));
                    //             FirebaseAuth.instance.currentUser
                    //                 ?.updateDisplayName(nombre);
                    //           }
                    //         },
                    //         style: ButtonStyle(
                    //             minimumSize: MaterialStateProperty.all<Size>(
                    //                 const Size(325, 45)),
                    //             backgroundColor:
                    //                 MaterialStateProperty.all<Color>(color3),
                    //             shadowColor: MaterialStateProperty.all<Color>(
                    //                 Colors.deepPurple.withOpacity(0.6)),
                    //             foregroundColor:
                    //                 MaterialStateProperty.all<Color>(
                    //                     Colors.white),
                    //             shape: MaterialStateProperty.all(
                    //                 RoundedRectangleBorder(
                    //                     borderRadius:
                    //                         BorderRadius.circular(15)))),
                    //         child: const Text("Guardar cambios"),
                    //       ),
                    //       const SizedBox(
                    //         height: 35,
                    //       ),
                    //       ListTile(
                    //         onTap: () {
                    //           FirebaseAuth.instance.signOut();
                    //         },
                    //         title: Center(
                    //             child: Text(
                    //           "Sign out",
                    //           style: estiloLetras22,
                    //         )),
                    //         tileColor: color3,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  );
                }),
          );
  }

  bool validateForm() {
    final form = formkey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
