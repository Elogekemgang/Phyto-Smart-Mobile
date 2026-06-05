import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:phytosmart_mobile/screens/analyse/camerascreen.dart';
import 'package:phytosmart_mobile/screens/navigation/diagnoticscreen.dart';

import '../../models/diagnosis_model.dart';


// ─────────────────────────────────────────────
//  PALETTE
// ─────────────────────────────────────────────//he
const _green1  = Color(0xFF1B5E20);
const _green2  = Color(0xFF2E7D32);
const _green3  = Color(0xFF4CAF50);
const _green4  = Color(0xFFE8F5E9);
const _green5  = Color(0xFFF1F8E9);
const _green6  = Color(0xFFC8E6C9);
const _red1    = Color(0xFFE53935);
const _redBg   = Color(0xFFFFEBEE);
const _amber   = Color(0xFFF9A825);
const _amberBg = Color(0xFFFFFDE7);
const _textDk  = Color(0xFF1A1A1A);
const _textI  = Color(0xFF986400);
const _textMd  = Color(0xFF616161);
const _textLt  = Color(0xFF9E9E9E);

// ─────────────────────────────────────────────
//  RESULTATS SCREEN
// ─────────────────────────────────────────────
class ResultatsScreen extends StatefulWidget {

  DiagnosisModel? diagnosis;
  File? image;

  ResultatsScreen({super.key, this.diagnosis,this
  .image});


  @override
  State<ResultatsScreen> createState() => _ResultatsScreenState();
}

class _ResultatsScreenState extends State<ResultatsScreen> {

  DiagnosisModel? diagnosis;
  File? image;

