import 'package:flutter/material.dart';
import 'package:phytosmart_mobile/screens/analyse/analyseaiscreen.dart';
import 'package:phytosmart_mobile/screens/cultures/culture.dart';

// ─────────────────────────────────────────────
//  PALETTE
// ─────────────────────────────────────────────
const _green1 = Color(0xFF1B5E20); // titres
const _green2 = Color(0xFF2E7D32); // primaire
const _green3 = Color(0xFF4CAF50); // boutons / icônes
const _green4 = Color(0xFFE8F5E9); // fonds cards verts clairs
const _green5 = Color(0xFFC8E6C9); // bordures vertes
const _blue1 = Color(0xFF0D47A1); // "Smart"
const _blue2 = Color(0xFF1565C0);
const _orange = Color(0xFFFF6F00); // heure critique
const _textDark = Color(0xFF212121);
const _textMed = Color(0xFF616161);
const _textLight = Color(0xFF9E9E9E);

// ─────────────────────────────────────────────
//  HOME SCREEN
// ─────────────────────────────────────────────
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── HERO BANNER ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: SizedBox(
              height: 158,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Feuille en arrière-plan (droite)
                  Positioned(
                    bottom: -10,
                    child: SizedBox(
                      width: size.width,
                      child: Image.asset("assets/1780030266092.png"),
                    ),
                  ),
                  // Textes
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 170, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Text(
                              'Bonjour, Jean !',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: _green1,
                                height: 1.2,
                              ),
                            ),
                            SizedBox(width: 6),
                            Text('👋', style: TextStyle(fontSize: 24)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Prenez soin de vos plantes,\nnous prenons soin de vos cultures.',
                          style: TextStyle(
                            fontSize: 13.5,
                            color: _textMed,
                            height: 1.55,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(bottom: -50, left: 15, child: _WeatherCard()),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 22)),

          // ── DIAGNOSTIC CARD ──────────────────────────────────────────────
          const SliverPadding(
            padding: EdgeInsetsGeometry.only(top: 18, left: 12, right: 12),
            sliver: SliverToBoxAdapter(child: _DiagnosticCard()),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 18)),

          // ── MES CULTURES ─────────────────────────────────────────────────
          SliverToBoxAdapter(child: _buildSectionHeader('Mes cultures')),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          const SliverToBoxAdapter(child: _CulturesRow()),
          const SliverToBoxAdapter(child: SizedBox(height: 18)),

          // ── TÂCHES DU JOUR ───────────────────────────────────────────────
          SliverToBoxAdapter(child: _buildSectionHeader('Tâches du jour')),
          //const SliverToBoxAdapter(child: SizedBox(height: 10)),
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverToBoxAdapter(child: _TasksList()),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 28)),
        ],
      ),
    );
  }

  // ── SECTION HEADER ──────────────────────────────────────────────────────
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: _textDark,
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Voir tout',
              style: TextStyle(
                fontSize: 13.5,
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
//  WEATHER CARD
// ─────────────────────────────────────────────
class _WeatherCard extends StatelessWidget {
  const _WeatherCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.09),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icône météo
          const Text('⛅', style: TextStyle(fontSize: 42)),
          const SizedBox(width: 14),
          // Temp + description
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '28°C',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: _textDark,
                ),
              ),
              Text(
                'Partiellement\nnuageux',
                style: TextStyle(fontSize: 12, color: _textMed, height: 1.45),
              ),
            ],
          ),
          // Séparateur vertical
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            width: 1.2,
            height: 60,
            color: const Color(0xFFE0E0E0),
          ),
          // Détails
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _WeatherDetail(emoji: '📍', text: 'Yaoundé, Cameroun'),
              const SizedBox(height: 5),
              _WeatherDetail(emoji: '💧', text: 'Humidité : 65%'),
              const SizedBox(height: 5),
              _WeatherDetail(emoji: '💨', text: 'Vent : 12 km/h'),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeatherDetail extends StatelessWidget {
  final String emoji, text;
  const _WeatherDetail({required this.emoji, required this.text});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 13)),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(fontSize: 12, color: _textDark)),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  DIAGNOSTIC CARD
