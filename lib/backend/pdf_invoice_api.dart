import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:indexa/backend/pdfApi.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../clases/invoices/invoiceClass.dart';

class PdfInvoiceApi {
  static Future<File> generate(
      Invoice invoice, double descuento, double total, String uuid) async {
    final pdf = Document();
    Widget header = await buildHeader(invoice);

    pdf.addPage(MultiPage(
      build: (context) => [
        SizedBox(height: 25),
        header,
        SizedBox(height: 35),
        buildInvoice(invoice),
        buildTotal(invoice, descuento, total)
      ],
      //footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: 'my_invoice$uuid.pdf', pdf: pdf);
  }
}

Future<Widget> buildHeader(Invoice invoice) async {
  final ByteData bytes = await rootBundle.load('assets/logoINDEXA.jpg');
  final Uint8List byteList = bytes.buffer.asUint8List();

  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Center(
      child: Image(MemoryImage(byteList), width: 200, height: 200),
    ),
    SizedBox(height: 25),
    Row(children: [
      Text("Fecha ",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      Text(invoice.invoiceInfo.invoiceDate.toString(),
          style: const TextStyle(fontSize: 18)),
    ]),
    Row(children: [
      Text("Empresa: ",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      Text(invoice.customerInfo.nombre, style: const TextStyle(fontSize: 18)),
    ]),
    Row(children: [
      Text("RTN: ",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      Text('-', style: const TextStyle(fontSize: 18)),
    ]),
  ]);
}

Widget buildInvoice(Invoice invoice) {
  final headers = ['CANT', 'DESCRIPCION', 'ISV', 'V/U', 'TOTAL'];
  final data = invoice.items.map((item) {
    final total = item.precio * item.cantidad;
    return [
      '${item.cantidad}',
      item.nombre,
      "ISV",
      (item.precio.toStringAsFixed(2)),
      (total.toStringAsFixed(2))
    ];
  }).toList();
  return Table.fromTextArray(
    headers: headers,
    data: data,
    cellStyle: const TextStyle(fontSize: 18, color: PdfColors.black),
    headerDecoration: BoxDecoration(
      color: PdfColor.fromHex("150B76"),
    ),
    headerStyle: const TextStyle(fontSize: 18, color: PdfColors.white),
    cellHeight: 30,
  );
}

Widget buildTotal(Invoice invoice, double descuento, double total) {
  final data2 = [
    [
      "SUBTOTAL",
      total.toStringAsFixed(2),
    ],
    [
      "EXE",
      15.toStringAsFixed(2),
    ],
    [
      "SUB-T",
      (total - 10).toStringAsFixed(2),
    ],
    [
      "ISV",
      5.toStringAsFixed(2),
    ],
    [
      "TOTAL",
      (total + 5).toStringAsFixed(2),
    ]
  ];
  final datatexto = [
    ["COTIZACIÓN VALIDA POR 3 DÍAS"],
    ["CRÉDITO 30 DÍAS HÁBILES"],
    ["ENTREGA GRATUITA A SU OFICINA (VALIDO PARA TEGUCIGALPA)"],
    ["NO SE ACEPTAN DEVOLUCIONES"]
  ];

  return Row(
    children: [
      Container(
          width: 328,
          padding: const EdgeInsets.only(bottom: 25, top: 4, left: 5),
          decoration: BoxDecoration(
            border: Border.all(
              color: PdfColors.black,
              width: 1,
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("COTIZACIÓN VALIDA POR 3 DÍAS", style: style),
              Text("CRÉDITO 30 DÍAS HÁBILES", style: style),
              Text("ENTREGA GRATUITA A SU OFICINA (VALIDO PARA TEGUCIGALPA)",
                  style: style),
              Text("NO SE ACEPTAN DEVOLUCIONES", style: style),
            ],
          )),
      Expanded(
        flex: 4,
        child: Table.fromTextArray(
          cellAlignment: Alignment.center,
          data: data2,
          headerCount: 2,
        ),
      ),

      /*
      Expanded(
        flex: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildText(
              title: 'Sub-total',
              value: '${total.toStringAsFixed(2)} Lps.',
              unite: true,
            ),
            buildText(
              title: 'Descuento',
              value: '- ${descuento.toStringAsFixed(2)} Lps.',
              unite: true,
            ),
            Divider(),
            buildText(
              title: 'Total',
              titleStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              value: '${(total).toStringAsFixed(2)} Lps.',
              unite: true,
            ),
            SizedBox(height: 2 * PdfPageFormat.mm),
            Container(height: 1, color: PdfColors.grey400),
            SizedBox(height: 0.5 * PdfPageFormat.mm),
            Container(height: 1, color: PdfColors.grey400),
          ],
        ),
      ),

       */
    ],
  );
}

final style = TextStyle(fontWeight: FontWeight.bold, fontSize: 15);
buildText({
  required String title,
  required String value,
  double width = double.infinity,
  TextStyle? titleStyle,
  bool unite = false,
}) {
  final style =
      titleStyle ?? TextStyle(fontWeight: FontWeight.bold, fontSize: 15);

  return Container(
    width: width,
    child: Row(
      children: [
        Expanded(child: Text(title, style: style)),
        Text(value, style: unite ? style : null),
      ],
    ),
  );
}
