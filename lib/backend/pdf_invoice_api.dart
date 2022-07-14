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
        buildTotal(invoice, descuento, total),
        SizedBox(height: 35),
        buildDivider(),
        SizedBox(height: 10),
        buildBottomBox(),
        SizedBox(height: 35),
        buildDividerBottom()
      ],
      //footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: 'my_invoice$uuid.pdf', pdf: pdf);
  }
}

Widget buildDivider() {
  return Container(
      width: 0.657 * PdfPageFormat.a4.width,
      height: 5,
      color: PdfColor.fromHex("233142"));
}

Widget buildDividerBottom() {
  return Container(
      width: 0.85 * PdfPageFormat.a4.width,
      height: 5,
      color: PdfColor.fromHex("233142"));
}

Widget buildBottomBox() {
  return Container(
      width: 0.7 * PdfPageFormat.a4.width,
      decoration:
          BoxDecoration(border: Border.all(color: PdfColors.black, width: 1)),
      padding: EdgeInsets.all(20),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Barrio siria calle principal -Tegucigalpa",
            ),
            Text("E-mail: indexahonduras@gmail.com"),
            Text("Teléfono: 2213-3617"),
            Text("Celular: (504)95882120")
          ]));
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
      item.impuesto ? "ISV" : "EXE",
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
  double subtotal = total;
  int cantImpuesto = 0;
  double exe = 0;
  double sub_exe = 0;
  double isv = 0;
  double total2 = 0;
  for (int i = 0; i < invoice.items.length; i++) {
    if (invoice.items[i].impuesto) {
      cantImpuesto++;
    } else {
      exe += invoice.items[i].precio;
    }
  }
  if (cantImpuesto != 0) {
    sub_exe = subtotal - exe;
    isv = (sub_exe * 15) / 100;
  } else {
    sub_exe = 0;
    isv = 0;
  }

  final data2 = [
    [
      "SUBTOTAL",
      subtotal.toStringAsFixed(2),
    ],
    [
      "EXE",
      exe.toStringAsFixed(2),
    ],
    [
      "SUB-EXE",
      sub_exe == 0.toStringAsFixed(2) ? "-" : sub_exe.toStringAsFixed(2)
    ],
    ["ISV", isv == 0.toStringAsFixed(2) ? "-" : isv.toStringAsFixed(2)],
    [
      "TOTAL",
      cantImpuesto == 0
          ? subtotal.toStringAsFixed(2)
          : (subtotal + isv).toStringAsFixed(2),
    ]
  ];

  return Row(
    children: [
      Container(
          width: 300,
          padding: const EdgeInsets.only(bottom: 27, top: 11, left: 5),
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
            cellPadding: EdgeInsets.all(6)),
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
