import 'dart:math' as math;
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
//  PALETTE
// ─────────────────────────────────────────────
const _green1 = Color(0xFF1B5E20);
const _green2 = Color(0xFF2E7D32);
const _green3 = Color(0xFF4CAF50);
const _green4 = Color(0xFFE8F5E9);
const _green5 = Color(0xFFF1F8E9);
const _green6 = Color(0xFFC8E6C9);
const _greenFd = Color(0xFFD0EAD0); // feuilles décoratives fades
const _textDk = Color(0xFF1A1A1A);
const _textMd = Color(0xFF616161);
const _textLt = Color(0xFF9E9E9E);
const _grayCirc = Color(0xFFE0E0E0);
const _grayIcon = Color(0xFFBDBDBD);

// ─────────────────────────────────────────────
//  SCREEN
// ─────────────────────────────────────────────
class AnalyseIAScreen extends StatefulWidget {
  const AnalyseIAScreen({super.key});
  @override
  State<AnalyseIAScreen> createState() => _AnalyseIAScreenState();
}

class _AnalyseIAScreenState extends State<AnalyseIAScreen>
    with TickerProviderStateMixin {
  // Spinner pour l'étape "En cours"
  late final AnimationController _spinCtrl;
  late final Animation<double> _spinAnim;

  // Titre clignotant
  late final AnimationController _blinkCtrl;
  late final Animation<double> _blinkAnim;

  // Progression animée 0→68%
  late final AnimationController _progCtrl;
  late final Animation<double> _progAnim;

  @override
  void initState() {
    super.initState();

    _spinCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
    _spinAnim = Tween<double>(begin: 0, end: 1).animate(_spinCtrl);

    _blinkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _blinkAnim = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _blinkCtrl, curve: Curves.easeInOut));

    _progCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 8900),
    );
    _progAnim = Tween<double>(
      begin: 0,
      end: .89,
    ).animate(CurvedAnimation(parent: _progCtrl, curve: Curves.easeInOut));
    _progCtrl.forward();
  }

  @override
  void dispose() {
    _spinCtrl.dispose();
    _blinkCtrl.dispose();
    _progCtrl.dispose();
    super.dispose();
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
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 4),
                _buildStepperCard(),
                const SizedBox(height: 14),
                _buildAnalysisCard(),
                const SizedBox(height: 14),
                _buildDidYouKnowCard(),
                const SizedBox(height: 14),
                _buildProgressCard(),
                const SizedBox(height: 22),
                _buildImagesSection(),
                const SizedBox(height: 16),
                _buildSecurityNotice(),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── TOP BAR ────────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 8, 16, 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: _textDk,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            visualDensity: VisualDensity.compact,
          ),
          SizedBox(width: 40),
          FadeTransition(
            opacity: _blinkAnim,
            child: const Text(
              "KezIA analyse votre image...",
              style: TextStyle(
                fontSize: 18,
                color: _green2,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── STEPPER ────────────────────────────────────────────────────────────
  Widget _buildStepperCard() {
    return _WhiteCard(
      padding: const EdgeInsets.fromLTRB(12, 20, 12, 20),
      child: Column(
        children: [
          // Rangée d'icônes + lignes
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //spacing: -10,
            children: [
              Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _StepCircle(icon: _StepIcon.image, state: _StepState.done),
                  _StepLabel(
                    title: 'Image\n reçue',
                    sub: 'Passed',
                    state: _StepState.done,
                  ),
                ],
              ),
              _StepLine(done: true),
              Column(
                spacing: 5,
                children: [
                  _StepCircle(icon: _StepIcon.leaf, state: _StepState.done),
                  _StepLabel(
                    title: 'Détection\n plante',
                    sub: 'Passed',
                    state: _StepState.done,
                  ),
                ],
              ),
              _StepLine(done: true),
              Column(
                spacing: 5,
                children: [
                  _StepCircle(
                    icon: _StepIcon.scan,
                    state: _StepState.active,
                    spinAnim: _spinAnim,
                  ),
                  _StepLabel(
                    title: 'Analyse\n maladie',
                    sub: 'En cours...',
                    state: _StepState.active,
                  ),
                ],
              ),
              _StepLine(done: false),
              Column(
                spacing: 5,
                children: [
                  _StepCircle(
                    icon: _StepIcon.document,
                    state: _StepState.pending,
                  ),
                  _StepLabel(
                    title: 'Génération\n résultats',
                    sub: 'En attente',
                    state: _StepState.pending,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── CARD ANALYSE ───────────────────────────────────────────────────────
  Widget _buildAnalysisCard() {
    return _WhiteCard(
      padding: EdgeInsets.zero,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Photo gauche
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14),
              ),
              child: SizedBox(
                width: 148,
                child: Image.asset("assets/plantes/mais.jpg",fit: BoxFit.cover,)
                /*CustomPaint(
                  painter: _MaisLeafPhotoPainter(),
                  child: const SizedBox.expand(),
                ),*/
              ),
            ),
            // Étapes droite
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 14, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titre
                    Row(
                      children: [
                        //Icon(Icons.settings_suggest_outlined,color: _green2,size: 30,),
                        Image.asset("assets/icons/ai.png",width: 30,color: _green2,),
                          //child: CustomPaint(painter: _GearSparkPainter()),
                        const SizedBox(width: 8),
                        const Text(
                          "KezIA analyse...",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: _green2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    _AnalysisStep(
                      icon: Icon(Icons.search,color: _green2),
                      title: 'Identification de la plante',
                      sub: 'Maïs',
                      subColor: _green3,
                      status: _TaskStatus.done,
                      spinAnim: _spinAnim,
                    ),
                    const SizedBox(height: 10),
                    _AnalysisStep(
                      icon: Icon(Icons.settings_suggest_outlined,color: _green2),
                      title: 'Analyse du feuillage',
                      sub: 'En cours...',
                      subColor: _green2,
                      status: _TaskStatus.loading,
                      spinAnim: _spinAnim,
                    ),
                    const SizedBox(height: 10),
                    /*_AnalysisStep(
                      iconPainter: _DatabaseIcon(),
                      title: 'Comparaison avec la base de données',
                      sub: 'En attente',
                      subColor: _textLt,
                      status: _TaskStatus.waitingSoon,
                      spinAnim: _spinAnim,
                    ),*/
                    //const SizedBox(height: 10),
                    _AnalysisStep(
                      icon: Icon(Icons.smart_toy_outlined,color: _green2,),
                      title: 'Évaluation du niveau de confiance et resultats',
                      sub: 'En attente',
                      subColor: _textLt,
                      status: _TaskStatus.pending,
                      spinAnim: _spinAnim,
                    ),
                    //const SizedBox(height: 10),
                   /* _AnalysisStep(
                      iconPainter: _DocListIcon(),
                      title: 'Génération des recommandations',
                      sub: 'En attente',
                      subColor: _textLt,
                      status: _TaskStatus.pending,
                      spinAnim: _spinAnim,
                    ),*/
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── SAVIEZ-VOUS ? ──────────────────────────────────────────────────────
  Widget _buildDidYouKnowCard() {
    return Container(
      decoration: BoxDecoration(
        color: _green5,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _green6, width: 1),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ampoule
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: _green3,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(Icons.lightbulb,color: Colors.yellowAccent,),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Saviez-vous ?',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: _green2,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),
                SizedBox(
                  width: 210,
                  child: const Text(
                    'Notre IA a été entrainée avec des milliers d\'images '
                    'de plantes et de maladies pour vous fournir '
                    'les résultats les plus fiables.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: _textMd,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // Main + téléphone
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            child: SizedBox(
              //width: 110,
              height: 140,
              child: Image.asset("assets/fonds/fond_card.png",fit: BoxFit.cover,),
            ),
          ),
        ],
      ),
    );
  }

  // ── CARTE PROGRESSION 68% ─────────────────────────────────────────────
  Widget _buildProgressCard() {
    return _WhiteCard(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Stack(
        children: [
          // Feuille déco gauche
          Positioned(
            left: 5,
            top: 58,
            bottom: 0,
            child: SizedBox(
              width: 65,
              child: Image.asset("assets/icons/nature.png",color: _green2,)
            ),
          ),
          // Feuille déco droite
          Positioned(
            right: 5,
            top: 58,
            bottom: 0,
            child: SizedBox(
              width: 65,
              child: Transform.flip(
                  flipX: true,
                  child: Image.asset("assets/icons/nature.png",color: _green2,))
            ),
          ),
          // Contenu central
          Column(
            children: [
              FadeTransition(
                opacity: _blinkAnim,
                child: const Text(
                  'Analyse en cours...',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _green2,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              AnimatedBuilder(
                animation: _progAnim,
                builder: (_, _) => Text(
                  '${(_progAnim.value * 100).round()}%',
                  style: const TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.w900,
                    color: _green1,
                    height: 1.1,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Cela peut prendre quelques secondes',
                style: TextStyle(fontSize: 13, color: _textMd),
              ),
              const SizedBox(height: 16),
              // Barre de progression
              AnimatedBuilder(
                animation: _progAnim,
                builder: (_, _) => ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: _progAnim.value,
                    minHeight: 11,
                    backgroundColor: const Color(0xFFE0E0E0),
                    valueColor: const AlwaysStoppedAnimation<Color>(_green2),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── IMAGES ANALYSÉES ──────────────────────────────────────────────────
  Widget _buildImagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Images analysées',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: _textDk,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            // Image 1
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 110,
                height: 110,
                child: Image.asset("assets/plantes/mais.jpg",fit: BoxFit.cover,),
              ),
            ),
            const SizedBox(width: 12),
            // Ajouter carte (tirets)
            _DashedAddCard(),
          ],
        ),
      ],
    );
  }

  // ── NOTICE SÉCURITÉ ───────────────────────────────────────────────────
  Widget _buildSecurityNotice() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _green5,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _green6, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: _green6,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.security,color: _green1,),
              //child: CustomPaint(painter: _ShieldCheckPainter()),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Vos images sont sécurisées et utilisées uniquement '
              "pour l'analyse. Elles ne sont pas partagées.",
              style: TextStyle(fontSize: 12, color: _textDk, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  STEPPER WIDGETS
// ─────────────────────────────────────────────
enum _StepState { done, active, pending }

enum _StepIcon { image, leaf, scan, document }

enum _TaskStatus { done, loading, waitingSoon, pending }

class _StepCircle extends StatelessWidget {
  final _StepIcon icon;
  final _StepState state;
  final Animation<double>? spinAnim;
  const _StepCircle({required this.icon, required this.state, this.spinAnim});

  bool get _filled => state != _StepState.pending;
  Color get _bgColor => _filled ? _green4 : const Color(0xFFF2F2F2);
  Color get _iconColor => _filled ? _green2 : _grayIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 52,
      decoration: BoxDecoration(
        color: _bgColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _filled ? _green6 : const Color(0xFFE0E0E0),
          width: 1.5,
        ),
      ),
      child: Center(
        child: SizedBox(width: 30, height: 30, child: _buildIcon()),
      ),
    );
  }

  Widget _buildIcon() {
    switch (icon) {
      case _StepIcon.image:
        return Icon(Icons.image_outlined, color: _iconColor,size: 30,);
      case _StepIcon.leaf:
        return Icon(Icons.eco_outlined, color: _iconColor, size: 30);
      case _StepIcon.scan:
        if (state == _StepState.active && spinAnim != null) {
          return AnimatedBuilder(
            animation: spinAnim!,
            builder: (_, _) =>
                CustomPaint(painter: _ScanPulsePainter(spinAnim!.value)),
          );
        }
        return CustomPaint(painter: _ScanPulsePainter(0));
      case _StepIcon.document:
        return Icon(Icons.description_outlined, color: _iconColor, size: 24);
    }
  }
}

class _StepLine extends StatelessWidget {
  final bool done;
  const _StepLine({required this.done});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        //padding: EdgeInsets.only(top: 10),
        height: 52,
        //margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          //color: done ? _green3 : const Color(0xFFDDDDDD),
          //borderRadius: BorderRadius.circular(2),
        ),
        child: Divider(
          thickness: 3,
          color: done ? _green3 : const Color(0xFFDDDDDD),
        ),
      ),
    );
  }
}

class _StepLabel extends StatelessWidget {
  final String title;
  final String? sub;
  final _StepState state;
  const _StepLabel({required this.title, this.sub, required this.state});

  Color get _subColor {
    if (state == _StepState.active) return _green2;
    if (state == _StepState.done) return _textLt;
    return _textLt;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: state == _StepState.pending ? _textLt : _textDk,
              height: 1.35,
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (sub!.isNotEmpty) ...[
                Flexible(
                  child: Text(
                    sub!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      color: _subColor,
                      fontWeight: state == _StepState.active
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ],
              if (state == _StepState.done) ...[
                const SizedBox(width: 3),
                const Icon(
                  Icons.check_circle_rounded,
                  color: _green3,
                  size: 13,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  ANALYSIS STEP ITEM
// ─────────────────────────────────────────────
class _AnalysisStep extends StatelessWidget {
  final Widget icon;
  final String title, sub;
  final Color subColor;
  final _TaskStatus status;
  final Animation<double> spinAnim;

  const _AnalysisStep({
    required this.icon,
    required this.title,
    required this.sub,
    required this.subColor,
    required this.status,
    required this.spinAnim,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icône gauche
        Container(
          width: 35,
          height: 35,
          decoration: const BoxDecoration(
            color: _green4,
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: icon,
          ),
        ),
        const SizedBox(width: 8),
        // Texte
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: _textDk,
                  height: 1.2,
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 1),
              Text(
                sub,
                style: TextStyle(
                  fontSize: 11,
                  color: subColor,
                  fontWeight: status == _TaskStatus.loading
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 4),
        // Indicateur de statut
        SizedBox(width: 20, height: 20, child: _buildStatusWidget()),
      ],
    );
  }

  Widget _buildStatusWidget() {
    switch (status) {
      case _TaskStatus.done:
        return const Icon(
          Icons.check_circle_outline_rounded,
          color: _green3,
          size: 20,
        );
      case _TaskStatus.loading:
        return AnimatedBuilder(
          animation: spinAnim,
          builder: (_, _) => CustomPaint(
            painter: _SpinnerPainter(spinAnim.value, _green3, 2.2),
          ),
        );
      case _TaskStatus.waitingSoon:
        return CustomPaint(painter: _SpinnerPainter(0.25, _grayIcon, 2.0));
      case _TaskStatus.pending:
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _grayCirc, width: 1.8),
          ),
        );
    }
  }
}

// ─────────────────────────────────────────────
//  DASHED ADD CARD
// ─────────────────────────────────────────────
class _DashedAddCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(),
      child: SizedBox(
        width: 110,
        height: 110,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _green3, width: 1.8),
              ),
              child: const Icon(Icons.add_rounded, color: _green3, size: 22),
            ),
            const SizedBox(height: 8),
            const Text(
              "Ajouter\nd'autres images",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11.5, color: _textMd, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  WHITE CARD HELPER
// ─────────────────────────────────────────────
class _WhiteCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const _WhiteCard({required this.child, this.padding});
  @override
  Widget build(BuildContext context) => Container(
    padding: padding ?? const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFF0F0F0), width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 14,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: child,
  );
}

// ══════════════════════════════════════════════
//  PAINTERS
// ══════════════════════════════════════════════

// ─── SCANNER PULSE (step actif) ───────────────
class _ScanPulsePainter extends CustomPainter {
  final double progress;
  const _ScanPulsePainter(this.progress);
  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()
      ..color = _green2
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(
      Offset(s.width / 2, s.height / 2),
      s.width * 0.38,
      p..color = _green2.withOpacity(0.35),
    );
    // Arc pulsé
    final arc = Paint()
      ..color = _green2
      ..strokeWidth = 2.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(s.width / 2, s.height / 2),
        radius: s.width * 0.38,
      ),
      -math.pi / 2 + progress * 2 * math.pi,
      math.pi * 1.2,
      false,
      arc,
    );
    // Point central
    canvas.drawCircle(
      Offset(s.width / 2, s.height / 2),
      s.width * 0.12,
      Paint()
        ..color = _green2
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant _ScanPulsePainter old) =>
      old.progress != progress;
}

// ─── SPINNER GÉNÉRIQUE ────────────────────────
class _SpinnerPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeW;
  const _SpinnerPainter(this.progress, this.color, this.strokeW);

  @override
  void paint(Canvas canvas, Size s) {
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(s.width / 2, s.height / 2),
        radius: s.width * 0.44,
      ),
      -math.pi / 2 + progress * 2 * math.pi,
      math.pi * 1.35,
      false,
      Paint()
        ..color = color
        ..strokeWidth = strokeW
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _SpinnerPainter old) => old.progress != progress;
}


// ─── BORDURE TIRETS ───────────────────────────
class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()
      ..color = const Color(0xFFCCCCCC)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final r = 12.0;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, s.width, s.height),
          Radius.circular(r),
        ),
      );

    const dashLen = 6.0, gapLen = 4.0;
    final pm = path.computeMetrics().first;
    var dist = 0.0;
    bool draw = true;
    while (dist < pm.length) {
      final end = math.min(dist + (draw ? dashLen : gapLen), pm.length);
      if (draw) canvas.drawPath(pm.extractPath(dist, end), p);
      dist = end;
      draw = !draw;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}