  @override
  void initState(){
    super.initState();
    diagnosis = widget.diagnosis;
    image = widget.image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: Column(
        children: [
          SafeArea(bottom: false, child: _buildTopBar()),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              physics: const BouncingScrollPhysics(),
              children: [
                _buildMainDetectionCard(),
                const SizedBox(height: 14),
                _buildWarningBanner(),
                const SizedBox(height: 14),
                _buildSymptomsCard(),
                const SizedBox(height: 14),
                _buildTraitementCard(),
                const SizedBox(height: 14),
                _buildConseilsCard(),
                const SizedBox(height: 20),
              ],
            ),
          ),
          _buildBottomButtons(),
        ],
      ),
    );
  }

  // ── TOP BAR ──────────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 8, 12, 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 20, color: _textDk),
            onPressed: () {
              Navigator.pop(context);
            },
            visualDensity: VisualDensity.compact,
          ),
          const Expanded(
            child: Text(
              'Résultats du diagnostic',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: _textDk,
                letterSpacing: -0.2,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.ios_share_outlined,
                size: 22, color: _green2),
            onPressed: () {
              // ressortir le pdf ou faire autre chose comme partager
            },
            visualDensity: VisualDensity.compact,
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz_rounded,
                size: 24, color: _green2),
            onPressed: () {
              // je ne sais pas encore quoi mettre ici
            },
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  // ── CARD 1 : PLANTE + MALADIE + CONFIANCE ────────────────────────────────
  Widget _buildMainDetectionCard() {
    return _Card(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // Photo + infos
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Photo gauche
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(14),
                        //bottomLeft: Radius.circular(14),
                      ),
                      child: SizedBox(
                        width: 168,
                        height: 195,
                        child: Image.file(image!,fit: BoxFit.cover,),
                        /*child: CustomPaint(
                          painter: _MaisRouillePhotoPainter(),
                          child: const SizedBox(height: double.infinity),
                        ),*/
                      ),
                    ),
                    // Overlay "Voir l'image"
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.52),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.crop_free_rounded,
                                color: Colors.white, size: 14),
                            SizedBox(width: 5),
                            Text('Voir l\'image',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Infos droite
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badge "Plante détectée"
                        _SmallBadge(
                            label: 'Plante détectée',
                            bg: _green4,
                            textColor: _green2),
                        const SizedBox(height: 8),
                        Text(diagnosis!.plantName,
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: _textDk,
                                height: 1.1)),
                        Text('(${diagnosis!.plantName})',
                            style: const TextStyle(
                                fontSize: 13,
                                color: _textMd,
                                fontStyle: FontStyle.italic)),
                        const SizedBox(height: 14),
                        // Badge "Maladie détectée"
                        _SmallBadge(
                            label: diagnosis!.diseaseName != "healthy" ? 'Maladie détectée' : "Plante saine",
                            bg:  diagnosis!.diseaseName != "healthy" ? _redBg : _green4,
                            textColor:   diagnosis!.diseaseName != "healthy" ? _red1 : _green3),
                        const SizedBox(height: 8),
                         Text(
                              diagnosis!.diseaseName
                          //'Rouille commune du maïs',
                          ,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: _textDk,
                              height: 1.25),
                        ),
                         Text(
                          ("(${diagnosis!.diseaseName})"),
                          //'(Puccinia sorghi)',
                          style: TextStyle(
                              fontSize: 12,
                              color: _textMd,
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Divider
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),

          // Confiance
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text('Niveau de confiance de l\'IA',
                        style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: _textDk)),
                    const SizedBox(width: 6),
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: _textLt, width: 1.5),
                      ),
                      child: const Center(
                        child: Text('i',
                            style: TextStyle(
                                fontSize: 11,
                                color: _textLt,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const Spacer(),
                         Text(diagnosis!.confidence,
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w900,
                                color: _green2,
                                height: 1.0)),
                  ],
                ),
                const SizedBox(height: 10),
                // Barre de progression
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: (double.tryParse(diagnosis!.confidence.replaceAll('%', ''))! / 100),
                    minHeight: 9,
                    backgroundColor: const Color(0xFFE0E0E0),
                    valueColor:
                    const AlwaysStoppedAnimation<Color>(_green2),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── BANDEAU AVERTISSEMENT ─────────────────────────────────────────────────
  Widget _buildWarningBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _amberBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFECB3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: _amber,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('!',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w900)),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Cette analyse IA ne remplace pas l\'avis d\'un expert agricole.',
              style: TextStyle(
                  fontSize: 11, color: _textI, height: 1.45),
            ),
          ),
        ],
      ),
    );
  }

  // ── SYMPTÔMES DÉTECTÉS ────────────────────────────────────────────────────
  Widget _buildSymptomsCard() {
    const symptoms = [
      //_SymptomData('Taches pustuleuses\norange', _SymptomType.taches),
      _SymptomData('Taches\n orange', _SymptomType.taches),
      _SymptomData('Présence de\npustules', _SymptomType.pustules),
      _SymptomData('Décoloration\ndes feuilles', _SymptomType.decolor),
      _SymptomData('Dessèchement\ndes feuilles', _SymptomType.seche),
    ];

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Symptômes détectés',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: _textDk)),
          const SizedBox(height: 14),
          Row(
            children: symptoms
                .map((s) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: SizedBox(
                        height: 78,
                        child: Image.asset("assets/plantes/mais.jpg",fit: BoxFit.cover,),
                        /*child: CustomPaint(
                          painter:
                          _SymptomPhotoPainter(s.type),
                          child: const SizedBox.expand(),
                        ),*/
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      s.label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        //overflow: TextOverflow.ellipsis,
                          fontSize: 11,
                          color: _textMd,
                          height: 1.35),
                    ),
                  ],
                ),
              ),
            ))
                .toList(),
          ),
        ],
      ),
    );
  }

  // ── TRAITEMENT RECOMMANDÉ ─────────────────────────────────────────────────
  Widget _buildTraitementCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _green5,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _green6, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre
          Row(
            children: [
              SizedBox(
                width: 26,
                height: 26,
                child: Image.asset("assets/images/secure.png"),
              ),
              const SizedBox(width: 8),
              const Text('Traitement recommandé',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: _green2)),
            ],
          ),
          const SizedBox(height: 8),

          // Carte produit + dose
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Produit (gauche, fond blanc)
                  Expanded(
                    flex: 58,
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Flacon
                              SizedBox(
                                width: 65,
                                height: 65,
                                child: Image.asset("assets/produits/fongicide.jpg"),
                                //child: CustomPaint(painter: _FlaconPainter()),
                              ),
                              //const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    const Text('Fongicide recommandé',
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: _textMd)),
                                    const SizedBox(height: 3),
                                    RichText(
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Amistar',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w800,
                                                color: _textDk),
                                          ),
                                          TextSpan(
                                            text: '® Top',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w800,
                                                color: _textDk),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    const Text(
                                      '(Azoxystrobine + Difenoconazole)',
                                      style: TextStyle(
                                          fontSize: 10.5,
                                          color: _textMd,
                                          height: 1.4),
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            ],
                          ),_SmallBadge(
                            label: 'Efficace contre la rouille',
                            bg: _green4,
                            textColor: _green2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Dose (droite, fond vert clair)
                  Expanded(
                    flex: 42,
                    child: Container(
                      color: const Color(0xFFDCEFD8),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Dose recommandée',
                              style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: _green2)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              SizedBox(
                                width: 28,
                                height: 50,
                                child: Image.asset("assets/icons/graduated-cylinder.png",fit: BoxFit.cover,),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  children: [
                                    const Text('1 ml / L d\'eau',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w800,
                                            color: _textDk,
                                            height: 1.2)),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Soit 200 ml pour 200 L d\'eau',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: _textMd,
                                          height: 1.5),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // 3 colonnes : Fréquence / Durée / Moment
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TraitDetail(
                  icon: Icon(Icons.calendar_month,color: _green2),
                  title: 'Fréquence',
                  value: 'Tous les 7 jours',
                ),
                _TraitVertDiv(),
                _TraitDetail(
                  icon: Icon(Icons.access_time,color: _green2),
                  title: 'Durée',
                  value: '2 à 3 applications',
                ),
                _TraitVertDiv(),
                _TraitDetail(
                  icon: Icon(Icons.sunny_snowing,color: _green2,),
                  title: 'Moment',
                  value: 'Matin tôt ou fin d\'après-midi',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── CONSEILS SUPPLÉMENTAIRES ──────────────────────────────────────────────
  Widget _buildConseilsCard() {
    const tips = [
      'Éliminez les feuilles fortement atteintes.',
      'Assurez une bonne aération entre les plants.',
      'Évitez les excès d\'azote.',
      'Utilisez des variétés résistantes si possible.',
    ];

    return _Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Conseils supplémentaires',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: _textDk)),
                const SizedBox(height: 14),
                ...tips.map((t) => Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle_outline_rounded,
                          color: _green3, size: 19),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Text(t,
                            style: const TextStyle(
                                fontSize: 13,
                                color: _textDk,
                                height: 1.45)),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(width: 2),
          // Illustration plante
          Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              //color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Image.asset("assets/images/ecology.png"),
              //child: CustomPaint(painter: _CornPlantIllust()),
            ),
          ),
        ],
      ),
    );
  }

  // ── BOUTONS BAS ───────────────────────────────────────────────────────────
  Widget _buildBottomButtons() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
      child: Row(
        children: [
          // Ajouter à mes tâches
          Expanded(
            child: _OutlineBtn(
              icon: Icons.event_note_outlined,
              label: 'Ajouter à mes tâches',
              onTap: () {},
            ),
          ),
          const SizedBox(width: 8),
          // Sauvegarder
          _OutlineBtn(
            icon: Icons.bookmark_border_rounded,
            label: 'Sauvegarder',
            onTap: () {},
            compact: true,
          ),
          const SizedBox(width: 8),
          // Diagnostiquer à nouveau
          Expanded(
            child: _FilledBtn(
              icon: Icons.camera_alt_outlined,
              label: 'Diagnostiquer à nouveau',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Camerascreen()));
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  REUSABLE WIDGETS
// ─────────────────────────────────────────────

class _Card extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const _Card({required this.child, this.padding});
  @override
  Widget build(BuildContext context) => Container(
    padding: padding ?? const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFF0F0F0), width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.055),
          blurRadius: 16,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: child,
  );
}

