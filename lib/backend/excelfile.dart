import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

void createAndSaveExcel() async {
  final Workbook workbook = new Workbook();

  final List<int> bytes = workbook.saveAsStream();
  workbook.dispose();
  final String path = (await getApplicationDocumentsDirectory()).path;
  Directory generalDownloadDir = Directory('/storage/emulated/0/Download');
  final String filename = '${generalDownloadDir.path}/cotiza.xlsx';
  //
  final File file = File(filename);
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    PermissionStatus v = await Permission.storage.request();
    if (v.isGranted) {
      await file.writeAsBytes(bytes);
    } else {
      PermissionStatus v = await Permission.storage.request();
    }
  } else {
    await file.writeAsBytes(bytes);
  }
  //await file.writeAsBytes(bytes, flush: true);
  //OpenFile.open(filename);

//Dispose the workbook.
}
