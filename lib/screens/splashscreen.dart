import 'package:flutter/material.dart';
import 'package:phytosmart_mobile/wigdet/spinning_lines.dart';

// ─────────────────────────────────────────────
//  PALETTE
// ─────────────────────────────────────────────
const Color _green1 = Color(0xFF2E7D32); // vert foncé texte
const Color _green4 = Color(0xFF0C530F); // vert clair
const Color _blue1  = Color(0xFF1A76A6); // bleu foncé

// ─────────────────────────────────────────────
//  SPLASH SCREEN
// ─────────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _masterCtrl;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _contentFade;
  late final Animation<double> _dotsFade;

  @override
  void initState() {
    super.initState();
    _masterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _logoFade = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
            parent: _masterCtrl, curve: const Interval(0.0, 0.45, curve: Curves.easeOut)));
    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
        CurvedAnimation(
            parent: _masterCtrl, curve: const Interval(0.0, 0.45, curve: Curves.elasticOut)));
    _titleFade = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
            parent: _masterCtrl, curve: const Interval(0.35, 0.62, curve: Curves.easeOut)));
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
        CurvedAnimation(
            parent: _masterCtrl, curve: const Interval(0.35, 0.62, curve: Curves.easeOut)));
    _contentFade = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
            parent: _masterCtrl, curve: const Interval(0.55, 0.85, curve: Curves.easeOut)));
    _dotsFade = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
            parent: _masterCtrl, curve: const Interval(0.78, 1.0, curve: Curves.easeOut)));

    _masterCtrl.forward();
  }

  @override
  void dispose() {
    _masterCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ── 1. FOND : photo plantation floue ──────────────────────────────

          Positioned(
            //top: 0,
            //right: 0,
            child: Image.asset("assets/fonds/fond_haut.png",width: size.width,fit: BoxFit.cover,),
          ),
          /*Positioned.fill(
            child: _PlantationBackground(),
          ),*/
          Positioned(
            bottom: 0,
            //left: 0,
            //right: 0,
            child: Image.asset("assets/fonds/fond_bas.png",fit: BoxFit.cover,width: size.width,),
          ),

          // ── 2. OVERLAY blanc dégradé (masque le fond au centre) ──────────
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.15, 0.5, 0.72, 0.88, 1.0],
                  colors: [
                    Color(0x00ffffff),
                    Color(0xC8E8EAE9),
                    Color(0xFFFFFFFF),
                    Color(0xEEFFFFFF),
                    Color(0x94FFFFFF),
                    Color(0x00ffffff),
                  ],
                ),
              ),
            ),
          ),

          // ── 3. FEUILLES coin haut-droit (décoratives) ────────────────────


          // ── 4. LUMIÈRE soleil coin haut-gauche ───────────────────────────

          // ── 5. CONTENU PRINCIPAL ──────────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                // ── LOGO ──────────────────────────────────────────────────
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 12),

                      // Logo animé
                      FadeTransition(
                        opacity: _logoFade,
                        child: ScaleTransition(
                          scale: _logoScale,
                          child: SizedBox(
                            width: 170,
                            height: 170,
                            // ── Remplacer par Image.asset si vous avez le PNG ──
                            child: Image.asset('assets/logo/logo_b.png'),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // ── NOM APP ──────────────────────────────────────────
                      FadeTransition(
                        opacity: _titleFade,
                        child: SlideTransition(
                          position: _titleSlide,
                          child: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Phyto ',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 45,
                                    fontWeight: FontWeight.w800,
                                    color: _green1,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Smart',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 45,
                                    fontWeight: FontWeight.w800,
                                    color: _blue1,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // ── SOUS-TITRE ────────────────────────────────────────
                      FadeTransition(
                        opacity: _titleFade,
                        child: const Text(
                          'Détection des maladies des plantes\net aide à la culture',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: _green4,
                            height: 1.55,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // ── ICÔNES FONCTIONNALITÉS ───────────────────────────
                      FadeTransition(
                        opacity: _contentFade,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _FeatureItem(
                                painter: Image.asset("assets/images/scan.png"),
                                label1: 'Détection',
                                label2: 'Intelligente',
                              ),
                              SizedBox(height: 90, width: 0, child: VerticalDivider( color: Colors.grey.shade300,)),
                              _FeatureItem(
                                painter: Image.asset("assets/images/secure.png"),
                                label1: 'Diagnostic',
                                label2: 'Précis',
                              ),
                              SizedBox(height: 90, width: 0, child: VerticalDivider( color: Colors.grey.shade300,)),
                              _FeatureItem(
                                painter: Image.asset("assets/images/plant.png"),
                                label1: 'Conseils',
                                label2: 'Personnalisés',
                              ),
                              SizedBox(height: 90, width: 0, child: VerticalDivider( color: Colors.grey.shade300,)),
                              _FeatureItem(
                                painter: Image.asset("assets/images/diagram.png"),
                                label1: 'Suivi',
                                label2: 'de Culture',
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // ── TAGLINE ───────────────────────────────────────────
                      FadeTransition(
                        opacity: _contentFade,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w700,
                                color: _green1,
                                height: 1.55,
                                letterSpacing: 0.1,
                              ),
                              children: [
                                TextSpan(text: 'Prenez soin de vos plantes,\n'),
                                TextSpan(
                                    text:
                                    'nous prenons soin de vos cultures.'),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      FadeTransition(
                        opacity: _dotsFade,
                        child: Column(
                          children: [
                            SpinKitSpinningLines(color: _green1),
                            const SizedBox(height: 14),
                            const Text(
                              'Chargement en cours...',
                              style: TextStyle(
                                fontSize: 13.5,
                                color: _green4,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(height: 14),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),


                // ── DOTS + LOADING ─────────────────────────────────────────

              ],
            ),
          ),


          // ── 6. VAGUE BAS (vert → bleu) ────────────────────────────────────
          /*Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              width: size.width,
              height: 88,
              child: CustomPaint(painter: _BottomWavePainter()),
            ),
          ),*/


        ],
      ),
    );
  }
}


// ─────────────────────────────────────────────
//  WIDGET FONCTIONNALITÉ
// ─────────────────────────────────────────────
class _FeatureItem extends StatelessWidget {
  final Widget painter;
  final String label1;
  final String label2;

  const _FeatureItem({required this.painter, required this.label1, required this.label2});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.82),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: painter,
        ),
        const SizedBox(height: 8),
        RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                style: const TextStyle(
                  color: _green4,
                  height: 1.35,
                ),

                children: [
                  TextSpan(
                    text: "$label1 \n",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: label2,style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  )
                ]
            ))
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  VAGUE DU BAS (vert → bleu)
// ─────────────────────────────────────────────
class _BottomWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Forme vague verte (gauche)
    final greenPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, 0, w * 0.65, h));

    final greenPath = Path()
      ..moveTo(0, h * 0.55)
      ..cubicTo(w * 0.15, h * 0.1, w * 0.32, h * 0.0, w * 0.52, h * 0.35)
      ..cubicTo(w * 0.60, h * 0.52, w * 0.65, h * 0.65, w * 0.70, h * 0.75)
      ..lineTo(w * 0.70, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(greenPath, greenPaint);

    // Forme vague bleue (droite)
    final bluePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF1976D2), Color(0xFF0D47A1)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(w * 0.35, 0, w * 0.65, h));

    final bluePath = Path()
      ..moveTo(w, h * 0.35)
      ..cubicTo(w * 0.85, -h * 0.1, w * 0.68, h * 0.05, w * 0.55, h * 0.42)
      ..cubicTo(w * 0.48, h * 0.60, w * 0.40, h * 0.72, w * 0.34, h * 0.80)
      ..lineTo(w * 0.34, h)
      ..lineTo(w, h)
      ..close();
    canvas.drawPath(bluePath, bluePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}