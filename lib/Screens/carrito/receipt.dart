import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ticket_widget/ticket_widget.dart';

import '../../backend/pdf_invoice_api.dart';
import '../../clases/ItemCarrito.dart';
import '../../clases/invoices/customerInfo.dart';
import '../../clases/invoices/invoiceClass.dart';
import '../../constants.dart';
import '../../usuario/infoUsuario.dart';
import '../../widgets/leavesFall.dart';
import '../homepage.dart';

class Recibo extends StatefulWidget {
  final double descuento;
  final double total;
  final String cupon;

  final justGeneralInfo info;
  final String idPedido;
  final List<ItemsCarrito> items;
  final String extra;
  const Recibo(
      {Key? key,
      required this.descuento,
      required this.total,
      required this.cupon,
      required this.info,
      required this.idPedido,
      required this.items,
      required this.extra})
      : super(key: key);

  @override
  State<Recibo> createState() => _ReciboState();
}

class _ReciboState extends State<Recibo> {
  List<invoiceItem> invoiceItems = [];
  late File pdfForEmail;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var element in widget.items) {
      invoiceItems.add(invoiceItem(
          nombre: element.nombre,
          cantidad: element.cantidadProducto,
          precio: element.precio,
          impuesto: element.impuesto));
    }
    for (var element in widget.items) {
      element.referenciaItemCarrito.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: color4,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (ctx) => const HomePage()),
                      (route) => false);
                },
                icon: const Icon(Icons.home))
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color?>(color3)),
                    onPressed: () async {
                      generatePDF();
                    },
                    child: const Text(
                      "Descargar cotizacion en pdf",
                      style: TextStyle(color: Colors.white),
                    )),
                TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color?>(color3)),
                    onPressed: () async {
                      Email email;
                      Invoice invoice;
                      invoice = Invoice(
                          descuento: widget.descuento,
                          customerInfo: Customer(
                              Direccion: "Direccion: ${widget.info.direccion}",
                              nombre: widget.info.nombre),
                          items: invoiceItems,
                          invoiceInfo: InvoiceInfo(
                              extraDescription: widget.extra,
                              invoiceDate: DateTime.now(),
                              dueDate: DateTime.now(),
                              invoiceId: widget.idPedido));
                      PdfInvoiceApi.generate(invoice, widget.descuento,
                              widget.total, widget.idPedido)
                          .then((value) async {
                        email = Email(
                          body:
                              'Buen dia,en el presente correo se adjunta cotizacion generada por correo.\n\nEl id de esta cotiza es: ${widget.idPedido}.\nLas cotizaciones deben ser confirmadas antes de poder ser aprobadas por su parte debido a posibles precios no actualizados',
                          subject: 'Cotizacion INDEXA app',
                          recipients: [
                            '${FirebaseAuth.instance.currentUser?.email}'
                          ],
                          attachmentPaths: [(value.path)],
                          isHTML: true,
                        );
                        await FlutterEmailSender.send(email);
                      }).whenComplete(() async {
                        Fluttertoast.showToast(
                            msg: "PDF descargado en carpeta descargas",
                            backgroundColor: Colors.green);
                      });
                    },
                    child: const Text(
                      "Mandar cotiza a mi correo",
                      style: TextStyle(color: Colors.white),
                    )),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "Gracias por cotizar!",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 25,
                ),
                Center(
                  child: TicketWidget(
                    width: 350,
                    height: 550,
                    color: colorwaux,
                    isCornerRounded: true,
                    child: Stack(
                      children: [
                        const LeavesContainer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  logopath,
                                  width: 150,
                                  height: 120,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 25),
                              child: Text(
                                "Resumen de cotización",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 23),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5, left: 25),
                              child: Text(
                                widget.idPedido,
                              ),
                            ),
                            const SizedBox(
                              height: 35,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Divider(
                                color: Colors.black,
                                thickness: 0.5,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 40, top: 25),
                              child: Text(
                                "Cliente",
                                style: style,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 40, top: 10),
                              child: Text(
                                widget.info.nombre,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 40, top: 25),
                              child: Text(
                                "Total de cotiza",
                                style: style,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 40, top: 10),
                              child: Text(
                                "Lps. ${widget.total.toStringAsFixed(2)}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void generatePDF() async {
    File v;
    Invoice invoice;
    invoice = Invoice(
        descuento: widget.descuento,
        customerInfo: Customer(
            Direccion: "Direccion: ${widget.info.direccion}",
            nombre: widget.info.nombre),
        items: invoiceItems,
        invoiceInfo: InvoiceInfo(
            extraDescription: widget.extra,
            invoiceDate: DateTime.now(),
            dueDate: DateTime.now(),
            invoiceId: widget.idPedido));
    PdfInvoiceApi.generate(
            invoice, widget.descuento, widget.total, widget.idPedido)
        .then((value) {
      v = value;
    }).whenComplete(() {
      Fluttertoast.showToast(
          msg: "PDF descargado en carpeta descargas",
          backgroundColor: Colors.green);
    });
  }
}

var style = GoogleFonts.yuseiMagic(color: color4, fontSize: 18);
var styleSubtitulo = GoogleFonts.yuseiMagic(
    color: color4, fontSize: 10, fontStyle: FontStyle.italic);
/*
 mostrar
              ? Expanded(child: SfPdfViewer.file(pdf))
              : Center(
                  child: FlatButton(
                    onPressed: () async {
                      List<invoiceItem> invoiceItems = [];
                      items.forEach((element) {
                        invoiceItems.add(invoiceItem(
                            nombre: element.nombre,
                            cantidad: element.cantidadProducto,
                            precio: element.precio));
                      });
                      Invoice invoice;
                      invoice = Invoice(
                          descuento: 25,
                          customerInfo: Customer(
                              Direccion: "Reparto por bajo",
                              RTN: '0801200212708'),
                          items: invoiceItems,
                          invoiceInfo: InvoiceInfo(
                              extraDescription: 'nooow',
                              invoiceDate: DateTime.now(),
                              dueDate: DateTime.now(),
                              invoiceId: '454213512'));

                      pdf = await PdfInvoiceApi.generate(
                          invoice, widget.descuento, widget.total);
                      if (pdf != null) {
                        setState(() {
                          mostrar = true;
                        });
                      } else {
                        print("vacio");
                      }
                    },
                    child: Text("generar"),
                  ),
                ),
 */
