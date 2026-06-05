import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../analyse/camerascreen.dart';


// ─────────────────────────────────────────────
//  PALETTE
// ─────────────────────────────────────────────
const _green1   = Color(0xFF1B5E20);
const _green2   = Color(0xFF2E7D32);
const _green3   = Color(0xFF4CAF50);
const _green4   = Color(0xFFE8F5E9);
const _green5   = Color(0xFFF1F8E9);
const _green6   = Color(0xFFC8E6C9);
const _blue2    = Color(0xFF1565C0);
const _blueBg   = Color(0xFFE3F2FD);
const _orange   = Color(0xFFE65100);
const _orangeL  = Color(0xFFF57C00);
const _orangeBg = Color(0xFFFFF3E0);
const _purple   = Color(0xFF7B1FA2);
const _purpleBg = Color(0xFFF3E5F5);
const _textDk   = Color(0xFF1A1A1A);
const _textMd   = Color(0xFF616161);
const _textLt   = Color(0xFF9E9E9E);
const _divider  = Color(0xFFF2F2F2);

// ─────────────────────────────────────────────
//  CULTURE DETAIL SCREEN
// ─────────────────────────────────────────────
class CultureDetailScreen extends StatefulWidget {
  const CultureDetailScreen({super.key});
  @override
  State<CultureDetailScreen> createState() => _CultureDetailScreenState();
}

