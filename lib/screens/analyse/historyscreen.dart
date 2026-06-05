import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../models/diagnosis_model.dart';
import '../../services/diagnosis_service.dart';
import '../../wigdet/circularcustom.dart';


// ─────────────────────────────────────────────
//  PALETTE
// ─────────────────────────────────────────────
const _green1     = Color(0xFF1B5E20);
const _green2     = Color(0xFF2E7D32);
const _green3     = Color(0xFF4CAF50);
const _green4     = Color(0xFFE8F5E9);
const _green5     = Color(0xFFC8E6C9);
const _orange     = Color(0xFFE65100);
const _textDk     = Color(0xFF1A1A1A);
const _textMd     = Color(0xFF616161);
const _textLt     = Color(0xFF9E9E9E);
const _divider    = Color(0xFFF0F0F0);
const _searchBg   = Color(0xFFF5F5F5);

// Badge presets
const _badgeMaladie     = _BadgeStyle(Color(0xFFFFEBEE), Color(0xFFE53935));
const _badgeRavageur    = _BadgeStyle(Color(0xFFFFF8E1), Color(0xFFF9A825));
const _badgeSaine    = _BadgeStyle(Color(0xFFD7FFC6), Color(0xFF2C7300));
const _badgeCarence     = _BadgeStyle(Color(0xFFF3E5F5), Color(0xFF7B1FA2));
const _badgeVirale      = _BadgeStyle(Color(0xFFFFEBEE), Color(0xFFE53935));

class _BadgeStyle {
  final Color bg, text;
  const _BadgeStyle(this.bg, this.text);
}

// ─────────────────────────────────────────────
//  DATA MODEL
// ─────────────────────────────────────────────
enum _PlantType { maisRouille, tomate, piment, chou, maisCarence, manioc }
enum _DiagFilter { tous, maladies, ravageurs, carences }

class _DiagItem {
  final _PlantType plant;
  final String plantName, disease, dateStr;
  final int confidence;
  final String badgeLabel;
  final _BadgeStyle badgeStyle;

  const _DiagItem({
    required this.plant,
    required this.plantName,
    required this.disease,
    required this.dateStr,
    required this.confidence,
    required this.badgeLabel,
    required this.badgeStyle,
  });
}

class _DiagSection {
  final String title;
  final List<_DiagItem> items;
  const _DiagSection(this.title, this.items);
}

const _allSections = [
  _DiagSection("Aujourd'hui", [
    _DiagItem(
      plant: _PlantType.maisRouille,
      plantName: 'Maïs',
      disease: 'Rouille commune du maïs',
      dateStr: '18 Mai 2024 à 09:41',
      confidence: 94,
      badgeLabel: 'Maladie',
      badgeStyle: _badgeMaladie,
    ),
  ]),
  _DiagSection('Hier', [
    _DiagItem(
      plant: _PlantType.tomate,
      plantName: 'Tomate',
      disease: 'Mildiou',
      dateStr: '17 Mai 2024 à 16:28',
      confidence: 92,
      badgeLabel: 'Maladie',
      badgeStyle: _badgeMaladie,
    ),
  ]),
  _DiagSection('Cette semaine', [
    _DiagItem(
      plant: _PlantType.piment,
      plantName: 'Piment',
      disease: 'Taches bactériennes',
      dateStr: '16 Mai 2024 à 11:15',
      confidence: 90,
      badgeLabel: 'Maladie',
      badgeStyle: _badgeMaladie,
    ),
    _DiagItem(
      plant: _PlantType.chou,
      plantName: 'Chou',
      disease: 'Chenilles défoliatrices',
      dateStr: '15 Mai 2024 à 08:52',
      confidence: 85,
      badgeLabel: 'Ravageur',
      badgeStyle: _badgeRavageur,
    ),
  ]),
  _DiagSection('Semaine dernière', [
    _DiagItem(
      plant: _PlantType.maisCarence,
      plantName: 'Maïs',
      disease: 'Carence en azote',
      dateStr: '11 Mai 2024 à 14:33',
      confidence: 78,
      badgeLabel: 'Carence',
      badgeStyle: _badgeCarence,
    ),
    _DiagItem(
      plant: _PlantType.manioc,
      plantName: 'Manioc',
      disease: 'Mosaïque africaine du manioc',
      dateStr: '9 Mai 2024 à 10:05',
      confidence: 88,
      badgeLabel: 'Maladie virale',
      badgeStyle: _badgeVirale,
    ),
  ]),
];

