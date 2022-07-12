import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:indexa/constants.dart';
import 'package:indexa/widgets/categoryWidget.dart';
import 'package:lottie/lottie.dart';

import '../clases/categoria.dart';
import '../funciones/funciones_firebase.dart';

class AllCategories extends StatefulWidget {
  const AllCategories({Key? key}) : super(key: key);

  @override
  State<AllCategories> createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
  List<Categoria> categorias = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Todas las categorias"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("categorias").snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container(
              color: color3,
              child: Column(
                children: [
                  Image.asset("assets/empty.png"),
                  Text("An error ocurred")
                ],
              ),
            );
          }
          if (!snapshot.hasData) {
            return Container(
              width: 50,
              height: 50,
              child: Lottie.asset("assets/bluecar.json"),
            );
          }
          if (snapshot.data!.size == 0) {
            return Row(
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
                  "No hay categorias por ahora",
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              ],
            );
          }
          if (snapshot.hasData) {
            categorias = obtenerCategorias(snapshot);
            return GridView.builder(
              itemCount: categorias.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (ctx, index) {
                return CategoryWidget(category: categorias[index]);
              },
            );
          }

          return CircularProgressIndicator(
            color: color1,
          );
        },
      ),
    );
  }
}
