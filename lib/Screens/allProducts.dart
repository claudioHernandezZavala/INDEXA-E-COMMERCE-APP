import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../bounciPageRoute.dart';
import '../clases/producto.dart';
import '../constants.dart';
import '../funciones/funciones_firebase.dart';
import '../widgets/allproductWidget.dart';
import 'carrito/carrito.dart';

class AllProducts extends StatelessWidget {
  final String categoria;
  const AllProducts({Key? key, required this.categoria}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var snap = categoria == "none"
        ? FirebaseFirestore.instance.collection("productos/").snapshots()
        : FirebaseFirestore.instance
            .collection("productos/")
            .where("categoria", isEqualTo: categoria)
            .snapshots();
    List<Producto> productos = [];
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        backgroundColor: color3,
        foregroundColor: color1,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(BouncyPageRoute(const Carrito()));
              },
              icon: Icon(
                Icons.shopping_bag,
                color: color3,
              ))
        ],
      ),
      body: StreamBuilder(
          stream: snap,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Icon(Icons.error);
            }
            if (!snapshot.hasData) {
              return Image.asset(
                "assets/empty.png",
                width: 25,
                height: 25,
              );
            }
            if (snapshot.data!.size == 0) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      "assets/empty.png",
                      width: 50,
                      height: 50,
                    ),
                  ),
                  Text(
                    "No hay productos por ahora",
                    style: estiloLetras22,
                  )
                ],
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: color3,
                ),
              );
            }
            if (snapshot.hasData) {
              productos = obtainProducts(snapshot);
            }
            return ListView.builder(
                itemCount: productos.length,
                itemBuilder: (context, index) {
                  return AllProductWidget(producto: productos[index]);
                });
          }),
    );
  }
}