class _CultureDetailScreenState extends State<CultureDetailScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progCtrl;
  late final Animation<double> _progAnim;

  @override
  void initState() {
    super.initState();
    _progCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
    _progAnim = Tween<double>(begin: 0, end: 0.65)
        .animate(CurvedAnimation(parent: _progCtrl, curve: Curves.easeOutCubic));
    _progCtrl.forward();
  }

  @override
  void dispose() { _progCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: Column(children: [
        SafeArea(bottom: false, child: _buildTopBar()),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            physics: const BouncingScrollPhysics(),
            children: [
              _buildMainCard(),
              const SizedBox(height: 14),
              _buildSanteCard(),
              const SizedBox(height: 20),
              _buildSectionTitle('Aperçu rapide'),
              const SizedBox(height: 12),
              _buildApercuRapide(),
              const SizedBox(height: 22),
              _buildTasksSection(),
              const SizedBox(height: 14),
              _buildConseilsCard(),
              const SizedBox(height: 22),
              _buildHistoriqueSection(),
              const SizedBox(height: 18),
              _buildBottomButtons(),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ]),
    );
  }

  // ── TOP BAR ──────────────────────────────────────────────────────────
  Widget _buildTopBar() => Padding(
    padding: const EdgeInsets.fromLTRB(6, 8, 12, 4),
    child: Row(children: [
      IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: _textDk),
          onPressed: () {Navigator.pop(context);}, visualDensity: VisualDensity.compact),
      const Expanded(child: Text('Culture', textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _textDk))),
      IconButton(icon: const Icon(Icons.edit_outlined, size: 20, color: _green2),
          onPressed: () {}, visualDensity: VisualDensity.compact),
      IconButton(icon: const Icon(Icons.more_horiz_rounded, size: 24, color: _textDk),
          onPressed: () {}, visualDensity: VisualDensity.compact),
    ]),
  );

  // ── MAIN CULTURE CARD ────────────────────────────────────────────────
  Widget _buildMainCard() => _WhiteCard(
    padding: const EdgeInsets.only(right: 10,),
    child: Column(children: [
      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        // Photo
        Stack(children: [
          ClipRRect(borderRadius:BorderRadius.only(topLeft: Radius.circular(12),bottomLeft: Radius.circular(12)),
              child: SizedBox(width: 110, height: 130,
                  child: Image.asset("assets/plantes/tomate.jpg",fit: BoxFit.cover,))),
          Positioned(bottom: 6, right: 6, child: Container(
            width: 28, height: 28,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0,2))]),
            child: const Center(child: Icon(Icons.camera_alt_rounded, color: _green2, size: 15)),
          )),
        ]),
        const SizedBox(width: 10),
        // Infos
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Text('Maïs', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: _textDk)),
            const SizedBox(width: 8),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: _green4, borderRadius: BorderRadius.circular(20)),
                child: const Text('En croissance',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _green2))),
          ]),
          const SizedBox(height: 8),
          _InfoLine(Icons.location_on_outlined, 'Parcelle 1'),
          const SizedBox(height: 4),
          _InfoLine(Icons.crop_square_outlined, 'Superficie : 120 m²'),
          const SizedBox(height: 4),
          _InfoLine(Icons.calendar_today_outlined, 'Date de semis : 20 Avril 2024'),
          const SizedBox(height: 4),
          _InfoLine(Icons.eco_outlined, 'Variété : OBATANPA'),
        ])),
        const SizedBox(width: 8),
        // Cercle progression
        AnimatedBuilder(animation: _progAnim, builder: (_, __) =>
            Column(children: [
              SizedBox(width: 72, height: 72,
                  child: CustomPaint(painter: _CircleProgressPainter(_progAnim.value),
                      child: Center(child: Text('${(_progAnim.value * 100).toInt()}%',
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: _textDk))))),
              const SizedBox(height: 5),
              const Text('Progression', style: TextStyle(fontSize: 11, color: _textMd, fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              const Text('J+25 / J+90', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _green2)),
            ])),
      ]),
    ]),
  );

  // ── SANTÉ DE LA CULTURE ──────────────────────────────────────────────
  Widget _buildSanteCard() => Container(
    padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
    decoration: BoxDecoration(color: _green5,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _green6, width: 1)),
    child: Row(children: [
      SizedBox(width: 32, height: 32, child: Image.asset("assets/images/secure.png")),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
        Text('Santé de la culture : Bonne',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _green2)),
        SizedBox(height: 2),
        Text('Aucune maladie majeure détectée.',
            style: TextStyle(fontSize: 12.5, color: _textMd)),
      ])),
      const SizedBox(width: 10),
      GestureDetector(child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _green6, width: 1.2)),
        child: const Text('Voir les détails', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _green2)),

      )),
    ]),
  );

  // ── APERÇU RAPIDE ────────────────────────────────────────────────────
  Widget _buildApercuRapide() {
    final items = [
      _ApercuData('État des plantes', Icons.eco_outlined, _green4, _green2,
          'Bon', _green3, 'Feuilles vertes et vigoureuses'),
      _ApercuData('Maladies détectées', Icons.bug_report_outlined, _green4, _green2,
          'Aucune', _green3, 'Aucun symptôme visible'),
      _ApercuData('Arrosage', Icons.water_drop_outlined, _blueBg, _blue2,
          'À jour', _green3, 'Prochain arrosage demain'),
      _ApercuData('Fertilisation', Icons.agriculture_outlined, _orangeBg, _orangeL,
          'À faire', _orange, 'Dans 3 jours'),
    ];
    return Row(children: items.asMap().entries.map((e) => Expanded(
        child: Padding(padding: EdgeInsets.only(right: e.key < 3 ? 8 : 0),
            child: _ApercuCard(data: e.value)),
    )).toList());
  }

  // ── TÂCHES ───────────────────────────────────────────────────────────
  Widget _buildTasksSection() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      const Text('Prochaines tâches', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: _textDk)),
      TextButton(onPressed: () {},
          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap),
          child: const Text('Voir tout', style: TextStyle(fontSize: 13.5, color: _green3, fontWeight: FontWeight.w600))),
    ]),
    const SizedBox(height: 10),
    _WhiteCard(padding: EdgeInsets.zero, child: Column(children: [
      _TaskRow(iconBg: _orangeBg, iconColor: _orangeL, icon: Icons.batch_prediction_outlined,
          title: 'Pulvérisation préventive', sub: 'Contre la chenille légionnaire',
          dateText: '16 Mai 2024', dateColor: _textMd, statusText: 'À faire', statusColor: _orange),
      const Divider(height: 1, thickness: 1, color: _divider, indent: 72),
      _TaskRow(iconBg: _blueBg, iconColor: _blue2, icon: Icons.water_drop_outlined,
          title: 'Arrosage', sub: 'Arroser le matin ou en fin de journée',
          dateText: 'Demain', dateColor: _blue2, statusText: 'À faire', statusColor: _textMd),
      const Divider(height: 1, thickness: 1, color: _divider, indent: 72),
      _TaskRow(iconBg: _purpleBg, iconColor: _purple, icon: Icons.agriculture_outlined,
          title: 'Fertilisation', sub: "Appliquer l'engrais NPK 15-15-15",
          dateText: '20 Mai 2024', dateColor: _blue2, statusText: 'À venir', statusColor: _textMd),
    ])),
  ]);

  // ── CONSEILS PERSONNALISÉS ───────────────────────────────────────────
  Widget _buildConseilsCard() => Container(
    decoration: BoxDecoration(color: _green5,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _green6, width: 1)),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(child: Padding(padding: const EdgeInsets.fromLTRB(14, 14, 8, 14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            SizedBox(width: 24, height: 24, child: Icon(Icons.lightbulb,color: Colors.yellow.shade700,)),
            const SizedBox(width: 8),
            const Text('Conseils personnalisés',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: _green2)),
          ]),
          const SizedBox(height: 10),
          ...[
            'Surveillez les attaques de pucerons sur les jeunes feuilles.',
            "Maintenez un bon drainage pour éviter l'excès d'eau.",
            'Appliquez un paillage pour conserver l\'humidité du sol.',
          ].map((t) => Padding(padding: const EdgeInsets.only(bottom: 5),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('• ', style: TextStyle(fontSize: 13, color: _textMd, height: 1.5)),
                Expanded(child: Text(t, style: const TextStyle(fontSize: 12.5, color: _textMd, height: 1.45))),
              ]))),
        ]),
      )),
      // Photo semis
      ClipRRect(borderRadius: const BorderRadius.only(topRight: Radius.circular(16), bottomRight: Radius.circular(16)),
          child: SizedBox(width: 120, height: 185, child: Image.asset("assets/plantes/mais.jpg",fit: BoxFit.cover,))),
    ]),
  );

  // ── HISTORIQUE ───────────────────────────────────────────────────────
  Widget _buildHistoriqueSection() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      const Text('Historique et suivi', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: _textDk)),
      TextButton(onPressed: () {},
          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap),
          child: const Text('Voir tout', style: TextStyle(fontSize: 13.5, color: _green3, fontWeight: FontWeight.w600))),
    ]),
    const SizedBox(height: 14),
    SizedBox(height: 110, child: ListView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      children: [
        _HistoItem(date: '20 Avr.', label: 'Semis',     isActive: false, isDone: true,  index: 0),
        _HistoItem(date: '28 Avr.', label: 'Levée',     isActive: false, isDone: true,  index: 1),
        _HistoItem(date: '05 Mai',  label: 'Croissance', isActive: false, isDone: true,  index: 2),
        _HistoItem(date: '12 Mai',  label: 'Végétatif', isActive: false, isDone: true,  index: 3),
        _HistoItem(date: '20 Mai',  label: 'Actuel',    isActive: true,  isDone: false, index: 4),
        _HistoItem(date: '02 Juin', label: 'Prochain suivi', isActive: false, isDone: false, index: 5),
      ],
    )),
  ]);

  // ── BOUTONS BAS ──────────────────────────────────────────────────────
  Widget _buildBottomButtons() => Row(children: [
    Expanded(child: GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Camerascreen(),
          ),
        );
      },
      child: Container(
        height: 40, decoration: BoxDecoration(color: _green2,
          borderRadius: BorderRadius.circular(12)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
          Icon(Icons.camera_alt_outlined, color: Colors.white, size: 20),
          SizedBox(width: 8),
          Text('Diagnostiquer culture',overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Colors.white)),
        ]),
      ),
    )),
    const SizedBox(width: 12),
    Expanded(child: GestureDetector(
      child: Container(
        height: 40, decoration: BoxDecoration(color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _green2, width: 1.8)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
          Icon(Icons.calendar_today_outlined, color: _green2, size: 18),
          SizedBox(width: 8),
          Text('Voir le calendrier',
              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: _green2)),
        ]),
      ),
    )),
  ]);

  Widget _buildSectionTitle(String t) => Text(t,
      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: _textDk));
}

