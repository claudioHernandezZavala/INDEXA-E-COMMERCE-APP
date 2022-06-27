//import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Screens/detailScreen.dart';
import '../animaciones/heartAnimation.dart';
import '../bounciPageRoute.dart';
import '../clases/producto.dart';
import '../constants.dart';
import '../funciones/funciones_firebase.dart';

class ProdNuevosWidget extends StatefulWidget {
  final Producto producto;
  const ProdNuevosWidget({Key? key, required this.producto}) : super(key: key);

  @override
  State<ProdNuevosWidget> createState() => _ProdNuevosWidgetState();
}

class _ProdNuevosWidgetState extends State<ProdNuevosWidget> {
  bool isLiked = false;
  bool isAnimating = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        if (mounted) {
          setState(() {});
        }
      }
    });
    if (FirebaseAuth.instance.currentUser != null) {
      //if user is not null i trigger a listener in favorites data
      FirebaseFirestore.instance
          .collection("usuarios/")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .snapshots(includeMetadataChanges: true)
          .listen((event) {
        favorites = event.data()?["favorites"].cast<
            DocumentReference>(); //if listener triggers i set the favorites global list to the one in firebase
      });
      if (favorites.contains(widget.producto.referencia)) {
        if (mounted) {
          setState(() {
            isLiked =
                true; // if the favorites list contains the product i set liked to true
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () async {
        if (FirebaseAuth.instance.currentUser != null) {
          if (isLiked) {
            if (favorites.remove(widget.producto.referencia)) {
              await FirebaseFirestore.instance
                  .collection("usuarios/")
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .set({"favorites": favorites}, SetOptions(merge: true));
            }
            setState(() {
              isAnimating = true;
              isLiked = false;
            });
          } else {
            favorites.add(widget.producto.referencia);
            await FirebaseFirestore.instance
                .collection("usuarios/")
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .set({"favorites": favorites}, SetOptions(merge: true));
            setState(() {
              isAnimating = true;
              isLiked = true;
            });
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Debes iniciar sesion"),
            backgroundColor: Colors.red,
          ));
        }
      },
      onTap: () {
        //if only taps on it i send it to info screen
        Navigator.of(context).push(BouncyPageRoute(DetailScreen(
          prod: widget.producto,
        )));
      },
      child: Stack(
        children: [
          RotationTransition(
            //white back container
            turns: const AlwaysStoppedAnimation(-5 / 360),
            child: Container(
              margin: const EdgeInsets.all(35),
              width: 200,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey, //New
                      blurRadius: 25.0,
                      offset: Offset(0, -5))
                ],
              ),
            ),
          ),
          //with the image
          RotationTransition(
            //white container with info
            turns: const AlwaysStoppedAnimation(5 / 360),
            child: Container(
              margin: const EdgeInsets.all(35),
              width: 200,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey, //New
                      blurRadius: 25.0,
                      offset: Offset(5, 5))
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              subirCarrito(widget.producto, 1, context);
                            },
                            child: Container(
                              width: 45,
                              height: 45,
                              color: color3,
                              child: const Icon(
                                Icons.shopping_bag_sharp,
                                color: Colors.white,
                                size: 35,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        //image container
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 15, bottom: 25, left: 10, right: 10),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: NetworkImage(widget.producto.imagenes[0]),
                          )),
                        ),
                      ),
                      Container(
                          //product name container
                          margin: const EdgeInsets.only(
                              left: 5, right: 5, bottom: 15),
                          child: Center(
                              child: Text(widget.producto.nombre,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.yuseiMagic(
                                      color: color4,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)))),
                    ],
                  ),
                  Opacity(
                    opacity: isAnimating ? 1 : 0,
                    child: Container(
                      //margin: const EdgeInsets.all(100),
                      child: HeartAnimation(
                        isAnimating: isAnimating,
                        onEnd: () {
                          setState(() {
                            isAnimating = false;
                          });
                        },
                        child: Icon(
                          Icons.favorite,
                          size: 120,
                          color: color3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