// ─────────────────────────────────────────────
//  HISTORIQUE SCREEN
// ─────────────────────────────────────────────
class HistoriqueScreen extends StatefulWidget {
  const HistoriqueScreen({super.key});
  @override
  State<HistoriqueScreen> createState() => _HistoriqueScreenState();
}

class _HistoriqueScreenState extends State<HistoriqueScreen> {


  _DiagFilter _selectedFilter = _DiagFilter.tous;
  bool _isListView = true;
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
    loadHistory();
  }



  final diagnosisService = DiagnosisService();

  List<DiagnosisModel> history = [];

  bool loading = true;

  Future loadHistory() async {
    try {
      final result = await diagnosisService.getHistory();

      setState(() {
        history = result;
      });
    } catch (e) {
      //print(e);
    }

    setState(() {
      loading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Fixed top part
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildTopBar(),
                const SizedBox(height: 14),
                _buildSearchBar(),
                const SizedBox(height: 14),
                _buildFilterChips(),
                const SizedBox(height: 14),
                _buildSortRow(),
                const SizedBox(height: 6),
              ],
            ),
          ),
          // Scrollable list
          Expanded(
            child: loading
                ? SpinKitFadingCircle(color: Colors.green,) : ListView.builder(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 30),
              physics: const BouncingScrollPhysics(),
              itemCount: history.length,
              itemBuilder: (BuildContext context, int index) {
                final diagnosis = history[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: _DiagCard(item: diagnosis,),
                );
              },
              //children: _allSections.map((s) => _buildSection(s)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ── TOP BAR ────────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Row(
        children: [
          // Back
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 20, color: _textDk),
            onPressed: () {
              Navigator.pop(context);
            },
            visualDensity: VisualDensity.compact,
          ),
          // Title
          Expanded(
            child: Text(
              'Historique des diagnostics',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: _textDk,
                letterSpacing: -0.2,
              ),
            ),
          ),
          // Filter funnel
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined,
                size: 24, color: _green2),
            onPressed: () {},
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  // ── SEARCH BAR ─────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: _searchBg,
          borderRadius: BorderRadius.circular(28),
        ),
        child: TextField(
          controller: _searchCtrl,
          style: const TextStyle(fontSize: 14, color: _textDk),
          decoration: InputDecoration(
            hintText: 'Rechercher une plante, une maladie...',
            hintStyle:
            const TextStyle(fontSize: 14, color: _textLt),
            prefixIcon: const Icon(Icons.search_rounded,
                color: _textLt, size: 20),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 11),
          ),
        ),
      ),
    );
  }

  // ── FILTER CHIPS ───────────────────────────────────────────────────────
  Widget _buildFilterChips() {
    final chips = [
      _FilterChipData(_DiagFilter.tous,     'Tous',      _FilterIcon.tous),
      _FilterChipData(_DiagFilter.maladies, 'Maladies',  _FilterIcon.maladie),
      _FilterChipData(_DiagFilter.ravageurs,'Ravageurs', _FilterIcon.ravageur),
      _FilterChipData(_DiagFilter.carences, 'Carences',  _FilterIcon.carence),
      _FilterChipData(_DiagFilter.carences, 'Autres',  _FilterIcon.carence),
    ];

    return SizedBox(
      height: 40 ,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        physics: const BouncingScrollPhysics(),
        itemCount: chips.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final c = chips[i];
          final sel = _selectedFilter == c.filter;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = c.filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: sel ? _green4 : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: sel ? _green5 : const Color(0xFFDDDDDD),
                  width: sel ? 1.5 : 1.2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 15,
                    height: 15,
                    child: CustomPaint(
                        painter: _FilterIconPainter(c.icon, sel)),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    c.label,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: sel ? _green2 : _textDk,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── SORT ROW ───────────────────────────────────────────────────────────
  Widget _buildSortRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        height: 36,
        padding: EdgeInsets.symmetric(horizontal: 9),
        decoration: BoxDecoration(
          border: Border.all(color: _green5),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade100
        ),
        child: Row(
          children: [
            // Sort label
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Trié par : ',
                    style: TextStyle(
                        fontSize: 13.5,
                        color: _textMd,
                        fontWeight: FontWeight.w500),
                  ),
                  TextSpan(
                    text: 'Plus récent',
                    style: TextStyle(
                        fontSize: 13.5,
                        color: _green2,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down_rounded,
                color: _green2, size: 18),
            const Spacer(),
            // View toggle
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE0E0E0), width: 1.2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ViewToggleBtn(
                    icon: Icons.view_list_rounded,
                    active: _isListView,
                    isFirst: true,
                    onTap: () => setState(() => _isListView = true),
                  ),
                  Container(
                      width: 1, height: 20, color: const Color(0xFFE0E0E0)),
                  _ViewToggleBtn(
                    icon: Icons.grid_view_rounded,
                    active: !_isListView,
                    isFirst: false,
                    onTap: () => setState(() => _isListView = false),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}

// ─────────────────────────────────────────────
//  VIEW TOGGLE BUTTON
// ─────────────────────────────────────────────
class _ViewToggleBtn extends StatelessWidget {
  final IconData icon;
  final bool active, isFirst;
  final VoidCallback onTap;
  const _ViewToggleBtn(
      {required this.icon,
        required this.active,
        required this.isFirst,
        required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 30,
        height: 25,
        decoration: BoxDecoration(
          color: active ? _green4 : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: isFirst ? const Radius.circular(7) : Radius.zero,
            bottomLeft: isFirst ? const Radius.circular(7) : Radius.zero,
            topRight: !isFirst ? const Radius.circular(7) : Radius.zero,
            bottomRight: !isFirst ? const Radius.circular(7) : Radius.zero,
          ),
        ),
        child: Icon(icon,
            size: 18, color: active ? _green2 : _textLt),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  DIAGNOSTIC CARD
// ─────────────────────────────────────────────
class _DiagCard extends StatelessWidget {
  final DiagnosisModel item;
  const _DiagCard({required this.item});

  Color get _confidenceColor => (double.tryParse(item.confidence.replaceAll('%', '')))! >= 80 ? _green2 : _orange;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0F0F0), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.055),
            blurRadius: 14,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Photo
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 88,
                height: 88,
                // ── Remplacer par Image.asset(…, fit: BoxFit.cover)
                //child: Image.asset("assets/plantes/${item.plantName}.jpg", fit: BoxFit.cover),
                child: Image.asset( item.plantName == "Tomato" ? "assets/plantes/tomate.jpg" : "assets/plantes/mais.jpg", fit: BoxFit.cover),
                /*child: CustomPaint(
                    painter: _PlantPhotosPainter(item.plant)),*/
              ),
            ),
            const SizedBox(width: 12),

            // Infos centre
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,spacing: 5,
                children: [
                      Text(item.plantName,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: _textDk)),

                  const SizedBox(height: 2),
                  Text(item.diseaseName,
                      style: const TextStyle(
                          fontSize: 13, color: _textMd)),
                  const SizedBox(height: 7),
                  // Date
                  Row(
                    children: [
                      const Icon(
                          Icons.calendar_today_outlined,
                          size: 13,
                          color: _textLt),
                      const SizedBox(width: 5),
                      Text("18 Mai 2024 à 09:41",
                          style: const TextStyle(
                              fontSize: 12, color: _textLt)),
                    ],
                  ),
                ],
              ),
            ),

            // Confidence + chevron
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: 40,
              children: [
                _BadgePill(
                    label: item.diseaseName == "healthy" ?" Plante saine" : "Maladie virale",
                    style: item.diseaseName == "healthy" ?_badgeSaine : _badgeVirale),
                Text(
                  item.confidence,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: _confidenceColor,
                    height: 1.1,
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
//  BADGE PILL
// ─────────────────────────────────────────────
class _BadgePill extends StatelessWidget {
  final String label;
  final _BadgeStyle style;
  const _BadgePill({required this.label, required this.style});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: style.bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: style.text,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  FILTER CHIP DATA
// ─────────────────────────────────────────────
enum _FilterIcon { tous, maladie, ravageur, carence }

class _FilterChipData {
  final _DiagFilter filter;
  final String label;
  final _FilterIcon icon;
  const _FilterChipData(this.filter, this.label, this.icon);
}

// ─────────────────────────────────────────────
//  FILTER ICON PAINTER
// ─────────────────────────────────────────────
class _FilterIconPainter extends CustomPainter {
  final _FilterIcon icon;
  final bool selected;
  const _FilterIconPainter(this.icon, this.selected);

  @override
  void paint(Canvas canvas, Size s) {
    switch (icon) {
      case _FilterIcon.tous:
        _drawTous(canvas, s);
      case _FilterIcon.maladie:
        _drawMaladie(canvas, s);
      case _FilterIcon.ravageur:
        _drawRavageur(canvas, s);
      case _FilterIcon.carence:
        _drawCarence(canvas, s);
    }
  }

  // ≡ trois lignes horizontales
  void _drawTous(Canvas canvas, Size s) {
    final p = Paint()
      ..color = selected ? _green2 : _textDk
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 3; i++) {
      final y = s.height * (0.25 + i * 0.25);
      final x0 = i == 0 ? s.width * 0.0 : s.width * 0.2;
      canvas.drawLine(Offset(x0, y), Offset(s.width, y), p);
    }
  }

  // Icône insecte/bug rouge (Maladies)
  void _drawMaladie(Canvas canvas, Size s) {
    final p = Paint()
      ..color = const Color(0xFFE53935)
      ..style = PaintingStyle.fill;
    // Corps du bug
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(s.width / 2, s.height * 0.55),
            width: s.width * 0.55,
            height: s.height * 0.60),
        p);
    // Tête
    canvas.drawCircle(Offset(s.width / 2, s.height * 0.22), s.width * 0.18, p);
    // Antennes
    final ap = Paint()
      ..color = const Color(0xFFE53935)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(s.width * 0.38, s.height * 0.08),
        Offset(s.width * 0.28, 0), ap);
    canvas.drawLine(Offset(s.width * 0.62, s.height * 0.08),
        Offset(s.width * 0.72, 0), ap);
    // Pattes
    for (int i = 0; i < 3; i++) {
      final y = s.height * (0.38 + i * 0.13);
      canvas.drawLine(Offset(s.width * 0.22, y), Offset(0, y - 3), ap);
      canvas.drawLine(Offset(s.width * 0.78, y), Offset(s.width, y - 3), ap);
    }
    // Croix blanche
    final xp = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(s.width * 0.36, s.height * 0.42),
        Offset(s.width * 0.64, s.height * 0.70), xp);
    canvas.drawLine(Offset(s.width * 0.64, s.height * 0.42),
        Offset(s.width * 0.36, s.height * 0.70), xp);
  }

  // Icône insecte jaune (Ravageurs)
  void _drawRavageur(Canvas canvas, Size s) {
    final p = Paint()
      ..color = const Color(0xFFF9A825)
      ..style = PaintingStyle.fill;
    // Corps
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(s.width / 2, s.height * 0.55),
            width: s.width * 0.52,
            height: s.height * 0.58),
        p);
    // Tête
    canvas.drawCircle(Offset(s.width / 2, s.height * 0.24), s.width * 0.17, p);
    // Rayures corps
    final sp = Paint()
      ..color = const Color(0xFFF57F17)
      ..strokeWidth = 1.4;
    for (int i = 0; i < 3; i++) {
      final y = s.height * (0.42 + i * 0.10);
      canvas.drawLine(Offset(s.width * 0.26, y),
          Offset(s.width * 0.74, y), sp);
    }
    // Pattes
    final ap = Paint()
      ..color = const Color(0xFFF9A825)
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 3; i++) {
      final y = s.height * (0.40 + i * 0.12);
      canvas.drawLine(Offset(s.width * 0.24, y), Offset(0, y + 4), ap);
      canvas.drawLine(Offset(s.width * 0.76, y), Offset(s.width, y + 4), ap);
    }
    // Antennes
    canvas.drawLine(Offset(s.width * 0.40, s.height * 0.10),
        Offset(s.width * 0.25, 0), ap);
    canvas.drawLine(Offset(s.width * 0.60, s.height * 0.10),
        Offset(s.width * 0.75, 0), ap);
  }

  // Feuille violette (Carences)
  void _drawCarence(Canvas canvas, Size s) {
    final p = Paint()
      ..color = const Color(0xFF7B1FA2)
      ..style = PaintingStyle.fill;
    final cx = s.width / 2, cy = s.height / 2;
    final lr = s.width * 0.42;
    // Tige
    canvas.drawLine(Offset(cx, cy + lr * 0.55), Offset(cx, s.height),
        Paint()
          ..color = const Color(0xFF7B1FA2)
          ..strokeWidth = 1.8
          ..strokeCap = StrokeCap.round);
    // Feuille
    final leaf = Path()
      ..moveTo(cx, cy - lr)
      ..cubicTo(cx + lr * 0.65, cy - lr * 0.5, cx + lr * 0.65, cy + lr * 0.3,
          cx, cy + lr * 0.55)
      ..cubicTo(cx - lr * 0.65, cy + lr * 0.3, cx - lr * 0.65, cy - lr * 0.5,
          cx, cy - lr)
      ..close();
    canvas.drawPath(leaf, p);
    canvas.drawLine(Offset(cx, cy - lr * 0.85), Offset(cx, cy + lr * 0.50),
        Paint()
          ..color = Colors.white.withOpacity(0.55)
          ..strokeWidth = 1.2);
  }

  @override
  bool shouldRepaint(covariant _FilterIconPainter old) =>
      old.icon != icon || old.selected != selected;
}

