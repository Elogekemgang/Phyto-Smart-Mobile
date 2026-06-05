import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phytosmart_mobile/screens/auth/registerscreen.dart';

import '../../navigation.dart';
import '../../services/auth_service.dart';
import '../../services/storage_service.dart';
import '../../wigdet/circularcustom.dart';

// ─────────────────────────────────────────────
//  PALETTE
// ─────────────────────────────────────────────
const _green1 = Color(0xFF1B5E20);
const _green2 = Color(0xFF2E7D32);
const _green3 = Color(0xFF4CAF50);
const _green4 = Color(0xFFE8F5E9);
const _blue1 = Color(0xFF0D47A1);
const _blue2 = Color(0xFF1565C0);
const _textDk = Color(0xFF1A1A1A);
const _textMd = Color(0xFF616161);
const _textLt = Color(0xFF9E9E9E);
const _border = Color(0xFFDDDDDD);

// ─────────────────────────────────────────────
//  LOGIN SCREEN
// ─────────────────────────────────────────────
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool _showPassword = false;
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  final authService = AuthService();
  bool loading = false;

  Future login() async {
    setState(() {
      loading = true;
    });

    try {
      final response = await authService.login(
        email: _emailCtrl.text,
        password: _passCtrl.text,
      );
      if (response.statusCode == 400) {
        //await StorageService.clearToken(); // On efface le token mort
        // Rediriger vers LoginScreen
        //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false,);
      }
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Navigation()),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Erreur de connexion")));
      }
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // ── 1. FOND AVEC FEUILLES BOKEH ──────────────────────────────
          //Positioned.fill(child: CustomPaint(painter: _BackgroundPainter())),
          Positioned(
            //bottom: 0,
            top: 0,
            right: 0,
            left: 0,
            child: Image.asset("assets/fonds/log_haut.png"),
          ),

          // ── 2. CONTENU SCROLLABLE ─────────────────────────────────────
          SafeArea(
            bottom: false,
            top: false,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  // ── LOGO + TITRE ──────────────────────────────────────
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: SizedBox(
                      height: size.height * 0.35,
                      child: _buildLogoSection(),
                    ),
                  ),

                  // ── CARTE BLANCHE ─────────────────────────────────────
                  _buildFormCard(size),
                ],
              ),
            ),
          ),
          if (loading)
            Positioned.fill(
              child: AbsorbPointer(
                absorbing: true, // Bloque les touches
                child: Container(
                  color: Colors.black.withOpacity(0.2), // Diminuer un peu la luminosité
                  child: const Center(child: SpinKitFadingCircle(color: _green2)),
                ),
              ),
            ),        ],
      ),
    );
  }

  // ── SECTION LOGO ───────────────────────────────────────────────────────
  Widget _buildLogoSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        // Grand logo PS
        SizedBox(
          width: 140,
          height: 140,
          child: Image.asset("assets/logo/logo_b.png"),
          //child: CustomPaint(painter: _BigPSLogoPainter()),
        ),
        const SizedBox(height: 14),
        // "Phyto Smart"
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Phyto ',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: _green1,
                  letterSpacing: 0.5,
                ),
              ),
              TextSpan(
                text: 'Smart',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: _blue2,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Slogan
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.flip(
              flipX: true,
              child: const Text('🌿', style: TextStyle(fontSize: 14)),
            ),
            const SizedBox(width: 6),
            const Text(
              'Cultivez mieux, vivez mieux',
              style: TextStyle(
                fontSize: 14.5,
                color: _textMd,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(width: 6),
            const Text('🌿', style: TextStyle(fontSize: 14)),
          ],
        ),
      ],
    );
  }

  // ── CARTE FORMULAIRE ───────────────────────────────────────────────────
  Widget _buildFormCard(Size size) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 30,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 0),
            child: Column(
              children: [
                // Titre
                const Text(
                  'Bienvenue !',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: _textDk,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Connectez-vous à votre compte',
                  style: TextStyle(fontSize: 14.5, color: _textMd),
                ),
                const SizedBox(height: 20),

                // ── EMAIL ─────────────────────────────────────────────
                _FieldLabel(label: 'Email ou numéro de téléphone'),
                const SizedBox(height: 8),
                _InputField(
                  controller: _emailCtrl,
                  hint: 'Entrez votre email ou téléphone',
                  prefixIcon: Icon(Icons.email_outlined, color: _green2),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 18),

                // ── MOT DE PASSE ──────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const _FieldLabel(label: 'Mot de passe'),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'Mot de passe oublié ?',
                        style: TextStyle(
                          fontSize: 13.5,
                          color: _green2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _PasswordField(
                  controller: _passCtrl,
                  show: _showPassword,
                  onToggle: () =>
                      setState(() => _showPassword = !_showPassword),
                ),
                const SizedBox(height: 28),

                // ── BOUTON CONNEXION ──────────────────────────────────
                _ConnectButton(
                  onTap: () {
                    login();
                  },
                ),
                const SizedBox(height: 18),

                // ── DIVIDER "ou" ──────────────────────────────────────
                _OrDivider(),
                const SizedBox(height: 18),

                // ── BOUTONS SOCIAUX ───────────────────────────────────
                _SocialButton(
                  leading: Image.asset("assets/icons/google.png"),
                  label: 'Continuer avec Google',
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                _SocialButton(
                  leading: Icon(Icons.facebook, color: Colors.blue),
                  label: 'Continuer avec Facebook',
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                _SocialButton(
                  leading: Icon(Icons.apple),
                  label: 'Continuer avec Apple',
                  onTap: () {},
                ),
                const SizedBox(height: 26),

                // ── INSCRIPTION ───────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Vous n'avez pas encore de compte ?",
                      style: TextStyle(fontSize: 13.5, color: _textMd),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InscriptionScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Créer un compte',
                    style: TextStyle(
                      fontSize: 14.5,
                      color: _green2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // ── PAYSAGE ───────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 110,
                  //child: CustomPaint(painter: _LandscapePainter()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  FIELD LABEL
// ─────────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});
  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: _textDk,
      ),
    ),
  );
}

// ─────────────────────────────────────────────
//  INPUT FIELD (email)
// ─────────────────────────────────────────────
class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Widget prefixIcon;
  final TextInputType? keyboardType;
  const _InputField({
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _border, width: 1.3),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          SizedBox(width: 22, height: 22, child: prefixIcon),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: const TextStyle(fontSize: 14.5, color: _textDk),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(fontSize: 14, color: _textLt),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(width: 14),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  PASSWORD FIELD
// ─────────────────────────────────────────────
class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool show;
  final VoidCallback onToggle;
  const _PasswordField({
    required this.controller,
    required this.show,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _border, width: 1.3),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          SizedBox(
            width: 22,
            height: 22,
            child: Icon(Icons.lock_outline, color: _green2),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: !show,
              style: const TextStyle(fontSize: 14.5, color: _textDk),
              decoration: const InputDecoration(
                hintText: 'Entrez votre mot de passe',
                hintStyle: TextStyle(fontSize: 14, color: _textLt),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          GestureDetector(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Icon(
                show
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: _textLt,
                size: 21,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  BOUTON CONNEXION
// ─────────────────────────────────────────────
class _ConnectButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ConnectButton({required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: _green2.withOpacity(0.35),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Icon(Icons.login, color: Colors.white),
          ),
          const SizedBox(width: 12),
          const Text(
            'Se connecter',
            style: TextStyle(
              fontSize: 16.5,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    ),
  );
}

// ─────────────────────────────────────────────
//  DIVIDER "ou"
// ─────────────────────────────────────────────
class _OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(child: Container(height: 1, color: const Color(0xFFEEEEEE))),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          'ou',
          style: TextStyle(
            fontSize: 13.5,
            color: _textLt,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      Expanded(child: Container(height: 1, color: const Color(0xFFEEEEEE))),
    ],
  );
}

// ─────────────────────────────────────────────
//  SOCIAL BUTTON
// ─────────────────────────────────────────────
class _SocialButton extends StatelessWidget {
  final Widget leading;
  final String label;
  final VoidCallback onTap;
  const _SocialButton({
    required this.leading,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _border, width: 1.3),
      ),
      child: Row(
        children: [
          const SizedBox(width: 18),
          SizedBox(width: 30, height: 30, child: leading),
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: _textDk,
              ),
            ),
          ),
          const SizedBox(width: 46),
        ],
      ),
    ),
  );
}

// ══════════════════════════════════════════════
//  PAINTERS
// ══════════════════════════════════════════════
/*
// ─── PAYSAGE BAS (collines + plantes + arbre) ─
class _LandscapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    // ── Colline arrière (vert pâle) ──────────────
    _hill(
      canvas,
      s,
      yBase: s.height,
      yPeak: s.height * 0.55,
      xPeak: s.width * 0.50,
      color: const Color(0xFFA5D6A7),
    );

    // ── Colline milieu-gauche (vert moyen) ───────
    _hill(
      canvas,
      s,
      yBase: s.height,
      yPeak: s.height * 0.65,
      xPeak: s.width * 0.18,
      color: const Color(0xFF66BB6A),
    );

    // ── Colline milieu-droite ────────────────────
    _hill(
      canvas,
      s,
      yBase: s.height,
      yPeak: s.height * 0.62,
      xPeak: s.width * 0.82,
      color: const Color(0xFF4CAF50),
    );

    // ── Colline avant gauche (vert foncé) ────────
    _hill(
      canvas,
      s,
      yBase: s.height,
      yPeak: s.height * 0.72,
      xPeak: s.width * 0.05,
      color: const Color(0xFF2E7D32),
    );

    // ── Colline avant droite ─────────────────────
    _hill(
      canvas,
      s,
      yBase: s.height,
      yPeak: s.height * 0.72,
      xPeak: s.width * 0.95,
      color: const Color(0xFF388E3C),
    );

    // ── Chemin central clair ─────────────────────
    final path = Paint()..color = const Color(0xFF81C784).withOpacity(0.40);
    final pathShape = Path()
      ..moveTo(s.width * 0.35, s.height)
      ..lineTo(s.width * 0.42, s.height * 0.64)
      ..lineTo(s.width * 0.58, s.height * 0.64)
      ..lineTo(s.width * 0.65, s.height)
      ..close();
    canvas.drawPath(pathShape, path);

    // ── Plante/buisson gauche ────────────────────
    _bush(canvas, Offset(s.width * 0.08, s.height * 0.68), s.width * 0.06);

    // ── Arbre droit ──────────────────────────────
    _tree(canvas, Offset(s.width * 0.88, s.height * 0.62), s.width * 0.07);
  }

  void _hill(
    Canvas canvas,
    Size s, {
    required double yBase,
    required double yPeak,
    required double xPeak,
    required Color color,
  }) {
    final path = Path()
      ..moveTo(0, yBase)
      ..lineTo(0, yPeak + (yBase - yPeak) * 0.35)
      ..quadraticBezierTo(xPeak, yPeak, s.width, yPeak + (yBase - yPeak) * 0.35)
      ..lineTo(s.width, yBase)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  void _bush(Canvas canvas, Offset base, double r) {
    final p = Paint()
      ..color = const Color(0xFF1B5E20)
      ..style = PaintingStyle.fill;
    // Tige
    canvas.drawLine(
      base,
      Offset(base.dx, base.dy - r * 2.5),
      Paint()
        ..color = const Color(0xFF33691E)
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );
    // Petites feuilles
    void leaflet(double dx, double dy, double len, double angle) {
      canvas.save();
      canvas.translate(base.dx + dx, base.dy - r * 1.2 + dy);
      canvas.rotate(angle);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(0, -len * 0.5),
          width: len * 0.55,
          height: len,
        ),
        p..color = const Color(0xFF2E7D32),
      );
      canvas.restore();
    }

    leaflet(-r * 1.4, 0, r * 1.4, -0.4);
    leaflet(r * 1.4, 0, r * 1.3, 0.4);
    leaflet(-r * 0.6, -r * 0.8, r * 1.1, -0.6);
    leaflet(r * 0.6, -r * 0.8, r * 1.0, 0.6);
    leaflet(0, -r * 1.5, r * 1.2, 0.0);
  }

  void _tree(Canvas canvas, Offset base, double r) {
    // Tronc
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(base.dx - r * 0.22, base.dy, r * 0.44, r * 1.6),
        Radius.circular(r * 0.15),
      ),
      Paint()..color = const Color(0xFF5D4037),
    );
    // Feuillage (cercle)
    canvas.drawCircle(
      Offset(base.dx, base.dy - r * 0.3),
      r * 0.95,
      Paint()
        ..shader =
            RadialGradient(
              colors: [const Color(0xFF4CAF50), const Color(0xFF1B5E20)],
              stops: const [0.3, 1.0],
            ).createShader(
              Rect.fromCircle(
                center: Offset(base.dx, base.dy - r * 0.3),
                radius: r * 0.95,
              ),
            ),
    );
    // Reflet feuillage
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(base.dx - r * 0.2, base.dy - r * 0.5),
        radius: r * 0.35,
      ),
      math.pi * 0.9,
      math.pi * 0.8,
      false,
      Paint()
        ..color = const Color(0xFF81C784).withOpacity(0.45)
        ..strokeWidth = r * 0.25
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}
*/
