import 'package:flutter/material.dart';

import '../clases/pedido.dart';

class CotizacionWidget extends StatelessWidget {
  final cotiza cotizaver; //la clase es pedido per es cotiza
  const CotizacionWidget({Key? key, required this.cotizaver}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.redAccent.withOpacity(0.3),
                  blurRadius: 150,
                  spreadRadius: 1,
                  offset: const Offset(-6, 5))
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: 15,
          ),
          Center(
              child: Text(
            "Fecha de tu cotiza: ${cotizaver.fechaPedido}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Estado:"),
              const SizedBox(
                width: 25,
              ),
              Text(textoPedido()),
              CircleAvatar(
                radius: 15,
                backgroundColor: estadoPedido(),
              ),
            ],
          ),
          const Divider(
            thickness: 1,
            color: Colors.black,
          ),
          const SizedBox(
            height: 15,
          ),
          const Text("  Detalles de tus cotiza:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Text(
          //     pedidoVer.detallesExtras,
          //     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "ID cotiza :${cotizaver.idPedido}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const Text("  Productos: "),
          Column(children: itemsGenerator2(cotizaver.itemsDelPedido)),
          const Divider(
            thickness: 0.5,
            color: Colors.black,
          ),
          Center(
              child: Text(
                  "Total de la cotiza:${cotizaver.total.toStringAsFixed(2)}")),
          const SizedBox(
            height: 15,
          )
        ]));
  }

  String textoPedido() {
    String texto = "";
    if (cotizaver.recibido) {
      texto = "recibido";
    }
    if (cotizaver.enProgreso) {
      texto = "en progreso";
    }
    if (cotizaver.entregado) {
      texto = "entregado";
    }
    return texto;
  }

  Color estadoPedido() {
    Color colorestado = Colors.black;
    if (cotizaver.recibido) {
      colorestado = Colors.blue;
    }
    if (cotizaver.enProgreso) {
      colorestado = Colors.yellow;
    }
    if (cotizaver.entregado) {
      colorestado = Colors.green;
    }
    return colorestado;
  }
}