// ─────────────────────────────────────────────
//  SMALL WIDGETS
// ─────────────────────────────────────────────
class _InfoLine extends StatelessWidget {
  final IconData icon; final String label;
  const _InfoLine(this.icon, this.label);
  @override
  Widget build(BuildContext context) => Row(children: [
    Icon(icon, size: 14, color: _green3),
    const SizedBox(width: 5),
    Flexible(child: Text(label, style: const TextStyle(fontSize: 12.5, color: _textMd),
        overflow: TextOverflow.ellipsis)),
  ]);
}

class _WhiteCard extends StatelessWidget {
  final Widget child; final EdgeInsetsGeometry? padding;
  const _WhiteCard({required this.child, this.padding});
  @override
  Widget build(BuildContext context) => Container(
    padding: padding ?? const EdgeInsets.all(14),
    decoration: BoxDecoration(color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0), width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
            blurRadius: 12, offset: const Offset(0, 2))]),
    child: child,
  );
}

class _ApercuData {
final String title, valueTxt, desc;
final IconData icon;
final Color iconBg, iconColor, valueColor;
const _ApercuData(this.title, this.icon, this.iconBg, this.iconColor,
    this.valueTxt, this.valueColor, this.desc);
}

class _ApercuCard extends StatelessWidget {
final _ApercuData data;
const _ApercuCard({required this.data});
@override
Widget build(BuildContext context) => Container(
  height: 140,
  width: 6,
  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
  decoration: BoxDecoration(color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFF0F0F0), width: 1),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04),
          blurRadius: 8, offset: const Offset(0, 2))]),
  child: Column(children: [
    Container(width: 44, height: 44,
        decoration: BoxDecoration(color: data.iconBg, shape: BoxShape.circle),
        child: Icon(data.icon, color: data.iconColor, size: 22)),
    const SizedBox(height: 7),
    Text(data.title, textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 10.5, color: _textMd, height: 1.3), maxLines: 1),
    const SizedBox(height: 4),
    Text(data.valueTxt, textAlign: TextAlign.center,
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: data.valueColor)),
    const SizedBox(height: 3),
    Text(data.desc, textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 10, color: _textLt, height: 1.3), maxLines: 1),
  ]),
);
}

