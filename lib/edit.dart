import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Place')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _nameController),
            TextField(controller: _locationController),
            ElevatedButton(
              onPressed: () {
                // langsung gunakan controller.text tanpa menyimpan ke variabel lokal
                // contoh: print(_nameController.text);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
