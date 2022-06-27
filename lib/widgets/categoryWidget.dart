//import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../Screens/allProducts.dart';
import '../bounciPageRoute.dart';
import '../clases/categoria.dart';
import '../constants.dart';

class CategoryWidget extends StatelessWidget {
  final Categoria category;
  const CategoryWidget({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(BouncyPageRoute(AllProducts(
          categoria: category.categoriaTexto,
        )));
      },
      child: Column(
        children: [
          Container(
              width: 100,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(70)),
              child: CircleAvatar(
                radius: 45,
                backgroundColor: color3,
                backgroundImage: NetworkImage(
                  category.imagen,
                ),
              )),
          Text(category.categoriaTexto)
        ],
      ),
    );
  }
}
