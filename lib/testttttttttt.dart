import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class DiagnosticScreen extends StatefulWidget {
  const DiagnosticScreen({super.key});

  @override
  State<DiagnosticScreen> createState() => _DiagnosticScreenState();
}

class _DiagnosticScreenState extends State<DiagnosticScreen>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  int _selectedCameraIndex = 0;
  FlashMode _flashMode = FlashMode.off;
  XFile? _capturedImage;
  String _selectedPart = 'Feuille';
  bool _isCameraActive = true; // Nouveau : gère si caméra active ou preview

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _isCameraActive) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    final cameraPermission = await Permission.camera.request();
    if (cameraPermission != PermissionStatus.granted) {
      return;
    }

    final cameras = await availableCameras();
    if (cameras.isEmpty) return;
    _cameras = cameras;
    _selectedCameraIndex = 0;
    _initCameraController(cameras[_selectedCameraIndex]);
  }

  void _initCameraController(CameraDescription cameraDescription) {
    if (_cameraController != null) {
      _cameraController?.dispose();
    }
    _cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    _cameraController?.initialize().then((_) {
      if (!mounted) return;
      _cameraController?.setFlashMode(_flashMode);
      setState(() {});
    }).catchError((e) {
      debugPrint('Erreur caméra: $e');
    });
  }

  void _toggleFlash() {
    if (_cameraController == null) return;
    setState(() {
      if (_flashMode == FlashMode.off) {
        _flashMode = FlashMode.torch;
      } else if (_flashMode == FlashMode.torch) {
        _flashMode = FlashMode.auto;
      } else if (_flashMode == FlashMode.auto) {
        _flashMode = FlashMode.always;
      } else {
        _flashMode = FlashMode.off;
      }
      _cameraController?.setFlashMode(_flashMode);
    });
  }

  void _switchCamera() {
    if (_cameras == null || _cameras!.length < 2) return;
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras!.length;
    _initCameraController(_cameras![_selectedCameraIndex]);
  }

  Future<void> _takePicture() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    try {
      final XFile picture = await _cameraController!.takePicture();

      // Désactiver la caméra immédiatement
      await _cameraController?.dispose();
      _cameraController = null;

      setState(() {
        _capturedImage = picture;
        _isCameraActive = false; // Basculer en mode preview photo
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Photo prise avec succès !')),
      );
    } catch (e) {
      debugPrint('Erreur capture: $e');
    }
  }

  Future<void> _importFromGallery() async {
    final galleryPermission = await Permission.photos.request();
    if (galleryPermission != PermissionStatus.granted) {
      return;
    }
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      // Désactiver la caméra si active
      if (_cameraController != null) {
        await _cameraController?.dispose();
        _cameraController = null;
      }

      setState(() {
        _capturedImage = picked;
        _isCameraActive = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image importée de la galerie')),
      );
    }
  }

  void _retakePhoto() {
    // Réinitialiser et réactiver la caméra
    setState(() {
      _capturedImage = null;
      _isCameraActive = true;
    });
    _initCamera(); // Recréer la caméra
  }

  Future<void> _validateAndAnalyze() async {
    if (_capturedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucune photo à analyser')),
      );
      return;
    }

    // Afficher un dialog de chargement
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Analyse en cours...'),
              ],
            ),
          ),
        ),
      ),
    );

    // Simuler une analyse (à remplacer par votre API réelle)
    await Future.delayed(const Duration(seconds: 2));

    // Fermer le dialog
    if (mounted) Navigator.pop(context);

    // Afficher les résultats (exemple)
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Résultat du diagnostic'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🔍 Partie analysée : $_selectedPart'),
              const SizedBox(height: 8),
              const Text('✅ Statut : Aucune maladie détectée'),
              const SizedBox(height: 8),
              const Text('💡 Recommandation :'),
              const Text('  • Maintenir un arrosage régulier'),
              const Text('  • Surveiller l\'apparition de nouvelles taches'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fermer le dialog résultat
                Navigator.pop(context); // Retour à l'accueil ou reset
              },
              child: const Text('Fermer'),
            ),
          ],
        ),
      );
    }
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Conseils de diagnostic'),
        content: const Text(
          '• Cadrez bien la partie malade (feuille, tige, fruit…)\n'
              '• Éclairez suffisamment la zone\n'
              '• Évitez le bougé pour une photo nette\n'
              '• Si besoin, utilisez le flash',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        title: const Text('Diagnostic'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF2E7D32),
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Nettoyer la caméra avant de quitter
            _cameraController?.dispose();
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Texte principal
            const Text(
              'Prenez une photo claire de la plante',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb, color: Colors.blue.shade700, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Conseil : Prenez une photo nette de la feuille, de la tache ou de la partie malade pour un meilleur diagnostic.',
                      style: TextStyle(fontSize: 13, color: Colors.blue.shade900),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Zone photo / caméra
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 16, top: 12),
                    child: Text(
                      'Maïs',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Aperçu caméra OU photo prise
                  SizedBox(
                    height: 300,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: _capturedImage != null
                          ? Image.file(
                        File(_capturedImage!.path),
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )
                          : (_cameraController != null &&
                          _cameraController!.value.isInitialized)
                          ? CameraPreview(_cameraController!)
                          : Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.camera_alt,
                                  size: 50, color: Colors.grey),
                              SizedBox(height: 8),
                              Text('Caméra non disponible'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Si caméra active : afficher Flash/Aide/Retourner/Importer/Galerie
                  if (_isCameraActive && _capturedImage == null) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton(
                            icon: _flashMode == FlashMode.off
                                ? Icons.flash_off
                                : (_flashMode == FlashMode.torch
                                ? Icons.flash_on
                                : (_flashMode == FlashMode.auto
                                ? Icons.flash_auto
                                : Icons.flash_on)),
                            label: 'Flash',
                            onPressed: _toggleFlash,
                          ),
                          _buildActionButton(
                            icon: Icons.help_outline,
                            label: 'Aide',
                            onPressed: _showHelpDialog,
                          ),
                          _buildActionButton(
                            icon: Icons.flip_camera_android,
                            label: 'Retourner',
                            onPressed: _switchCamera,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Cadrez la partie malade de la plante',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _takePicture,
                              icon: const Icon(Icons.camera_alt),
                              label: const Text('Prendre photo'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E7D32),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _importFromGallery,
                              icon: const Icon(Icons.photo_library),
                              label: const Text('Galerie'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF2E7D32),
                                side: const BorderSide(color: Color(0xFF2E7D32)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Si photo prise : afficher Refilmer et Valider
                  if (!_isCameraActive && _capturedImage != null) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _retakePhoto,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Refilmer'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.grey.shade700,
                                side: BorderSide(color: Colors.grey.shade400),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _validateAndAnalyze,
                              icon: const Icon(Icons.check_circle),
                              label: const Text('Valider'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E7D32),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Choix partie de la plante (toujours visible)
            const Text(
              'Choisissez ce que vous voulez diagnostiquer',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildPartChip('Feuille'),
                _buildPartChip('Fruit'),
                _buildPartChip('Tige'),
                _buildPartChip('Fleur'),
                _buildPartChip('Racine'),
                _buildPartChip('Plante entière'),
              ],
            ),

            const SizedBox(height: 32),

            // Mode hors ligne
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F8E9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFC8E6C9)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.signal_wifi_off, color: Color(0xFF2E7D32)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Mode hors ligne\nVos images seront sauvegardées et analysées lorsque vous serez connecté.',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF1B5E20),
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon, color: const Color(0xFF2E7D32)),
          style: IconButton.styleFrom(
            backgroundColor: Colors.grey.shade100,
            shape: const CircleBorder(),
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildPartChip(String label) {
    final isSelected = _selectedPart == label;
    return FilterChip(
      selected: isSelected,
      label: Text(label),
      onSelected: (selected) {
        setState(() {
          _selectedPart = label;
        });
      },
      backgroundColor: Colors.grey.shade100,
      selectedColor: const Color(0xFFC8E6C9),
      checkmarkColor: const Color(0xFF2E7D32),
      labelStyle: TextStyle(
        color: isSelected ? const Color(0xFF1B5E20) : Colors.grey.shade800,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      shape: StadiumBorder(
        side: isSelected
            ? BorderSide.none
            : BorderSide(color: Colors.grey.shade300),
      ),
    );
  }
}