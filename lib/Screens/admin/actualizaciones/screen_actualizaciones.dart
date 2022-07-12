import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../funciones/funciones_firebase.dart';

class ScreenActualizaciones extends StatefulWidget {
  const ScreenActualizaciones({Key? key}) : super(key: key);

  @override
  State<ScreenActualizaciones> createState() => _ScreenActualizacionesState();
}

class _ScreenActualizacionesState extends State<ScreenActualizaciones> {
  TextEditingController titulo = TextEditingController();
  TextEditingController texto = TextEditingController();
  final key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Anunciar una nueva actualizacion"),
      ),
      body: Form(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(25),
              child: Text(
                "Agrega el texto que quieres que los usuarios reciban",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            TextFormField(
              controller: titulo,
              decoration: InputStyle("titulo a recibir"),
              validator: (v) {
                v!.isEmpty ? "Titulo es requerido" : null;
                return null;
              },
            ),
            const SizedBox(
              height: 35,
            ),
            TextFormField(
              controller: texto,
              decoration: InputStyle("Texto a recibir"),
              validator: (v) {
                v!.isEmpty ? "texto es requerido" : null;
                return null;
              },
            ),
            Container(
              margin: const EdgeInsets.all(50),
              height: 50,
              decoration: BoxDecoration(
                  color: color3, borderRadius: BorderRadius.circular(30)),
              child: IconButton(
                  onPressed: () {
                    sendNotification(titulo.text, texto.text);
                  },
                  icon: const Icon(Icons.arrow_forward_outlined)),
            ),
          ],
        ),
      ),
    );
  }
}
