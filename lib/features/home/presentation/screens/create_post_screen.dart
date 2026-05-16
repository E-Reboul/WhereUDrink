import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:where_u_drink/core/widgets/custom_elevated_button.dart';
import 'package:where_u_drink/core/widgets/custom_text_field.dart';
import 'package:where_u_drink/features/home/presentation/screens/location_picker_screen.dart';

class CreatePostScreen extends StatefulWidget {
  final XFile image;

  const CreatePostScreen({
    super.key,
    required this.image,
  });

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();

  final _beverageNameController = TextEditingController();
  final _brandController = TextEditingController();
  final _alcoholDegreeController = TextEditingController();
  final _countryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();

  late final Future<Uint8List> _imageBytes;

  String _beverageType = 'beer';
  String _visibility = 'public';
  PickedLocation? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _imageBytes = widget.image.readAsBytes();
  }

  @override
  void dispose() {
    _beverageNameController.dispose();
    _brandController.dispose();
    _alcoholDegreeController.dispose();
    _countryController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _submitPost() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selectionne un lieu')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post pret a etre publie')),
    );
    Navigator.of(context).pop(true);
  }

  Future<void> _pickLocation() async {
    final location = await Navigator.of(context).push<PickedLocation>(
      MaterialPageRoute(
        builder: (_) => LocationPickerScreen(
          initialLocation: _selectedLocation,
        ),
      ),
    );

    if (location == null || !mounted) {
      return;
    }

    setState(() => _selectedLocation = location);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouveau post'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              _PhotoHeader(imageBytes: _imageBytes),
              const SizedBox(height: 22),
              const _SectionTitle(
                icon: Icons.local_bar_outlined,
                title: 'Alcool',
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _beverageNameController,
                label: 'Nom de la boisson',
                prefixIcon: const Icon(Icons.liquor_outlined),
                validator: _required('Ajoute le nom de la boisson'),
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _brandController,
                      label: 'Marque',
                      prefixIcon: const Icon(Icons.sell_outlined),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _BeverageTypeField(
                      value: _beverageType,
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() => _beverageType = value);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _alcoholDegreeController,
                      label: 'Degre',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      prefixIcon: const Icon(Icons.percent),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d{0,3}([.,]\d{0,2})?$'),
                        ),
                      ],
                      validator: _alcoholDegreeValidator,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      controller: _countryController,
                      label: 'Pays',
                      prefixIcon: const Icon(Icons.public_outlined),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const _SectionTitle(
                icon: Icons.place_outlined,
                title: 'Lieu',
              ),
              const SizedBox(height: 12),
              _LocationField(
                location: _selectedLocation,
                onPressed: _pickLocation,
              ),
              const SizedBox(height: 24),
              const _SectionTitle(
                icon: Icons.article_outlined,
                title: 'Post',
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                minLines: 4,
                maxLines: 6,
                decoration: _inputDecoration(
                  label: 'Description',
                  icon: Icons.notes_outlined,
                ),
                validator: _required('Ajoute une description'),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _tagsController,
                label: 'Tags',
                prefixIcon: const Icon(Icons.tag_outlined),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _visibility,
                decoration: _inputDecoration(
                  label: 'Visibilite',
                  icon: Icons.visibility_outlined,
                ),
                items: const [
                  DropdownMenuItem(value: 'public', child: Text('Public')),
                  DropdownMenuItem(value: 'followers', child: Text('Abonnes')),
                  DropdownMenuItem(value: 'private', child: Text('Prive')),
                ],
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() => _visibility = value);
                },
              ),
              const SizedBox(height: 24),
              CustomElevatedButton(
                text: 'Publier',
                onPressed: _submitPost,
                backgroundColor: WidgetStatePropertyAll(colorScheme.primary),
                foregroundColor: WidgetStatePropertyAll(colorScheme.onPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? Function(String?) _required(String message) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return message;
      }
      return null;
    };
  }

  String? _alcoholDegreeValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final degree = double.tryParse(value.replaceAll(',', '.'));
    if (degree == null || degree < 0 || degree > 100) {
      return 'Degre invalide';
    }

    return null;
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      alignLabelWithHint: true,
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }
}

class _LocationField extends StatelessWidget {
  final PickedLocation? location;
  final VoidCallback onPressed;

  const _LocationField({
    required this.location,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final location = this.location;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onPressed,
      child: Ink(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(
                location == null
                    ? Icons.add_location_alt_outlined
                    : Icons.location_pin,
                color: location == null ? null : Colors.red,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location?.name ?? 'Choisir depuis la carte',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleSmall,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      location == null
                          ? 'Recherche par nom, tap sur la map ou position du telephone'
                          : '${location.latitude.toStringAsFixed(5)}, ${location.longitude.toStringAsFixed(5)}',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhotoHeader extends StatelessWidget {
  final Future<Uint8List> imageBytes;

  const _PhotoHeader({required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox.square(
            dimension: 96,
            child: FutureBuilder<Uint8List>(
              future: imageBytes,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return ColoredBox(
                    color: colorScheme.surfaceContainerHighest,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }

                return Image.memory(
                  snapshot.data!,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            'Complete les informations pour creer le post.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 22),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _BeverageTypeField extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;

  const _BeverageTypeField({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: 'Type',
        prefixIcon: const Icon(Icons.category_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
      items: const [
        DropdownMenuItem(value: 'beer', child: Text('Biere')),
        DropdownMenuItem(value: 'wine', child: Text('Vin')),
        DropdownMenuItem(value: 'cocktail', child: Text('Cocktail')),
        DropdownMenuItem(value: 'spirit', child: Text('Spiritueux')),
        DropdownMenuItem(value: 'cider', child: Text('Cidre')),
        DropdownMenuItem(value: 'other', child: Text('Autre')),
      ],
      onChanged: onChanged,
    );
  }
}
