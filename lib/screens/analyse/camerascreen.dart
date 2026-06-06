import 'dart:io';
import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phytosmart_mobile/screens/analyse/resultatscreen.dart';
import 'package:phytosmart_mobile/screens/analyse/historyscreen.dart';

import '../../models/diagnosis_model.dart';
import '../../services/diagnosis_service.dart';

class Camerascreen extends StatefulWidget {
  final bool autoImportGallery; // <--- Nouvelle option
  const Camerascreen({super.key, this.autoImportGallery = false});

  @override
  State<Camerascreen> createState() => _CamerascreenState();
}

class _CamerascreenState extends State<Camerascreen> with WidgetsBindingObserver {

  //File? image;
  DiagnosisModel? diagnosis;
  bool loading = false;
  final picker = ImagePicker();
  final diagnosisService = DiagnosisService();

  Future pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile == null) return;

    setState(() {
      _capturedImage = pickedFile;

      diagnosis = null;
    });
  }

  Future analyzeImage() async {
    if (_capturedImage == null) return;

    setState(() {
      loading = true;
      diagnosis = null; // On réinitialise l'ancien diagnostic
    });

    try {
      File imageFile = File(_capturedImage!.path);
      final result = await diagnosisService.analyzeImage(imageFile);
      setState(() {
        diagnosis = result;
      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ResultatsScreen(diagnosis: diagnosis,image: imageFile,)));
    } catch (e) {
      // Si le backend renvoie un "warning" ou si la requête échoue,
      // on affiche le message personnalisé de l'IA via un SnackBar.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.orange.shade800, // Couleur d'avertissement
            duration: const Duration(seconds: 4),
          ),
        );
      }
      print(e);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }



  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  int _selectedCameraIndex = 0;
  FlashMode _flashMode = FlashMode.off;
  XFile? _capturedImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Si l'option est activée, on lance la fonction
      if (widget.autoImportGallery) {
       _handleImageSelection(ImageSource.gallery);
      }
    });
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
    if (state == AppLifecycleState.resumed) {
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
      //ResolutionPreset.ultraHigh,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    _cameraController
        ?.initialize()
        .then((_) {
      if (!mounted) return;
      _cameraController?.setFlashMode(_flashMode);
      setState(() {});
    })
        .catchError((e) {
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

  Future<void> _handleImageSelection(ImageSource? source) async {
    XFile? pickedFile;

    if (source != null) {
      // Cas : Caméra ou Galerie
      final permission = (source == ImageSource.gallery)
          ? await Permission.photos.request()
          : await Permission.camera.request();

      if (permission != PermissionStatus.granted) return;

      if (source == ImageSource.camera) {
        if (_cameraController == null || !_cameraController!.value.isInitialized) return;
        pickedFile = await _cameraController!.takePicture();
      } else {
        pickedFile = await ImagePicker().pickImage(source: source);
      }
    } else {
      // Cas : FilePicker (autre type de fichier)
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null) {
        pickedFile = XFile(result.files.single.path!);
      }
    }

    // Traitement final commun
    if (pickedFile != null) {
      await _cameraController?.pausePreview();
      setState(() {
        _capturedImage = pickedFile;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image prête pour analyse')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        title: Column(
          children: [
            const Text('Capture'),
            // Texte principal
            //const Text('Prenez une photo claire de la plante', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoriqueScreen()),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                spacing: 5,
                children: [
                  Icon(Icons.history, size: 15),
                  Text("historiques", style: TextStyle(fontSize: 11)),
                ],
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF2E7D32),
        elevation: 0,
        centerTitle: true,
      ),


      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb,
                    color: Colors.yellowAccent.shade700,
                    size: 30,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Conseil :",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade900,
                            ),
                          ),
                          TextSpan(
                            text:
                            ' Prenez une photo nette de la feuille, de la tache ou de la partie malade pour un meilleur diagnostic.',
                            style: TextStyle(fontSize: 11, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Zone photo / caméra (style Maïs)
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
                  // Aperçu caméra ou image capturée
                  SizedBox(
                    //height: 520,
                    //width: double.infinity,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: _capturedImage != null ? Image.file(
                            File(_capturedImage!.path),
                            //fit: BoxFit.cover,
                            //width: double.infinity,
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
                                  Icon(
                                    Icons.camera_alt,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 8),
                                  Text('Caméra non disponible',),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if ( _capturedImage == null )... [
                          Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              /*_buildActionButton(
                                icon: Icons.help_outline,
                                label: 'Aide',
                                onPressed: _showHelpDialog,
                              ),*/
                              _buildActionButton(
                                icon: Icons.flip_camera_android,
                                label: 'Retourner',
                                onPressed: _switchCamera,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 20, // Distance par rapport au bas du Stack
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Column(
                              children: [
                                IconButton(
                                  onPressed: (){_handleImageSelection(ImageSource.camera);},
                                  icon: Icon(
                                    Icons.camera_alt_rounded,
                                    color: const Color(0xFF2E7D32),
                                    size: 40,
                                  ),
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.grey.shade100,
                                    shape: const CircleBorder(),
                                  ),
                                ),
                                Text(
                                  "Capture",
                                  style: const TextStyle(fontSize: 12,color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          //top: 0,
                          right: 0,
                          left: 0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    IconButton(
                                      //onPressed:  pickImage(ImageSource.gallery) ,
                                      onPressed: (){_handleImageSelection(null);},
                                      icon: Icon(
                                        Icons.filter,
                                        color: const Color(0xFF2E7D32),
                                        size: 20,
                                      ),
                                      style: IconButton.styleFrom(
                                        backgroundColor: Colors.grey.shade100,
                                        shape: const CircleBorder(),
                                      ),
                                    ),
                                    Text(
                                      "Importer",
                                      style: const TextStyle(fontSize: 12,color: Colors.white),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 30),
                                //Spacer(),
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: (){_handleImageSelection(ImageSource.gallery);},
                                      icon: Icon(
                                        Icons.image_outlined,
                                        color: const Color(0xFF2E7D32),
                                        size: 20,
                                      ),
                                      style: IconButton.styleFrom(
                                        backgroundColor: Colors.grey.shade100,
                                        shape: const CircleBorder(),
                                      ),
                                    ),
                                    Text(
                                      "Galerie",
                                      style: const TextStyle(fontSize: 12,color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),],

                          if ( _capturedImage != null ) ... [

                            Positioned(
                              bottom: 20, // Distance par rapport au bas du Stack
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Column(
                                  children: [
                                    IconButton(
                                      onPressed: analyzeImage,
                                      icon: Icon(
                                        Icons.check_circle_rounded,
                                        color: const Color(0xFF2E7D32),
                                        size: 40,
                                      ),
                                      style: IconButton.styleFrom(
                                        backgroundColor: Colors.grey.shade100,
                                        shape: const CircleBorder(),
                                      ),
                                    ),
                                    Text(
                                      "Analyser",
                                      style: const TextStyle(fontSize: 12,color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              //top: 0,
                              right: 0,
                              left: 0,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        IconButton(
                                          onPressed: (){_handleImageSelection(ImageSource.gallery);},
                                          icon: Icon(
                                            Icons.filter,
                                            color: const Color(0xFF2E7D32),
                                            size: 20,
                                          ),
                                          style: IconButton.styleFrom(
                                            backgroundColor: Colors.grey.shade100,
                                            shape: const CircleBorder(),
                                          ),
                                        ),
                                        Text(
                                          "Importer",
                                          style: const TextStyle(fontSize: 12,color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 30),
                                    //Spacer(),
                                    Column(
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            setState(() {
                                              _capturedImage = null;
                                            });
                                            if (_cameraController != null && _cameraController!.value.isInitialized) {
                                              await _cameraController!.resumePreview();
                                            }
                                          },
                                          icon: Icon(
                                            Icons.refresh,
                                            color: const Color(0xFF2E7D32),
                                            size: 20,
                                          ),
                                          style: IconButton.styleFrom(
                                            backgroundColor: Colors.grey.shade100,
                                            shape: const CircleBorder(),
                                          ),
                                        ),
                                        Text(
                                          "Reessayer",
                                          style: const TextStyle(fontSize: 12,color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          ]

                        ]

                    ),
                  ),


                  //const SizedBox(height: 12),

                  // Boutons Importer / Galerie
                  //const SizedBox(height: 16),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Choix partie de la plante
            /*const Text(
              'Plantes prises en compte par notre diagnostic',
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
            ),*/

            //const SizedBox(height: 32),

            // Mode hors ligne
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mode hors ligne',
                          style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF1B5E20),
                              height: 1.3,
                              fontWeight: FontWeight.bold
                          ),
                        ),Text(
                          'Vos images seront sauvegardées et analysées lorsque vous serez connecté.',
                          style: const TextStyle(
                            fontSize: 11,
                            //color: Color(0xFF1B5E20),
                            height: 1.3,
                          ),
                        ),
                      ],
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
          icon: Icon(icon, color: Colors.white),
          style: IconButton.styleFrom(
            backgroundColor: Colors.grey.shade800.withOpacity(.3),
            shape: const CircleBorder(),
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12,color: Colors.white)),
      ],
    );
  }

}
