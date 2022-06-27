import 'package:cloud_firestore/cloud_firestore.dart';

class infoUser {
  String nombre;
  List<String> direccion;
  int numero;

  List<DocumentReference> favorites;

  String geolocation;
  bool suscrito;

  DocumentReference referencia;
  infoUser(this.nombre, this.direccion, this.numero, this.geolocation,
      this.referencia, this.favorites, this.suscrito);
  Map toJson() => {
        'Nombre': nombre,
        'Direccion': direccion,
        'Numero': numero,
        'favorites': favorites,
        'suscrito': suscrito
      };
}

class justGeneralInfo {
  String nombre;
  List<String> direccion;
  int numero;
  String token;

  justGeneralInfo(this.nombre, this.direccion, this.numero, this.token);
  factory justGeneralInfo.fromJson(dynamic json) {
    return justGeneralInfo(json['Nombre'] as String, json['Direccion'],
        json["Numero"] as int, json["token"]);
  }
  Map toJson() => {
        'Nombre': nombre,
        'Direccion': direccion,
        'Numero': numero,
        'token': token
      };
}
