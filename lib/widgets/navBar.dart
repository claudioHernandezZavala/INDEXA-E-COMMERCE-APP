import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../Screens/admin/panel_general.dart';
import '../bounciPageRoute.dart';
import '../constants.dart';
import '../usuario/pedidos.dart';

Widget adminTile(BuildContext context) {
  if (FirebaseAuth.instance.currentUser != null &&
      (FirebaseAuth.instance.currentUser?.email == "claudio.ahz123@gmail.com" ||
          FirebaseAuth.instance.currentUser?.email ==
              "adminprueba@gmail.com")) {
    return Container(
      color: color3,
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(BouncyPageRoute(const PanelGeneral()));
        },
        title: Text(
          "Admin panel",
          style: style(),
        ),
        leading: const Icon(
          Icons.style,
          color: Colors.white,
        ),
      ),
    );
  } else {
    return const SizedBox();
  }
}

Widget pedidosTile(BuildContext context) {
  if (FirebaseAuth.instance.currentUser != null) {
    return Container(
      color: color3,
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: const Icon(
          Icons.assignment,
          color: Colors.white,
        ),
        onTap: () {
          Navigator.of(context).push(BouncyPageRoute(const Pedidos()));
        },
        title: Text(
          "Mis Cotizaciones",
          style: style(),
        ),
      ),
    );
  } else {
    return const SizedBox();
  }
}

Drawer drawer(BuildContext context) {
  return Drawer(
    backgroundColor: color1,
    child: ListView(
      children: [
        const SizedBox(
          height: 45,
        ),
        pedidosTile(context),
        Container(
          color: color3,
          margin: const EdgeInsets.only(bottom: 15),
          child: ListTile(
            leading: const Icon(
              Icons.book,
              color: Colors.white,
            ),
            onTap: () {
              // Navigator.of(context)
              //     .push(BouncyPageRoute(const registerProcess()));
            },
            title: Text(
              "Terminos y servicios",
              style: style(),
            ),
          ),
        ),
        Container(
          color: color3,
          margin: const EdgeInsets.only(bottom: 15),
          child: ListTile(
            leading: const FaIcon(
              FontAwesomeIcons.instagram,
              color: Colors.white,
            ),
            onTap: () {
              launchUrlString("https://www.instagram.com/icma_cz/",
                  mode: LaunchMode.externalApplication);
            },
            title: Text(
              "Visitanos en Instagram",
              style: style(),
            ),
          ),
        ),
        Container(
          color: color3,
          margin: const EdgeInsets.only(bottom: 15),
          child: ListTile(
            leading: const FaIcon(
              FontAwesomeIcons.facebook,
              color: Colors.white,
            ),
            onTap: () {
              launchUrlString(
                  "https://www.facebook.com/profile.php?id=100071020345077",
                  mode: LaunchMode.externalApplication);
            },
            title: Text(
              "Visitanos en Facebook",
              style: style(),
            ),
          ),
        ),
        adminTile(context),
      ],
    ),
  );
}

TextStyle style() {
  return const TextStyle(color: Colors.white);
}
