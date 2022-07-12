import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:indexa/Screens/allProducts.dart';
import 'package:indexa/Screens/all_Categories.dart';
import 'package:indexa/widgets/productosNuevosWidget.dart';

import '../clases/categoria.dart';
import '../clases/descuentos.dart';
import '../clases/producto.dart';
import '../constants.dart';
import '../funciones/funciones_firebase.dart';
import 'card_descuento.dart';
import 'categoryWidget.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  List<Categoria> categories = [];
  List<Producto> productos = [];
  List<Descuento> descuentos = [];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                title: Text(
                  nombreEmpresa,
                  style: styleLetrasAppBar,
                ),
                centerTitle: true,
                foregroundColor: const Color(0xFFEEF2FF),
                backgroundColor: const Color(0xFF233142),
              )
            ],
        body: ListView(
          padding: const EdgeInsets.only(left: 5, top: 15, bottom: 15),
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AllCategories(),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(right: 20, bottom: 15, top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      todasCategorias,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: color4,
                        fontSize: 18,
                      ),
                    ),
                    Icon(
                      Icons.arrow_right_alt,
                      color: color3,
                    )
                  ],
                ),
              ),
            ),

            SizedBox(
              height: 200,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("categorias/")
                      .limit(4)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(
                        color: color3,
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasError) {
                      return const Center(
                        child: Icon(
                          Icons.error,
                          size: 45,
                        ),
                      );
                    }
                    if (!snapshot.hasData) {
                      return Center(
                        child: Image.asset(
                          "assets/empty.png",
                          width: 25,
                          height: 25,
                        ),
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
                    if (snapshot.hasError) {
                      return const Center(
                        child: Icon(
                          Icons.error,
                          size: 45,
                        ),
                      );
                    }
                    if (snapshot.hasData) {
                      categories = obtenerCategorias(snapshot);
                    }
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return CategoryWidget(category: categories[index]);
                      },
                    );
                  }),
            ),

            //==================================DESCUENTOS======================
            const SizedBox(
              height: 1,
            ),
            descuentos.isNotEmpty
                ? Text(
                    "Descuentos disponibles",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  )
                : const SizedBox(),
/*
            SizedBox(
              height: 250,
              child: Lottie.network(
                  "https://assets10.lottiefiles.com/packages/lf20_xueypr0w.json"),
            ),

 */

            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Descuentos/")
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  double s = 180;
                  if (snapshot.hasError) {
                    return const Icon(Icons.error);
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: color3,
                      ),
                    );
                  }
                  if (snapshot.data!.size == 0) {
                    s = 10;
                  }
                  if (snapshot.hasData) {
                    descuentos = obtenerDescuentos(snapshot);
                    return SizedBox(
                      height: s,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: descuentos.length,
                        itemBuilder: (context, index) {
                          return CardDescuento(
                              descripcion: descuentos[index].descripcion,
                              porcentaje: descuentos[index].porcentaje,
                              color1: descuentos[index].color1,
                              color2: descuentos[index].color2,
                              color3: descuentos[index].color3);
                        },
                      ),
                    );
                  }
                  return SizedBox(
                    height: s,
                  );
                }),

            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text("Productos nuevos", textAlign: TextAlign.center),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            const AllProducts(categoria: "none"),
                      ),
                    );
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.only(right: 20, bottom: 15, top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Todos los productos",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: color4,
                            fontSize: 18,
                          ),
                        ),
                        Icon(
                          Icons.arrow_right_alt,
                          color: color3,
                        )
                      ],
                    ),
                  ),
                ),
                // IconButton(
                //   onPressed: () {},
                //   icon: Icon(Icons.arrow_forward_ios_outlined),
                // ),
              ],
            ),

            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("productos/")
                    .orderBy("nombre")
                    .limitToLast(5)
                    .snapshots(),
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
                          style: Theme.of(context).textTheme.bodyMedium,
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
                  return SizedBox(
                    height: 350,
                    child: ListView.builder(
                        itemCount: productos.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return ProdNuevosWidget(producto: productos[index]);
                        }),
                  );
                })
          ],
        ));
  }
}
