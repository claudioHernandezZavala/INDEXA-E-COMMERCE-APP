import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var color1 = const Color(0xFFEEF2FF);
// var color2 = const Color(0xFFFF5959);
//var color3 = const Color(0xFFD09D69);
var color3 = const Color(0xFF233142);
var colorwaux = const Color(0xFFF1EDEA);
var color4 = const Color(0xFF676FA3);
//estilos
var styleLetrasAppBar = GoogleFonts.yuseiMagic(
  color: Color(0xFFEEF2FF),
  fontSize: 25,
);
// var estiloLetras18 = GoogleFonts.yuseiMagic(
//     fontSize: 18, fontWeight: FontWeight.bold, color: color4);
// var estiloLetras20 = GoogleFonts.yuseiMagic(
//     fontSize: 20, fontWeight: FontWeight.bold, color: color4);
// var estiloLetras22 = GoogleFonts.yuseiMagic(
//     fontSize: 20, fontWeight: FontWeight.bold, color: color4);
// var estiloLetras25 = GoogleFonts.yuseiMagic(
//     fontSize: 20, fontWeight: FontWeight.bold, color: color4);
// var estiloLetras18Dinero = GoogleFonts.yuseiMagic(
//     fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green);
// //hhhh
InputDecoration InputStyle(String labelText) {
  return InputDecoration(
    labelText: labelText,
    filled: true,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: Colors.black, width: 2),
    ),
    labelStyle: const TextStyle(color: Colors.white, fontSize: 20),
    floatingLabelStyle: const TextStyle(
        color: Colors.black,
        backgroundColor: Colors.transparent,
        fontSize: 25,
        fontWeight: FontWeight.bold),
    fillColor: color3.withOpacity(0.8),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
  );
}

String nombreEmpresa = "INDEXA";
String todasCategorias = "Todas las categorias";
List<DocumentReference> favorites = [];
String logopath = "assets/indexasinfondo.png";
