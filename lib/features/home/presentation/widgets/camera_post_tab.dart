import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:where_u_drink/features/home/presentation/screens/create_post_screen.dart';

class CameraPostTab extends StatefulWidget {
  const CameraPostTab({super.key});

  @override
  State<CameraPostTab> createState() => _CameraPostTabState();
}

class _CameraPostTabState extends State<CameraPostTab> {
  final ImagePicker _picker = ImagePicker();

  XFile? _selectedImage;
  Uint8List? _selectedImageBytes;
  bool _isPickingImage = false;

  Future<void> _takePhoto() async {
    if (_isPickingImage) {
      return;
    }

    setState(() => _isPickingImage = true);

    try {
      final image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (image == null) {
        return;
      }

      final bytes = await image.readAsBytes();
      if (!mounted) {
        return;
      }

      setState(() {
        _selectedImage = image;
        _selectedImageBytes = bytes;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Impossible d ouvrir la camera'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isPickingImage = false);
      }
    }
  }

  Future<void> _validatePhoto() async {
    final image = _selectedImage;
    if (image == null) {
      return;
    }

    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => CreatePostScreen(image: image),
      ),
    );

    if (!mounted || created != true) {
      return;
    }

    setState(() {
      _selectedImage = null;
      _selectedImageBytes = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final imageBytes = _selectedImageBytes;

    if (imageBytes != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.memory(
            imageBytes,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 16,
            right: 16,
            child: SafeArea(
              child: FilledButton.tonalIcon(
                onPressed: _isPickingImage ? null : _takePhoto,
                icon: const Icon(Icons.photo_camera_outlined),
                label: const Text('Reprendre'),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: SafeArea(
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _validatePhoto,
                icon: const Icon(Icons.check),
                label: const Text('Valider'),
              ),
            ),
          ),
        ],
      );
    }

    return ColoredBox(
      color: Colors.black,
      child: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.35),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SizedBox(
                  width: 260,
                  height: 340,
                  child: Icon(
                    Icons.photo_camera_outlined,
                    size: 64,
                    color: colorScheme.onInverseSurface,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 28,
              child: Center(
                child: _CameraShutterButton(
                  isLoading: _isPickingImage,
                  onPressed: _isPickingImage ? null : _takePhoto,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CameraShutterButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const _CameraShutterButton({
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 76,
      child: IconButton(
        style: IconButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          disabledBackgroundColor: Colors.white70,
          disabledForegroundColor: Colors.black54,
          shape: const CircleBorder(),
          side: const BorderSide(color: Colors.white70, width: 5),
        ),
        onPressed: onPressed,
        icon: isLoading
            ? const SizedBox.square(
                dimension: 24,
                child: CircularProgressIndicator(strokeWidth: 3),
              )
            : const Icon(Icons.photo_camera, size: 32),
        tooltip: 'Prendre une photo',
      ),
    );
  }
}
