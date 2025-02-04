import 'package:flutter/material.dart';
import 'package:mis_project/base_app_bar.dart';
import 'package:mis_project/services/pdf_service.dart';
import 'package:mis_project/services/thesis_service.dart';
import 'package:mis_project/services/auth_service.dart';

class MyThesis extends StatelessWidget {
  const MyThesis({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(
        title: 'Мој магистерски труд',
        route: '/my_thesis',
      ),
      body: FutureBuilder(
        future: AuthService.getLoggedInUser(),
        builder: (context, userSnapshot) {
          if (!userSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = userSnapshot.data!;
          final thesis = ThesisService.getThesisByStudentId(user.username);

          if (thesis == null) {
            return const Center(
              child: Text('Немате пријавено магистерски труд', style: TextStyle(fontSize: 18)),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildThesisInfoTile('ИД', thesis.id),
                  _buildThesisInfoTile('Студент', "${thesis.studentId} ${thesis.student}"),
                  _buildThesisInfoTile('Датум', thesis.date),
                  _buildThesisInfoTile('Теза', thesis.title),
                  _buildThesisInfoTile('Статус', thesis.status),
                  _buildThesisInfoTile('Согласност од студентот', 'Да'),
                  _buildThesisInfoTile('Пријавена со кредити (180/240)', thesis.credits),
                  _buildDownloadTile('Датотека', thesis.pdfUrl, context),
                  _buildDocumentTile('Документација'),
                  _buildEmptyTile("Преглед"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildThesisInfoTile(String title, String value) {
    return Card(
      color: Colors.blueGrey[50],
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(value, style: TextStyle(fontSize: 18)),
      ),
    );
  }

  Widget _buildDownloadTile(String title, String? pdfUrl,BuildContext context ) {
    return Card(
      color: Colors.blueGrey[50],
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        trailing: pdfUrl != null
            ? IconButton(
          icon: const Icon(Icons.cloud_download_rounded),
          color: Colors.blue,
          onPressed: () async {
            try {
              await PdfService.downloadAndOpenPdf(pdfUrl);
            } catch (e) {
              // Handle error
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error opening PDF: $e')),
              );

            }
          },
        )
            : const Text('не постои', style: TextStyle(fontSize: 14, color: Colors.grey)),
      ),
    );
  }

  Widget _buildDocumentTile(String title) {
    return Card(
      color: Colors.blueGrey[50],
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.cloud_download_rounded),
          color: Colors.blue,
          onPressed: () {
            // Handle document preview
          },
        ),
      ),
    );
  }
}

Widget _buildEmptyTile(String title){
  return Card(
    color: Colors.blueGrey[50],
    elevation: 4,
    margin: const EdgeInsets.symmetric(vertical: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.file_copy_sharp),
        color: Colors.blue,
        onPressed: () {
          // Handle document preview
        },
      ),
    ),
  );


}