// ─────────────────────────────────────────────
//  PLANT PHOTOS PAINTER
//  Remplacer par Image.asset quand assets dispo
// ─────────────────────────────────────────────
class _PlantPhotosPainter extends CustomPainter {
  final _PlantType type;
  const _PlantPhotosPainter(this.type);

  @override
  void paint(Canvas canvas, Size s) {
    // 1. Fond feuille verte
    canvas.drawRect(
        Rect.fromLTWH(0, 0, s.width, s.height),
        Paint()
          ..shader = LinearGradient(
            colors: _bgColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(Rect.fromLTWH(0, 0, s.width, s.height)));

    // 2. Nervures
    _drawVeins(canvas, s);

    // 3. Taches de maladie / symptômes
    _drawSymptoms(canvas, s);
  }

  void _drawVeins(Canvas canvas, Size s) {
    final p = Paint()
      ..color = Colors.white.withOpacity(0.18)
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;
    // Nervure centrale
    canvas.drawLine(Offset(s.width * 0.25, 0),
        Offset(s.width * 0.75, s.height), p);
    // Nervures latérales
    for (int i = 1; i <= 4; i++) {
      final t = i * 0.18;
      final ox = s.width * 0.25 + s.width * 0.5 * t;
      final oy = s.height * t;
      canvas.drawLine(Offset(ox, oy),
          Offset(ox + s.width * 0.25, oy + s.height * 0.08), p);
      canvas.drawLine(Offset(ox, oy),
          Offset(ox - s.width * 0.20, oy + s.height * 0.08), p);
    }
  }

  void _drawSymptoms(Canvas canvas, Size s) {
    final rng = math.Random(_seed);
    final sp = Paint()..style = PaintingStyle.fill;

    switch (type) {
      case _PlantType.maisRouille:
      case _PlantType.maisCarence:
      // Taches jaune/orange allongées (rouille)
        sp.color = type == _PlantType.maisRouille
            ? const Color(0xFFFF8F00).withOpacity(0.80)
            : const Color(0xFFFFD600).withOpacity(0.75);
        for (int i = 0; i < 14; i++) {
          final cx = rng.nextDouble() * s.width;
          final cy = rng.nextDouble() * s.height;
          canvas.drawOval(
              Rect.fromCenter(
                  center: Offset(cx, cy),
                  width: 4 + rng.nextDouble() * 8,
                  height: 2 + rng.nextDouble() * 4),
              sp);
        }

      case _PlantType.tomate:
      // Taches brunâtres (mildiou)
        sp.color = const Color(0xFF4E342E).withOpacity(0.65);
        for (int i = 0; i < 8; i++) {
          final r = 5.0 + rng.nextDouble() * 12;
          canvas.drawCircle(
              Offset(rng.nextDouble() * s.width,
                  rng.nextDouble() * s.height),
              r,
              sp);
        }
        sp.color = const Color(0xFF795548).withOpacity(0.45);
        for (int i = 0; i < 5; i++) {
          final r = 3.0 + rng.nextDouble() * 7;
          canvas.drawCircle(
              Offset(rng.nextDouble() * s.width,
                  rng.nextDouble() * s.height),
              r,
              sp);
        }

      case _PlantType.piment:
      // Taches jaunes (bactériennes)
        sp.color = const Color(0xFFFFEE58).withOpacity(0.70);
        for (int i = 0; i < 10; i++) {
          canvas.drawOval(
              Rect.fromCenter(
                  center: Offset(rng.nextDouble() * s.width,
                      rng.nextDouble() * s.height),
                  width: 6 + rng.nextDouble() * 10,
                  height: 4 + rng.nextDouble() * 8),
              sp);
        }

      case _PlantType.chou:
      // Surface légère, quelques trous (chenilles)
        sp.color = const Color(0xFF1B5E20).withOpacity(0.3);
        for (int i = 0; i < 6; i++) {
          canvas.drawCircle(
              Offset(rng.nextDouble() * s.width,
                  rng.nextDouble() * s.height),
              3 + rng.nextDouble() * 5,
              sp..color = Colors.white.withOpacity(0.40));
        }

      case _PlantType.manioc:
      // Mosaïque : zones claires/foncées
        sp.color = const Color(0xFF9CCC65).withOpacity(0.60);
        for (int i = 0; i < 7; i++) {
          canvas.drawOval(
              Rect.fromCenter(
                  center: Offset(rng.nextDouble() * s.width,
                      rng.nextDouble() * s.height),
                  width: 12 + rng.nextDouble() * 20,
                  height: 8 + rng.nextDouble() * 14),
              sp);
        }
        sp.color = const Color(0xFFFFE082).withOpacity(0.45);
        for (int i = 0; i < 5; i++) {
          canvas.drawOval(
              Rect.fromCenter(
                  center: Offset(rng.nextDouble() * s.width,
                      rng.nextDouble() * s.height),
                  width: 8 + rng.nextDouble() * 14,
                  height: 5 + rng.nextDouble() * 10),
              sp);
        }
    }
  }

  List<Color> get _bgColors {
    switch (type) {
      case _PlantType.maisRouille:
        return [const Color(0xFF558B2F), const Color(0xFF2E7D32)];
      case _PlantType.tomate:
        return [const Color(0xFF2E7D32), const Color(0xFF1B5E20)];
      case _PlantType.piment:
        return [const Color(0xFF388E3C), const Color(0xFF1B5E20)];
      case _PlantType.chou:
        return [const Color(0xFF81C784), const Color(0xFF43A047)];
      case _PlantType.maisCarence:
        return [const Color(0xFF689F38), const Color(0xFF33691E)];
      case _PlantType.manioc:
        return [const Color(0xFF4CAF50), const Color(0xFF2E7D32)];
    }
  }

  int get _seed {
    switch (type) {
      case _PlantType.maisRouille: return 11;
      case _PlantType.tomate:      return 22;
      case _PlantType.piment:      return 33;
      case _PlantType.chou:        return 44;
      case _PlantType.maisCarence: return 55;
      case _PlantType.manioc:      return 66;
    }
  }

  @override
  bool shouldRepaint(covariant _PlantPhotosPainter old) =>
      old.type != type;
}