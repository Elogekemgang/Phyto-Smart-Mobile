import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:phytosmart_mobile/screens/analyse/analyseaiscreen.dart';
import 'package:phytosmart_mobile/screens/analyse/historyscreen.dart';
import 'package:phytosmart_mobile/screens/analyse/resultatscreen.dart';

import '../analyse/camerascreen.dart';

// ─────────────────────────────────────────────
//  PALETTE
// ─────────────────────────────────────────────
const _green1 = Color(0xFF1B5E20);
const _green2 = Color(0xFF2E7D32);
const _green3 = Color(0xFF4CAF50);
const _green4 = Color(0xFFE8F5E9);
const _green5 = Color(0xFFC8E6C9);
const _greenBg = Color(0xFFF0F4F0); // fond card diagnostic
const _blue1 = Color(0xFF0D47A1);
const _gold = Color(0xFFFFCA2A);
const _goldDk = Color(0xFFF57F17);
const _textD = Color(0xFF1B5E20);
const _textDk = Color(0xFF1A1A1A);
const _textMd = Color(0xFF616161);
const _textLt = Color(0xFF9E9E9E);
const _divider = Color(0xFFF0F0F0);

// ─────────────────────────────────────────────
//  DIAGNOSTIC SCREEN
// ─────────────────────────────────────────────
class DiagnosticScreen extends StatefulWidget {
  const DiagnosticScreen({super.key});
  @override
  State<DiagnosticScreen> createState() => _DiagnosticScreenState();
}

class _DiagnosticScreenState extends State<DiagnosticScreen>
    with SingleTickerProviderStateMixin {
  bool _offlineMode = true;
  late AnimationController _scanCtrl;
  late Animation<double> _scanAnim;

  @override
  void initState() {
    super.initState();
    _scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _scanAnim = CurvedAnimation(parent: _scanCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _scanCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildHero()),
          SliverToBoxAdapter(child: const SizedBox(height: 20)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverToBoxAdapter(child: _buildDiagnostiquerCard()),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: 28)),
          SliverToBoxAdapter(child: _buildSectionHeader('Diagnostics récents')),
          SliverToBoxAdapter(child: const SizedBox(height: 12)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverToBoxAdapter(child: _buildDiagnosticsRecents()),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: 24)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverToBoxAdapter(child: _buildConseilsCard()),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: 20)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverToBoxAdapter(child: _buildProBanner()),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: 30)),
        ],
      ),
    );
  }

  // ─── HERO ─────────────────────────────────────────────────────────────────
  Widget _buildHero() {
    return SizedBox(
      height: 115,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Illustration droite : branche + main + téléphone
          Positioned(
            right: 0,
            //top: 0,
            child: SizedBox(
              width: 195,
              height: 210,
              child: AnimatedBuilder(
                animation: _scanAnim,
                builder: (_, _) => Image.asset("assets/main.png"),
              ),
            ),
          ),

          // Texte gauche
          Positioned(
            left: 20,
            top: 12,
            right: 180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Diagnostic',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: _textD,
                    height: 1.1,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Détectez les maladies, carences et parasites de vos plantes en quelques secondes.',
                  style: TextStyle(
                    fontSize: 13.5,
                    color: _textMd,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── CARD "Diagnostiquer une plante" ──────────────────────────────────────
  Widget _buildDiagnostiquerCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      decoration: BoxDecoration(
        color: _greenBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Diagnostiquer une plante',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: _green1,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Prenez une photo nette de la feuille, fruit\nou de la plante entière.',
            style: TextStyle(fontSize: 13, color: _textMd, height: 1.5),
          ),
          const SizedBox(height: 16),
          // Deux boutons côte à côte
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.camera_alt_rounded,
                  label: 'Prendre une photo',
                  sub: 'Utiliser la caméra',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Camerascreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionButton(
                  icon: Icons.perm_media,
                  label: 'Importer une image',
                  sub: "Galerie de l'appareil",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Camerascreen(autoImportGallery: true,),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Mode hors connexion
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.wifi_off_rounded, color: _textMd, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Mode hors connexion',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: _textDk,
                        ),
                      ),
                      SizedBox(height: 1),
                      Text(
                        'Les images seront analysées plus tard',
                        style: TextStyle(fontSize: 12, color: _textMd),
                      ),
                    ],
                  ),
                ),
                Transform.scale(
                  scale: 0.85,
                  child: Switch(
                    value: _offlineMode,
                    onChanged: (v) => setState(() => _offlineMode = v),
                    activeTrackColor: _green2,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.grey.shade300,
                    trackOutlineWidth: const WidgetStatePropertyAll(0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── DIAGNOSTICS RÉCENTS ──────────────────────────────────────────────────
  Widget _buildDiagnosticsRecents() {
    const items = [
      _DiagData('Tomate', 'Mildiou', '15 Mai 2024', 92, _DType.tomate),
      _DiagData('Maïs', 'Charbon commun', '14 Mai 2024', 88, _DType.mais),
      _DiagData('Piment', 'Carence en azote', '12 Mai 2024', 76, _DType.piment),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: List.generate(items.length, (i) {
          return Column(
            children: [
              _DiagnosticItem(data: items[i]),
              if (i < items.length - 1)
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: _divider,
                  indent: 16,
                  endIndent: 16,
                ),
            ],
          );
        }),
      ),
    );
  }

  // ─── CONSEILS CARD ────────────────────────────────────────────────────────
  Widget _buildConseilsCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      decoration: BoxDecoration(
        color: _greenBg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          const Text(
            'Conseils pour de meilleurs résultats',
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
              color: _green1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),
          IntrinsicHeight(
            child: Row(
              children: [
                _ConseilItem(
                  icon: Image.asset("assets/icons/sun.png"),
                  label: 'Prenez la photo\nen pleine lumière',
                ),
                _VertDivider(),
                _ConseilItem(
                  icon: Image.asset("assets/icons/qr-code.png"),
                  label: 'Ciblez la partie\nmalade',
                ),
                _VertDivider(),
                _ConseilItem(
                  icon: Image.asset("assets/icons/leaf.png"),
                  label: 'Gardez l\'image\nnette',
                ),
                _VertDivider(),
                _ConseilItem(
                  icon: Image.asset("assets/icons/forest.png"),
                  label: 'Évitez les arrière-plans chargés',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── BANNER MODE PRO ──────────────────────────────────────────────────────
  Widget _buildProBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1B5E20),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Médaille OR
          SizedBox(
            width: 56,
            height: 56,
            child: CustomPaint(painter: _GoldMedalPainter()),
          ),
          const SizedBox(width: 8),
          // Textes
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge "Mode Pro"
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: _gold,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Mode Pro',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: _green1,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Accédez au diagnostic hors ligne',
                  style: TextStyle(
                    //fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Expanded(
                      child: const Text(
                        'Téléchargez les modèles et diagnostiquez sans connexion internet.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFB9F6CA),
                          height: 1.45,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'Passer en Pro',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: _green1,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.chevron_right, color: _green1, size: 18),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Bouton "Passer en Pro"
        ],
      ),
    );
  }

  // ─── SECTION HEADER ───────────────────────────────────────────────────────
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: _textDk,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoriqueScreen()),
              );
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Voir tout',
              style: TextStyle(
                fontSize: 14,
                color: _green3,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  ACTION BUTTON (Prendre photo / Importer)
// ─────────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label, sub;
  final VoidCallback onTap;
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.sub,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: _green4,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: _green2, size: 30),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: _textDk,
              ),
            ),
            const SizedBox(height: 3),
            Text(sub, style: const TextStyle(fontSize: 12, color: _textMd)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  ITEM DIAGNOSTIC RÉCENT
// ─────────────────────────────────────────────
enum _DType { tomate, mais, piment }

class _DiagData {
  final String name, disease, date;
  final int confidence;
  final _DType type;
  const _DiagData(
    this.name,
    this.disease,
    this.date,
    this.confidence,
    this.type,
  );
}

class _DiagnosticItem extends StatelessWidget {
  final _DiagData data;
  const _DiagnosticItem({required this.data});

  Color get _confidenceColor {
    if (data.confidence >= 90) return const Color(0xFF2E7D32);
    if (data.confidence >= 80) return const Color(0xFF388E3C);
    return const Color(0xFF558B2F);
  }

  Color get _confidenceBg {
    if (data.confidence >= 90) return const Color(0xFFE8F5E9);
    if (data.confidence >= 80) return const Color(0xFFF1F8E9);
    return const Color(0xFFF9FBE7);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ResultatsScreen()),
          );
        },
        child: Row(
          children: [
            // Image plante malade
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              // ── Remplacer par Image.asset('assets/images/${data.type.name}_disease.jpg')
              child: Image.asset(
                'assets/plantes/${data.type.name}.jpg',
                width: 72,
                height: 72,
                fit: BoxFit.cover,
              ) /*CustomPaint(
                    painter: _DiseasedPlantPainter(data.type)),*/,
            ),
            const SizedBox(width: 14),
            // Infos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name,
                    style: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: _textDk,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    data.disease,
                    style: const TextStyle(fontSize: 13, color: _textMd),
                  ),
                  const SizedBox(height: 6),
                  // Badge confiance
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 3.5,
                    ),
                    decoration: BoxDecoration(
                      color: _confidenceBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Confiance : ${data.confidence}%',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: _confidenceColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Date + chevron
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  data.date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: _textLt,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  CONSEIL ITEM
// ─────────────────────────────────────────────
class _ConseilItem extends StatelessWidget {
  final Widget icon;
  final String label;
  const _ConseilItem({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 40, height: 40, child: icon),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: _textMd, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: double.infinity,
      color: _green5.withOpacity(0.5),
    );
  }
}

