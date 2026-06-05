import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:phytosmart_mobile/screens/auth/loginscreen.dart';
import 'package:phytosmart_mobile/screens/login.dart';

import '../../services/auth_service.dart';

// ─────────────────────────────────────────────
//  PALETTE
// ─────────────────────────────────────────────
const _green1 = Color(0xFF1B5E20);
const _green2 = Color(0xFF2E7D32);
const _green3 = Color(0xFF4CAF50);
const _green4 = Color(0xFFE8F5E9);
const _green5 = Color(0xFFF1F8E9);
const _green6 = Color(0xFFC8E6C9);
const _blue1 = Color(0xFF0D47A1);
const _amber = Color(0xFFFF8F00);
const _amberBg = Color(0xFFFFF8E1);
const _red = Color(0xFFE53935);
const _redBg = Color(0xFFFFEBEE);
const _textDk = Color(0xFF1A1A1A);
const _textMd = Color(0xFF616161);
const _textLt = Color(0xFF9E9E9E);
const _divider = Color(0xFFF2F2F2);
const _cardBg = Colors.white;

// ─────────────────────────────────────────────
//  PROFIL SCREEN
// ─────────────────────────────────────────────
class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── APP BAR ─────────────────────────────────────────────────
          /*SliverToBoxAdapter(
            child: SafeArea(bottom: false, child: _buildAppBar()),
          ),*/

          // ── PROFIL HEADER ────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
              child: _buildProfileHeader(),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 18)),

          // ── BANNIÈRE PRO ─────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverToBoxAdapter(child: _buildProBanner()),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 18)),

          // ── MES INFORMATIONS ─────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverToBoxAdapter(
              child: _MenuSection(
                title: 'Mes informations',
                items: [
                  _MenuItem(
                    iconData: Icons.person_outline_rounded,
                    iconBg: _green4,
                    iconColor: _green2,
                    label: 'Informations personnelles',
                    ontap: () {},
                  ),
                  _MenuItem(
                    iconData: Icons.location_on_outlined,
                    iconBg: _green4,
                    iconColor: _green2,
                    label: 'Ma ferme et parcelles',
                    ontap: () {},
                  ),
                  _MenuItem(
                    iconData: Icons.eco_outlined,
                    iconBg: _green4,
                    iconColor: _green2,
                    label: 'Préférences de culture',
                    ontap: () {},
                  ),
                  _MenuItem(
                    iconData: Icons.notifications_outlined,
                    iconBg: _green4,
                    iconColor: _green2,
                    label: 'Paramètres des notifications',
                    ontap: () {},
                  ),
                  _MenuItem(
                    iconData: Icons.language_rounded,
                    iconBg: _green4,
                    iconColor: _green2,
                    label: 'Langue',
                    trailingLabel: 'Français',
                    ontap: () {},
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 14)),

          // ── MES OUTILS ───────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverToBoxAdapter(
              child: _MenuSection(
                title: 'Mes outils',
                items: [
                  _MenuItem(
                    iconData: Icons.note_alt_outlined,
                    iconBg: _green4,
                    iconColor: _green2,
                    label: 'Historique des diagnostics',
                    ontap: () {},
                  ),
                  _MenuItem(
                    iconData: Icons.menu_book_outlined,
                    iconBg: _green4,
                    iconColor: _green2,
                    label: 'Carnet agricole',
                    ontap: () {},
                  ),
                  _MenuItem(
                    iconData: Icons.check_circle_rounded,
                    iconBg: _green4,
                    iconColor: _green2,
                    label: 'Mes tâches terminées',
                    ontap: () {},
                  ),
                  _MenuItem(
                    iconData: Icons.cloud_download_outlined,
                    iconBg: Color(0xFFE3F2FD),
                    iconColor: Color(0xFF1565C0),
                    label: 'Sauvegarde et synchronisation',
                    ontap: () {},
                  ),
                  _MenuItem(
                    iconData: Icons.file_download_outlined,
                    iconBg: _green4,
                    iconColor: _green2,
                    label: 'Exporter mes données',
                    ontap: () {},
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 14)),

          // ── AUTRES ───────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverToBoxAdapter(
              child: _MenuSection(
                title: 'Autres',
                items: [
                  _MenuItem(
                    iconData: Icons.help_outline_rounded,
                    iconBg: _amberBg,
                    iconColor: _amber,
                    label: 'Aide et support',
                    ontap: () {},
                  ),
                  _MenuItem(
                    iconData: Icons.info_outline_rounded,
                    iconBg: _green4,
                    iconColor: _green2,
                    label: 'À propos de Phyto Smart',
                    ontap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: "Phyto Smart",
                        applicationVersion: "V1.0.0",
                        applicationIcon: Image.asset(
                          "assets/logo/logo_b.png",
                          width: 50,
                        ),
                        children: [
                          Text(
                            "Application de detection des maladies des plantes et d'aide a la culture.",
                          ),
                        ],
                      );
                    },
                  ),
                  _MenuItem(
                    iconData: Icons.logout,
                    iconBg: _redBg,
                    iconColor: _red,
                    label: 'Déconnexion',
                    isDestructive: true,
                    showChevron: false,
                    ontap: () {
                      authService.logout();

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  // ── APP BAR ────────────────────────────────────────────────────────────
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 16, 8),
      child: Row(
        children: [
          // Logo PS
          SizedBox(
            width: 42,
            height: 42,
            child: Image.asset("assets/logo/logo_b.png"),
          ),
          const SizedBox(width: 10),
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Phyto ',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: _green2,
                  ),
                ),
                TextSpan(
                  text: 'Smart',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: _blue1,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // Cloche + badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              _IconBtn(
                child: const Icon(
                  Icons.notifications_outlined,
                  color: _textDk,
                  size: 23,
                ),
              ),
              Positioned(
                top: -3,
                right: -3,
                child: Container(
                  width: 19,
                  height: 19,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          // Engrenage
          _IconBtn(
            child: const Icon(
              Icons.settings_outlined,
              color: _green2,
              size: 23,
            ),
          ),
        ],
      ),
    );
  }

  // ── PROFILE HEADER ─────────────────────────────────────────────────────
  Widget _buildProfileHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Avatar + badge caméra
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _green6, width: 2.5),
              ),
              child: ClipOval(
                // ── Remplacer par Image.asset('assets/images/avatar.jpg')
                child: Image.asset('assets/avatar.png', fit: BoxFit.cover),
              ),
            ),
            // Badge caméra
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: _green6, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.camera_alt_rounded,
                    color: _green2,
                    size: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        // Infos + bouton
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: Text(
                      'Jean Dupont',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: _textDk,
                        height: 1.2,
                      ),
                    ),
                  ),
                  // Bouton Modifier
                  GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFDDDDDD),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.edit_outlined, size: 15, color: _green2),
                          SizedBox(width: 5),
                          Text(
                            'Modifier',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _textDk,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              _InfoRow(
                icon: Icons.eco_outlined,
                label: 'Agriculteur',
                bold: true,
              ),
              const SizedBox(height: 2),
              _InfoRow(
                icon: Icons.location_on_outlined,
                label: 'Yaoundé, Cameroun',
              ),
              const SizedBox(height: 2),
              _InfoRow(icon: Icons.phone_outlined, label: '+237 6 95 12 34 56'),
              const SizedBox(height: 2),
              _InfoRow(
                icon: Icons.email_outlined,
                label: 'jean.dupont@gmail.com',
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── BANNIÈRE ABONNEMENT PRO ────────────────────────────────────────────
  Widget _buildProBanner() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: BoxDecoration(
        color: _green4,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _green6, width: 1),
      ),
      child: Row(
        children: [
          // Couronne
          SizedBox(
            width: 50,
            height: 50,
            child: CustomPaint(painter: _GoldMedalPainter()),
          ),
          const SizedBox(width: 12),
          // Texte
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Abonnement Pro',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: _green1,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: _green2,
                          borderRadius: BorderRadius.circular(8),
                        ),

                        child: const Text(
                          'Gérer mon abonnement',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                const Text(
                  'Profitez de toutes les fonctionnalités avancées et du mode hors ligne.',
                  style: TextStyle(fontSize: 12, color: _textMd, height: 1.45),
                ),
              ],
            ),
          ), // Bouton
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  INFO ROW
// ─────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool bold;
  const _InfoRow({required this.icon, required this.label, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: _green3, size: 16),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.5,
              color: bold ? _green2 : _textMd,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  MENU SECTION
// ─────────────────────────────────────────────
class _MenuSection extends StatelessWidget {
  final String title;
  final List<_MenuItem> items;
  const _MenuSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: _textDk,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: _cardBg,
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
          child: Column(
            children: List.generate(items.length, (i) {
              return Column(
                children: [
                  items[i],
                  if (i < items.length - 1)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: _divider,
                      indent: 62,
                      endIndent: 0,
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  MENU ITEM
// ─────────────────────────────────────────────
class _MenuItem extends StatelessWidget {
  final IconData iconData;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String? trailingLabel;
  final bool showChevron;
  final bool isDestructive;
  final GestureTapCallback ontap;

  const _MenuItem({
    required this.iconData,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    this.trailingLabel,
    this.showChevron = true,
    this.isDestructive = false,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Icône
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Center(child: Icon(iconData, color: iconColor, size: 19)),
            ),
            const SizedBox(width: 14),
            // Label
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14.5,
                  color: isDestructive ? _red : _textDk,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Trailing label (ex: "Français")
            if (trailingLabel != null) ...[
              Text(
                trailingLabel!,
                style: const TextStyle(
                  fontSize: 14,
                  color: _green3,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
            ],
            // Chevron
            if (showChevron)
              const Icon(Icons.chevron_right_rounded, color: _textLt, size: 22),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  ICON BUTTON HELPER
// ─────────────────────────────────────────────
class _IconBtn extends StatelessWidget {
  final Widget child;
  const _IconBtn({required this.child});
  @override
  Widget build(BuildContext context) => Container(
    width: 42,
    height: 42,
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.07),
          blurRadius: 8,
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
