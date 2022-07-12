import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../clases/pedido.dart';
import '../../../constants.dart';
import '../../../funciones/funciones_firebase.dart';
import 'screenCotiza.dart';

class AdminCotiza extends StatefulWidget {
  const AdminCotiza({Key? key}) : super(key: key);

  @override
  State<AdminCotiza> createState() => _AdminCotizaState();
}

class _AdminCotizaState extends State<AdminCotiza> {
  List<cotiza> cotizas = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        title: const Text("Pedidos"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection("cotizaciones/").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Column(
              children: const [
                Text(
                  "Algo salio mal\n comprueba tu conexion a internet",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.none ||
              snapshot.hasError) {
            return Center(
              child: Column(
                children: [
                  Image.asset(
                    "assets/empty.png",
                    width: 250,
                    height: 250,
                  ),
                  const Text("Hubo un error, intenta de nuevo")
                ],
              ),
            );
          }

          if (snapshot.data!.size == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/empty.png",
                    height: 300,
                    width: 300,
                  ),
                  const Text(
                    "Aun no se han hecho cotizaciones",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ],
              ),
            );
          }
          if (snapshot.hasData) {
            cotizas = obtenerPedidos(snapshot);
          }
          return ListView.builder(
              itemCount: cotizas.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ScreenCotizaInfo(cotizaVer: cotizas[index])));
                  },
                  child: Container(
                      margin: const EdgeInsets.all(15),
                      padding: const EdgeInsets.only(top: 15),
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              cotizas[index].idPedido,
                              style: style1,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Center(
                            child: Text(
                              "Cotiza hecho por:${cotizas[index].infoUsuario.nombre}",
                              style: style1,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: Text(
                              "Fecha de cotiza:${cotizas[index].fechaPedido}",
                              style: style1,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          )
                        ],
                      )),
                );
              });
        },
      ),
    );
  }
}

var style1 = GoogleFonts.yuseiMagic(
    fontSize: 15, fontWeight: FontWeight.bold, color: color4);
var style2 =
    TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color4);