class _TaskRow extends StatelessWidget {
  final Color iconBg, iconColor, dateColor, statusColor;
  final IconData icon;
  final String title, sub, dateText, statusText;
  const _TaskRow({required this.iconBg, required this.iconColor, required this.icon,
    required this.title, required this.sub, required this.dateText,
    required this.dateColor, required this.statusText, required this.statusColor});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    child: Row(children: [
      Container(width: 44, height: 44,
          decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 22)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _textDk)),
        const SizedBox(height: 2),
        Text(sub, style: const TextStyle(fontSize: 12, color: _textMd)),
      ])),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(dateText, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: dateColor)),
        const SizedBox(height: 2),
        Text(statusText, style: TextStyle(fontSize: 11.5, color: statusColor)),
      ]),
      const SizedBox(width: 8),
      const Icon(Icons.chevron_right_rounded, color: _textLt, size: 22),
    ]),
  );
}

class _HistoItem extends StatelessWidget {
  final String date, label;
  final bool isActive, isDone;
  final int index;
  const _HistoItem({required this.date, required this.label,
    required this.isActive, required this.isDone, required this.index});
  @override
  Widget build(BuildContext context) {
    final borderColor = isActive ? _green2 : (isDone ? _green3 : const Color(0xFFDDDDDD));
    final textColor   = isActive ? _green2 : _textMd;
    return SizedBox(width: 82, child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(alignment: Alignment.center, children: [
          Container(width: 60, height: 60,
            decoration: BoxDecoration(shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: isActive ? 3 : 2)),
            child: ClipOval(child: CustomPaint(
                painter: _HistoPhotoPainter(index, isDone || isActive))),
          ),
          if (isDone && !isActive)
            Positioned(bottom: 0, right: 0, child: Container(
              width: 20, height: 20,
              decoration: const BoxDecoration(color: _green3, shape: BoxShape.circle),
              child: const Icon(Icons.check_rounded, color: Colors.white, size: 13),
            )),
          if (isActive)
            Positioned(bottom: 0, right: 0, child: Container(
              width: 20, height: 20,
              decoration: const BoxDecoration(color: _green2, shape: BoxShape.circle),
              child: const Icon(Icons.radio_button_checked, color: Colors.white, size: 13),
            )),
        ]),
        const SizedBox(height: 6),
        Text(date, textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: textColor,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500)),
        const SizedBox(height: 2),
        Text(label, textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: textColor,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400)),
      ],
    ));
  }
}