// ══════════════════════════════════════════════
//  PAINTERS
// ══════════════════════════════════════════════

// ─── MÉDAILLE OR ──────────────────────────────
class _GoldMedalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final cx = s.width / 2, cy = s.height / 2;
    // Halo lumineux
    canvas.drawCircle(
      Offset(cx, cy),
      s.width * 0.5,
      Paint()
        ..color = const Color(0xFFFFB300).withOpacity(0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    // Médaille
    canvas.drawCircle(
      Offset(cx, cy),
      s.width * 0.42,
      Paint()
        ..shader =
            const RadialGradient(
              colors: [Color(0xFFFFE57F), Color(0xFFFFB300), Color(0xFFF57F17)],
              stops: [0.0, 0.6, 1.0],
            ).createShader(
              Rect.fromCircle(center: Offset(cx, cy), radius: s.width * 0.42),
            ),
    );
    // Étoile
    _drawStar(canvas, Offset(cx, cy), s.width * 0.24, s.width * 0.11);
  }

  void _drawStar(Canvas canvas, Offset c, double outer, double inner) {
    final path = Path();
    for (int i = 0; i < 10; i++) {
      final r = i.isEven ? outer : inner;
      final a = i * math.pi / 5 - math.pi / 2;
      if (i == 0) {
        path.moveTo(c.dx + r * math.cos(a), c.dy + r * math.sin(a));
      } else {
        path.lineTo(c.dx + r * math.cos(a), c.dy + r * math.sin(a));
      }
    }
    path.close();
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFFF57F17)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}