// ─────────────────────────────────────────────
class _DiagnosticCard extends StatelessWidget {
  const _DiagnosticCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      decoration: BoxDecoration(
        color: _green4,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _green5, width: 1.2),
      ),
      child: Column(
        children: [
          // Haut : icône + texte + flèche
          Row(
            //mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icône scan
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _green3.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Image.asset("assets/images/scan.png"),
                ),
              ),
              const SizedBox(width: 18),
              // Texte
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Diagnostic intelligent',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: _textDark,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Prenez une photo d\'une plante\npour détecter maladies, carences\net obtenir des solutions.',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: _textMed,
                        //height: 1.5
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, color: _textMed, size: 22),
            ],
          ),
          const SizedBox(height: 16),
          // Bouton
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AnalyseIAScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _green2,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(
                Icons.camera_alt_outlined,
                size: 20,
                color: Colors.white,
              ),
              label: const Text(
                'Diagnostiquer une plante',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  MES CULTURES — LISTE HORIZONTALE
// ─────────────────────────────────────────────
class _CulturesRow extends StatelessWidget {
  const _CulturesRow();

  static const _crops = [
    _CropData('Maïs', 'En croissance', 0.65, _Crop.mais),
    _CropData('Piment', 'En croissance', 0.40, _Crop.piment),
    _CropData('Tomate', 'En croissance', 0.70, _Crop.tomate),
    _CropData('Manioc', 'Plantation', 0.25, _Crop.manioc),
  ];

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>CultureDetailScreen()));
      },
      child: SizedBox(
        height: 190,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          physics: const BouncingScrollPhysics(),
          itemCount: _crops.length,
          separatorBuilder: (_, _) => const SizedBox(width: 14),
          itemBuilder: (_, i) => _CropCard(data: _crops[i]),
        ),
      ),
    );
  }
}

enum _Crop { mais, piment, tomate, manioc }

class _CropData {
  final String name, status;
  final double progress;
  final _Crop type;
  const _CropData(this.name, this.status, this.progress, this.type);
}

class _CropCard extends StatelessWidget {
  final _CropData data;
  const _CropCard({required this.data});

  Color get _progressColor {
    if (data.progress < 0.35) return Colors.orange;
    return _green3;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _green5),
        /*boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 3),
          ),
        ],*/
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image zone
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: SizedBox(
                  width: 140,
                  height: 100,
                  child: Image.asset(
                    'assets/plantes/${data.type.name}.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Infos
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 18, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.name,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: _textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      data.status,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: _green3,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: data.progress,
                              backgroundColor: const Color(0xFFE0E0E0),
                              color: _progressColor,
                              minHeight: 5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${(data.progress * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: _textMed,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Badge icône en bas à gauche
          Positioned(
            //bottom: 14,
            top: 80,
            left: 10,
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage(
                  "assets/plantes/one/${data.type.name}.jpg",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  TÂCHES DU JOUR
// ─────────────────────────────────────────────
class _TasksList extends StatelessWidget {
  const _TasksList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TaskItem(
          iconBg: _green2,
          icon: Icons.water_drop_outlined,
          title: 'Arrosage',
          subtitle: 'Piment – Parcelle 1',
          time: '09:00',
          timeColor: _green2,
        ),
        const _TaskDivider(),
        _TaskItem(
          iconBg: const Color(0xFFFFA000),
          //icon: Icons.spray_outlined,
          icon: Icons.water_drop_outlined,
          iconOverride: Icons.cleaning_services_outlined,
          title: 'Pulvérisation',
          subtitle: 'Maïs – Parcelle 2',
          time: '16:00',
          timeColor: _orange,
        ),
        const _TaskDivider(),
        _TaskItem(
          iconBg: _green2,
          icon: Icons.local_florist_outlined,
          title: 'Sarclage',
          subtitle: 'Tomate – Parcelle 1',
          time: 'Demain',
          timeColor: _green2,
        ),
        const SizedBox(height: 14),
        // Astuce du jour
        _AstuceCard(),
      ],
    );
  }
}

class _TaskDivider extends StatelessWidget {
  const _TaskDivider();
  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFF5F5F5),
      indent: 62,
    );
  }
}

class _TaskItem extends StatelessWidget {
  final Color iconBg;
  final IconData icon;
  final IconData? iconOverride;
  final String title, subtitle, time;
  final Color timeColor;

  const _TaskItem({
    required this.iconBg,
    required this.icon,
    this.iconOverride,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.timeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // Icône cercle
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(iconOverride ?? icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          // Titre + sous-titre
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12.5, color: _textMed),
                ),
              ],
            ),
          ),
          // Heure
          Text(
            time,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: timeColor,
            ),
          ),
          const SizedBox(width: 12),
          // Checkbox circle
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFBDBDBD), width: 1.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _AstuceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: _green4,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _green5, width: 1.0),
      ),
      child: Row(
        children: [
          const Text('💡', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Astuce du jour : ',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _green1,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Évitez l\'excès d\'eau pour prévenir les maladies fongiques.',
                    style: TextStyle(
                      fontSize: 13,
                      color: _textDark,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: _textMed, size: 20),
        ],
      ),
    );
  }
}