// ══════════════════════════════════════════════
//  PAINTERS
// ══════════════════════════════════════════════

// ─── CERCLE PROGRESSION ───────────────────────
class _CircleProgressPainter extends CustomPainter {
  final double progress;
  const _CircleProgressPainter(this.progress);
  @override
  void paint(Canvas canvas, Size s) {
    final cx = s.width / 2, cy = s.height / 2, r = s.width * 0.44;
    // Track gris
    canvas.drawCircle(Offset(cx, cy), r,
        Paint()..color = const Color(0xFFE0E0E0)..strokeWidth = 8..style = PaintingStyle.stroke);
    // Arc vert
    canvas.drawArc(Rect.fromCircle(center: Offset(cx, cy), radius: r),
        -math.pi / 2, progress * 2 * math.pi, false,
        Paint()..color = _green2..strokeWidth = 8..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round);
  }
  @override
  bool shouldRepaint(covariant _CircleProgressPainter old) => old.progress != progress;
}

// ─── PHOTO MAÏS ───────────────────────────────
class _MaisPhotoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    // Ciel bleu
    canvas.drawRect(Rect.fromLTWH(0, 0, s.width, s.height * 0.5),
        Paint()..color = const Color(0xFF87CEEB));
    // Sol vert
    canvas.drawRect(Rect.fromLTWH(0, s.height * 0.5, s.width, s.height * 0.5),
        Paint()..color = const Color(0xFF558B2F));
    // Tiges maïs
    final rng = math.Random(7);
    for (int i = 0; i < 5; i++) {
      final x = s.width * (0.1 + i * 0.20);
      final h = s.height * (0.55 + rng.nextDouble() * 0.3);
      canvas.drawLine(Offset(x, s.height * 0.90), Offset(x, s.height - h),
          Paint()..color = const Color(0xFF388E3C)..strokeWidth = 4..strokeCap = StrokeCap.round);
      // Épis
      canvas.drawOval(Rect.fromCenter(center: Offset(x, s.height - h - 5),
          width: 10, height: 18),
          Paint()..color = const Color(0xFFFFCC02));
    }
    // Feuilles
    final lp = Paint()..color = const Color(0xFF4CAF50)..style = PaintingStyle.fill;
    for (int i = 0; i < 5; i++) {
      final x = s.width * (0.1 + i * 0.20);
      final y = s.height * 0.55;
      canvas.drawPath(Path()
        ..moveTo(x, y)..cubicTo(x + 18, y - 10, x + 25, y + 5, x + 8, y + 15)..close(), lp);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ─── PHOTO SEMIS (Conseils) ───────────────────
class _SeedlingPhotoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    canvas.drawRect(Rect.fromLTWH(0, 0, s.width, s.height),
        Paint()..shader = const LinearGradient(
          colors: [Color(0xFF388E3C), Color(0xFF1B5E20)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ).createShader(Rect.fromLTWH(0, 0, s.width, s.height)));
    // Sol marron
    canvas.drawRect(Rect.fromLTWH(0, s.height * 0.72, s.width, s.height * 0.28),
        Paint()..color = const Color(0xFF5D4037));
    // Jeunes plants
    final rng = math.Random(42);
    final gp = Paint()..color = const Color(0xFF66BB6A)..style = PaintingStyle.fill;
    for (int i = 0; i < 4; i++) {
      final x = s.width * (0.12 + i * 0.22);
      final h = s.height * (0.25 + rng.nextDouble() * 0.15);
      canvas.drawLine(Offset(x, s.height * 0.72), Offset(x, s.height * 0.72 - h),
          Paint()..color = const Color(0xFF4CAF50)..strokeWidth = 2.5..strokeCap = StrokeCap.round);
      // Feuilles
      canvas.drawPath(Path()
        ..moveTo(x, s.height * 0.72 - h)
        ..cubicTo(x + 10, s.height * 0.72 - h - 10, x + 15, s.height * 0.72 - h + 5, x, s.height * 0.72 - h + 10)
        ..cubicTo(x - 15, s.height * 0.72 - h + 5, x - 10, s.height * 0.72 - h - 10, x, s.height * 0.72 - h)
        ..close(), gp);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ─── PHOTO HISTORIQUE ─────────────────────────
class _HistoPhotoPainter extends CustomPainter {
  final int index; final bool active;
  const _HistoPhotoPainter(this.index, this.active);
  @override
  void paint(Canvas canvas, Size s) {
    final colors = [
      [const Color(0xFF558B2F), const Color(0xFF33691E)],
      [const Color(0xFF4CAF50), const Color(0xFF2E7D32)],
      [const Color(0xFF66BB6A), const Color(0xFF388E3C)],
      [const Color(0xFF81C784), const Color(0xFF4CAF50)],
      [const Color(0xFF4CAF50), const Color(0xFF1B5E20)],
      [const Color(0xFFB0BEC5), const Color(0xFF78909C)],
    ];
    final c = index < colors.length ? colors[index] : colors[0];
    canvas.drawRect(Rect.fromLTWH(0, 0, s.width, s.height),
        Paint()..shader = LinearGradient(colors: c.cast<Color>(),
            begin: Alignment.topLeft, end: Alignment.bottomRight)
            .createShader(Rect.fromLTWH(0, 0, s.width, s.height)));
    if (index < 5) {
      final lp = Paint()..color = Colors.white.withOpacity(0.25)..style = PaintingStyle.fill;
      canvas.drawPath(Path()
        ..moveTo(s.width / 2, s.height * 0.1)
        ..cubicTo(s.width * 0.75, s.height * 0.35, s.width * 0.75, s.height * 0.65, s.width / 2, s.height * 0.85)
        ..cubicTo(s.width * 0.25, s.height * 0.65, s.width * 0.25, s.height * 0.35, s.width / 2, s.height * 0.1)
        ..close(), lp);
    }
  }
  @override
  bool shouldRepaint(covariant _HistoPhotoPainter old) => old.index != index;
}

// ─── BOUCLIER + FEUILLE ───────────────────────
class _ShieldLeafPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()..color = _green2..strokeWidth = 2.0
      ..style = PaintingStyle.stroke..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;
    canvas.drawPath(Path()
      ..moveTo(s.width / 2, s.height * 0.04)..lineTo(s.width * 0.92, s.height * 0.20)
      ..lineTo(s.width * 0.92, s.height * 0.52)
      ..quadraticBezierTo(s.width * 0.92, s.height * 0.82, s.width / 2, s.height * 0.96)
      ..quadraticBezierTo(s.width * 0.08, s.height * 0.82, s.width * 0.08, s.height * 0.52)
      ..lineTo(s.width * 0.08, s.height * 0.20)..close(), p);
    final cx = s.width / 2, cy = s.height * 0.54, lr = s.width * 0.20;
    canvas.drawPath(Path()
      ..moveTo(cx, cy - lr)
      ..cubicTo(cx + lr * 0.6, cy - lr * 0.4, cx + lr * 0.6, cy + lr * 0.4, cx, cy + lr)
      ..cubicTo(cx - lr * 0.6, cy + lr * 0.4, cx - lr * 0.6, cy - lr * 0.4, cx, cy - lr)
      ..close(), Paint()..color = _green2..style = PaintingStyle.fill);
  }
  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ─── AMPOULE CONSEILS ─────────────────────────
class _BulbIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()..color = _green2..strokeWidth = 1.6
      ..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCenter(center: Offset(s.width / 2, s.height * 0.38),
        width: s.width * 0.68, height: s.height * 0.68),
        math.pi * 0.85, math.pi * 1.30, false, p);
    canvas.drawLine(Offset(s.width * 0.32, s.height * 0.65),
        Offset(s.width * 0.32, s.height * 0.80), p);
    canvas.drawLine(Offset(s.width * 0.68, s.height * 0.65),
        Offset(s.width * 0.68, s.height * 0.80), p);
    canvas.drawLine(Offset(s.width * 0.30, s.height * 0.80),
        Offset(s.width * 0.70, s.height * 0.80), p);
    canvas.drawLine(Offset(s.width * 0.32, s.height * 0.88),
        Offset(s.width * 0.68, s.height * 0.88), p);
    canvas.drawCircle(Offset(s.width / 2, s.height * 0.40), s.width * 0.14,
        Paint()..color = _green3..style = PaintingStyle.fill);
  }
  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}