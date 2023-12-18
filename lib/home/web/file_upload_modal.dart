import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:talk2docs/home/home_page.dart';

class FileUploadModal extends StatefulWidget {
  const FileUploadModal({super.key});

  @override
  _FileUploadModalState createState() => _FileUploadModalState();
}

class _FileUploadModalState extends State<FileUploadModal> {
  List<PlatformFile> selectedFiles = [];

  Future<void> _handleFilePick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf'],
    );

    if (result != null) {
      setState(() {
        selectedFiles.add(result.files.single);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(
          maxWidth: 800,
          maxHeight: 700,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Upload Files',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _handleFilePick();
              },
              child: const Text('Upload Files'),
            ),
            const SizedBox(height: 16),
            DataTable(
              columns: const [
                DataColumn(label: Text('File Name')),
                DataColumn(label: Text('Extension')),
                DataColumn(label: Text('Action')),
              ],
              rows: selectedFiles.map((file) {
                return DataRow(cells: [
                  DataCell(Text(file.name)),
                  DataCell(Text(file.extension ?? '')),
                  DataCell(IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        selectedFiles.remove(file);
                      });
                    },
                  )),
                ]);
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Function to open the file upload modal
void openFileUploadModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const Align(
        alignment: Alignment.center,
        child: FileUploadModal(),
      );
    },
  );
}
