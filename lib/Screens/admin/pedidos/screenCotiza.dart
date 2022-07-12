import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import '../../../clases/pedido.dart';
import '../../../constants.dart';
import '../../../funciones/funciones_firebase.dart';

class ScreenCotizaInfo extends StatefulWidget {
  final cotiza cotizaVer;
  const ScreenCotizaInfo({Key? key, required this.cotizaVer}) : super(key: key);

  @override
  State<ScreenCotizaInfo> createState() => _ScreenCotizaInfoState();
}

class _ScreenCotizaInfoState extends State<ScreenCotizaInfo> {
  int currentStep = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        title: const Text("Informacion de cotiza"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 25,
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            "ID de cotiza",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: color3, width: 2)),
                width: 250,
                child: Text(
                  widget.cotizaVer.idPedido,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 3,
                  softWrap: true,
                ),
              ),
              IconButton(
                onPressed: () {
                  FlutterClipboard.copy(widget.cotizaVer.idPedido)
                      .then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("ID copiado en el portapapeles")));
                  });
                },
                icon: Icon(
                  Icons.copy,
                  semanticLabel: "Copiar",
                  shadows: const [Shadow(color: Colors.black, blurRadius: 1)],
                  color: color3,
                ),
              )
            ],
          )),
          Center(
            child: ListTile(
              leading: Icon(
                Icons.date_range,
                color: color3,
              ),
              title: Text(
                "Fecha del cotiza:",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              subtitle: Text(
                widget.cotizaVer.fechaPedido,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Center(
            child: ListTile(
              leading: Icon(
                Icons.list,
                color: color3,
              ),
              title: Text(
                "Items de la cotiza",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 25, right: 25),
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: color3),
            child: Column(
              children: [
                ...widget.cotizaVer.itemsGenerator1(),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Center(
            child: ListTile(
              leading: Icon(
                Icons.person,
                color: color1,
              ),
              title: Text(
                "Informacion del cliente",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 25, right: 25),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: color3),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.text_fields,
                    color: color1,
                  ),
                  title: Text(
                    "Nombre:  ${widget.cotizaVer.infoUsuario.nombre}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.numbers,
                    color: color1,
                  ),
                  title: Text(
                    "Numero: ${widget.cotizaVer.infoUsuario.numero}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.map,
                    color: color1,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  title: Text(
                    "Direccion: ${widget.cotizaVer.infoUsuario.direccion}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: ListTile(
              leading: Icon(
                Icons.subject,
                color: color3,
              ),
              title: Text(
                "Detalles extras sobre la cotiza",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 25),
            child: ListTile(
              leading: Icon(
                Icons.control_point_rounded,
                color: color3,
              ),
              title: Text(
                "Instrucciones extras del comprador:",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              // subtitle: Text(
              //   // widget.pedidoVer.detallesExtras,
              //   style: style1,
              // ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 25),
            child: ListTile(
              leading: const Icon(
                Icons.percent,
                color: Colors.deepPurple,
                size: 45,
              ),
              title: Text(
                "Cupon utilizado:",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              // subtitle: Text(widget.pedidoVer.cuponUtilizado),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            margin: const EdgeInsets.only(left: 25),
            child: ListTile(
              leading: const Icon(
                Icons.monetization_on,
                color: Colors.green,
                size: 45,
              ),
              title: Text(
                "Total de la cotiza:",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              subtitle: Text(
                widget.cotizaVer.total.toStringAsFixed(2),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          SizedBox(
            height: 450,
            width: 100,
            child: Stepper(
              elevation: 15,
              margin: EdgeInsets.all(15),
              type: StepperType.vertical,
              physics: const BouncingScrollPhysics(),
              currentStep: estadoPedido(),
              steps: steps(),
            ),
          ),
          InkWell(
            onTap: () async {
              final link = WhatsAppUnilink(
                phoneNumber: '504 ${widget.cotizaVer.infoUsuario.numero}',
                text: "Hey ,${widget.cotizaVer.infoUsuario.nombre}",
              );
              String v = "Hey,${widget.cotizaVer.infoUsuario.nombre}";
              String numero = "504${widget.cotizaVer.infoUsuario.numero}";
              await launchUrl(
                  Uri.parse("whatsapp://send?phone=$numero&text=$v"));
            },
            child: Container(
              color: Colors.green.shade100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Escribirle por whatsapp",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const FaIcon(
                    FontAwesomeIcons.whatsapp,
                    color: Colors.green,
                    size: 45,
                  ),
                ],
              ),
            ),
          ),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            primary: true,
            childAspectRatio: 3 / 2,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            padding: const EdgeInsets.all(15),
            children: [
              TextButton.icon(
                  onPressed: () async {
                    await widget.cotizaVer.referencia
                        .update({"enProgreso": true}).then((value) {
                      setState(() {
                        widget.cotizaVer.enProgreso = true;
                      });
                    });
                  },
                  icon: const Icon(Icons.workspaces_filled, color: Colors.blue),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color?>(
                        Colors.yellow.withOpacity(0.8)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder?>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                  ),
                  label: Text(
                    "Poner cotiza como revisada",
                    style: Theme.of(context).textTheme.bodyMedium,
                  )),
              TextButton.icon(
                  onPressed: () async {
                    sendPushMessage(widget.cotizaVer.infoUsuario.nombre,
                        widget.cotizaVer.infoUsuario.token);
                  },
                  icon: const Icon(Icons.check_box, color: Colors.white),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color?>(
                        Colors.green.withOpacity(0.8)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder?>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                  ),
                  label: Text(
                    "Notificar sobre Cotiza confirmada",
                    style: Theme.of(context).textTheme.bodyMedium,
                  )),
              TextButton.icon(
                  onPressed: () async {
                    await widget.cotizaVer.referencia
                        .update({"entregado": true}).then((value) {
                      setState(() {
                        widget.cotizaVer.entregado = true;
                      });
                    });
                  },
                  icon: const Icon(Icons.check_box, color: Colors.white),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color?>(
                        Colors.blue.withOpacity(0.8)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder?>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                  ),
                  label: Text(
                    "Cotiza confirmada",
                    style: Theme.of(context).textTheme.bodyMedium,
                  )),
              TextButton.icon(
                  onPressed: () async {
                    await widget.cotizaVer.referencia.update({
                      "confirmada": false,
                      "revisada": true,
                    }).then((value) {
                      setState(() {
                        widget.cotizaVer.entregado = false;
                        widget.cotizaVer.enProgreso = true;
                      });
                    });
                  },
                  icon: const Icon(Icons.subdirectory_arrow_left_rounded,
                      color: Colors.white),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color?>(
                        Colors.red.withOpacity(0.8)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder?>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                  ),
                  label: Text(
                    "Revertir a revisada",
                    style: Theme.of(context).textTheme.bodyMedium,
                  )),
              TextButton.icon(
                  onPressed: () async {
                    await widget.cotizaVer.referencia.update({
                      "entregado": false,
                      "enProgreso": false,
                      "recibido": true
                    }).then((value) {
                      setState(() {
                        widget.cotizaVer.recibido = true;
                        widget.cotizaVer.enProgreso = false;
                        widget.cotizaVer.entregado = false;
                      });
                    });
                  },
                  icon: const Icon(Icons.subdirectory_arrow_left_rounded,
                      color: Colors.white),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color?>(
                        Colors.red.withOpacity(0.8)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder?>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                  ),
                  label: Text(
                    "Revertir a recibido",
                    style: Theme.of(context).textTheme.bodyMedium,
                  )),
              TextButton.icon(
                  onPressed: () {
                    widget.cotizaVer.referencia.delete();
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color?>(Colors.redAccent),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder?>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                  ),
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Cancelar Cotiza",
                    style: Theme.of(context).textTheme.bodyMedium,
                  )),
            ],
          ),
        ],
      ),
    );
  }

  int estadoPedido() {
    int estado = 0;
    if (widget.cotizaVer.recibido) {
      setState(() {
        estado = 0;
        currentStep = 0;
      });
    }
    if (widget.cotizaVer.enProgreso) {
      setState(() {
        estado = 1;

        currentStep = 1;
      });
    }
    if (widget.cotizaVer.entregado) {
      setState(() {
        estado = 2;

        currentStep = 2;
      });
    }

    return estado;
  }

  List<Step> steps() {
    return [
      Step(
          isActive: currentStep >= 0,
          title: Text(
            "Recibido",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          state: StepState.indexed,
          content: Text(
            "El administrador recibio la cotiza",
            style: Theme.of(context).textTheme.bodyMedium,
          )),
      Step(
          isActive: currentStep >= 1,
          state: StepState.editing,
          title: Text(
            "Revisada",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          content: Text(
            "La cotiza se reviso",
            style: Theme.of(context).textTheme.bodyMedium,
          )),
      Step(
          isActive: currentStep >= 2,
          state: StepState.complete,
          title: Text(
            "Confirmada",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          content: Text(
            "La cotiza fue confirmada",
            style: Theme.of(context).textTheme.bodyMedium,
          )),
    ];
  }
}

var style1 = const TextStyle(
    fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black);
