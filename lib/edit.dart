import 'package:flutter/material.dart';
import 'api.dart';
import 'model/place.dart';

class EditPage extends StatefulWidget {
  final Place place;
  const EditPage({super.key, required this.place});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _imageController;
  late TextEditingController _descriptionController;
  late TextEditingController _elevationController;
  late TextEditingController _ratingController;

  String _category = 'mountain';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.place.name);
    _locationController = TextEditingController(text: widget.place.location);
    _imageController = TextEditingController(text: widget.place.image);
    _descriptionController = TextEditingController(text: widget.place.description);
    _elevationController = TextEditingController(text: widget.place.elevation.toString());
    _ratingController = TextEditingController(text: widget.place.rating.toString());
    _category = widget.place.category;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _imageController.dispose();
    _descriptionController.dispose();
    _elevationController.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Tempat'),
        backgroundColor: const Color(0xFF00AAFF),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _field(
              controller: _nameController,
              label: 'Nama Tempat',
              validator: _required,
            ),
            _field(
              controller: _locationController,
              label: 'Lokasi',
              validator: _required,
            ),
            _field(controller: _imageController, label: 'Image URL'),
            _field(
              controller: _descriptionController,
              label: 'Deskripsi',
              maxLines: 3,
              validator: _required,
            ),
            _field(
              controller: _elevationController,
              label: 'Ketinggian (mdpl)',
              type: TextInputType.number,
              validator: _required,
            ),
            _field(
              controller: _ratingController,
              label: 'Rating (1–5)',
              type: TextInputType.number,
              validator: _ratingValidator,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _category,
              items: const [
                DropdownMenuItem(value: 'mountain', child: Text('Mountain')),
                DropdownMenuItem(value: 'hill', child: Text('Hill')),
                DropdownMenuItem(value: 'camp', child: Text('Camp')),
                DropdownMenuItem(value: 'beach', child: Text('Beach')),
              ],
              onChanged: (String? value) {
                if (value != null) setState(() => _category = value);
              },
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00AAFF),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                    : const Text(
                        'Update',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field({
    required final TextEditingController controller,
    required final String label,
    final TextInputType type = TextInputType.text,
    final int maxLines = 1,
    final String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  String? _required(final String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Field tidak boleh kosong';
    }
    return null;
  }

  String? _ratingValidator(final String? value) {
    final int? rating = int.tryParse(value ?? '');
    if (rating == null || rating < 1 || rating > 5) {
      return 'Rating harus 1–5';
    }
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final int? elevation = int.tryParse(_elevationController.text);
    final int? rating = int.tryParse(_ratingController.text);

    if (elevation == null || rating == null) return;

    setState(() => _loading = true);

    final Place updatedPlace = Place(
      id: widget.place.id,
      name: _nameController.text.trim(),
      location: _locationController.text.trim(),
      image: _imageController.text.trim(),
      description: _descriptionController.text.trim(),
      elevation: elevation,
      category: _category,
      rating: rating,
    );

    await ApiService.updatePlace(updatedPlace);

    if (!mounted) return;

    setState(() => _loading = false);

    Navigator.pop(context, true);
  }
}