class _SmallBadge extends StatelessWidget {
  final String label;
  final Color bg, textColor;
  const _SmallBadge(
      {required this.label, required this.bg, required this.textColor});
  @override
  Widget build(BuildContext context) => Container(
    padding:
    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
        color: bg, borderRadius: BorderRadius.circular(8)),
    child: Text(label,
        style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: textColor)),
  );
}

class _TraitDetail extends StatelessWidget {
  final Widget icon;
  final String title, value;
  const _TraitDetail(
      {required this.icon,
        required this.title,
        required this.value});
  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
            width: 24,
            height: 24,
            child: icon,),
        const SizedBox(height: 6),
        Text(title,
            style: const TextStyle(
                fontSize: 11.5,
                color: _textMd,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 3),
        Text(value,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: _textDk,
                height: 1.4)),
      ],
    ),
  );
}

class _TraitVertDiv extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
      width: 1, height: 80, color: const Color(0xFFE8E8E8));
}

class _OutlineBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool compact;
  const _OutlineBtn(
      {required this.icon,
        required this.label,
        required this.onTap,
        this.compact = false});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      height: 40,
      padding: EdgeInsets.symmetric(
          horizontal: compact ? 12 : 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _green2, width: 1.8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: _green2, size: 17),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: _green2),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );
}

class _FilledBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _FilledBtn(
      {required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: _green2,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 17),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );
}

// ─────────────────────────────────────────────
//  SYMPTOM DATA
// ─────────────────────────────────────────────
enum _SymptomType { taches, pustules, decolor, seche }

class _SymptomData {
  final String label;
  final _SymptomType type;
  const _SymptomData(this.label, this.type);
}

