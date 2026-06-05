import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phytosmart_mobile/screens/auth/loginscreen.dart';

import '../../wigdet/circularcustom.dart';

// ─────────────────────────────────────────────
//  PALETTE
// ─────────────────────────────────────────────
const _green1 = Color(0xFF1B5E20);
const _green2 = Color(0xFF2E7D32);
const _green3 = Color(0xFF4CAF50);
const _green4 = Color(0xFFE8F5E9);
const _blue2 = Color(0xFF1565C0);
const _textDk = Color(0xFF1A1A1A);
const _textMd = Color(0xFF616161);
const _textLt = Color(0xFF9E9E9E);
const _border = Color(0xFFDDDDDD);
const _fieldBg = Color(0xFFFAFAFA);

// ─────────────────────────────────────────────
//  INSCRIPTION SCREEN
// ─────────────────────────────────────────────
class InscriptionScreen extends StatefulWidget {
  const InscriptionScreen({super.key});
  @override
  State<InscriptionScreen> createState() => _InscriptionScreenState();
}

class _InscriptionScreenState extends State<InscriptionScreen>
    with SingleTickerProviderStateMixin {
  bool _showPassword = false;
  bool _showConfirm = false;
  bool _acceptTerms = true;

  final _nomCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();

  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    _locationCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // ── FOND BOKEH ────────────────────────────────────────────────
          Positioned(
            //bottom: 0,
            top: 0,
            right: 0,
            left: 0,
            child: Image.asset("assets/fonds/log_haut.png"),
          ),
          // ── CONTENU SCROLLABLE ────────────────────────────────────────
          SafeArea(
            bottom: false,
            top: false,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(children: [_buildHeroSection(), _buildFormCard()]),
            ),
          ),
        ],
      ),
    );
  }

  // ── SECTION HERO ───────────────────────────────────────────────────────
  Widget _buildHeroSection() {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Stack(
        children: [
          // Contenu centré
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 40, 0, 18),
            child: Column(
              children: [
                // Logo
                SizedBox(
                  width: 140,
                  height: 140,
                  child: Image.asset("assets/logo/logo_b.png"),
                ),
                const SizedBox(height: 10),
                // "Phyto Smart"
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Phyto ',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: _green1,
                        ),
                      ),
                      TextSpan(
                        text: 'Smart',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: _blue2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                // Slogan
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.flip(
                      flipX: true,
                      child: const Text('🌿', style: TextStyle(fontSize: 12)),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'Cultivez mieux, vivez mieux',
                      style: TextStyle(
                        fontSize: 13,
                        color: _textMd,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text('🌿', style: TextStyle(fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 16),
                // Titre "Créer un compte"
                const SizedBox(height: 6),
              ],
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
            ),
        ],
      ),
    );
  }

  // ── CARTE FORMULAIRE ───────────────────────────────────────────────────
  Widget _buildFormCard() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 24,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 20, 22, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: const Text(
                'Créer un compte',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: _textDk,
                  letterSpacing: -0.3,
                ),
              ),
            ),
            const SizedBox(height: 6),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Rejoignez la communauté et gérez vos cultures intelligemment',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13.5, color: _textMd, height: 1.45),
              ),
            ),
            const SizedBox(height: 20),

            // ── NOM COMPLET ────────────────────────────────────────────
            _Label('Nom complet'),
            const SizedBox(height: 8),
            _SimpleField(
              controller: _nomCtrl,
              hint: 'Entrez votre nom complet',
              prefixIcon: Icon(Icons.person_outline_rounded, color: _green2),
            ),
            const SizedBox(height: 18),

            // ── EMAIL ──────────────────────────────────────────────────
            _Label('Email'),
            const SizedBox(height: 8),
            _SimpleField(
              controller: _emailCtrl,
              hint: 'Entrez votre adresse email',
              prefixIcon: Icon(Icons.email_outlined, color: _green2),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 18),

            // ── NUMÉRO DE TÉLÉPHONE ────────────────────────────────────
            _Label('Numéro de téléphone'),
            const SizedBox(height: 8),
            _PhoneField(controller: _phoneCtrl),
            const SizedBox(height: 18),

            // ── MOT DE PASSE ───────────────────────────────────────────
            _Label('Mot de passe'),
            const SizedBox(height: 8),
            _PasswordField(
              controller: _passCtrl,
              hint: 'Créez un mot de passe',
              show: _showPassword,
              onToggle: () => setState(() => _showPassword = !_showPassword),
            ),
            const SizedBox(height: 18),

            // ── CONFIRMER MOT DE PASSE ─────────────────────────────────
            _Label('Confirmer le mot de passe'),
            const SizedBox(height: 8),
            _PasswordField(
              controller: _confirmCtrl,
              hint: 'Confirmez votre mot de passe',
              show: _showConfirm,
              onToggle: () => setState(() => _showConfirm = !_showConfirm),
            ),
            const SizedBox(height: 18),

            // ── LOCALISATION ───────────────────────────────────────────
            Row(
              children: const [
                Text(
                  'Localisation',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _textDk,
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  '(optionnel)',
                  style: TextStyle(
                    fontSize: 13.5,
                    color: _textLt,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _LocationField(controller: _locationCtrl),
            const SizedBox(height: 20),

            // ── CHECKBOX CGU ───────────────────────────────────────────
            _TermsRow(
              value: _acceptTerms,
              onChanged: (v) => setState(() => _acceptTerms = v ?? false),
            ),
            const SizedBox(height: 22),

            // ── BOUTON S'INSCRIRE ──────────────────────────────────────
            _SignUpButton(onTap: () {}),
            const SizedBox(height: 18),

            // ── DIVIDER "ou" ───────────────────────────────────────────
            _OrDivider(),
            const SizedBox(height: 18),

            // ── BOUTONS SOCIAUX ────────────────────────────────────────
            _SocialBtn(
              leading: Image.asset("assets/icons/google.png"),
              label: "S'inscrire avec Google",
              onTap: () {},
            ),
            const SizedBox(height: 11),
            _SocialBtn(
              leading: Icon(Icons.facebook, color: Colors.blue),
              label: "S'inscrire avec Facebook",
              onTap: () {},
            ),
            const SizedBox(height: 11),
            _SocialBtn(
              leading: Icon(Icons.apple, color: Colors.black),
              label: "S'inscrire avec Apple",
              onTap: () {},
            ),
            const SizedBox(height: 20),

            // ── "Déjà un compte ?" ─────────────────────────────────────
            Center(
              child: Column(
                children: [
                  const Text(
                    'Vous avez déjà un compte ? ',
                    style: TextStyle(fontSize: 13.5, color: _textMd),
                  ),
                  const SizedBox(height: 4),

                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: const Text(
                      'Se connecter',
                      style: TextStyle(
                        fontSize: 13.5,
                        color: _green2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ── PAYSAGE BAS ────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 100,
              //child: CustomPaint(painter: _LandscapePainter()),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  WIDGETS RÉUTILISABLES
// ─────────────────────────────────────────────

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: _textDk,
    ),
  );
}

// ── Champ simple ───────────────────────────────
class _SimpleField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Widget prefixIcon;
  final TextInputType? keyboardType;
  const _SimpleField({
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) => _FieldShell(
    child: Row(
      children: [
        const SizedBox(width: 12),
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

// ── Champ téléphone avec sélecteur pays ────────
class _PhoneField extends StatelessWidget {
  final TextEditingController controller;
  const _PhoneField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Sélecteur pays
        _FieldShell(
          width: 110,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //const SizedBox(width: 12),
              // Icône téléphone
              /*SizedBox(
                  width: 20,
                  height: 20,
                  child: Icon(Icons.phone,color: _green2,)),*/
              const SizedBox(width: 12),
              // Drapeau Cameroun
              SizedBox(
                width: 24,
                height: 16,
                child: CustomPaint(painter: _CameroonFlagPainter()),
              ),
              //const SizedBox(width: 6),
              Spacer(),
              const Text(
                '+237',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _textDk,
                ),
              ),
              const SizedBox(width: 3),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: _textMd,
                size: 18,
              ),
              const SizedBox(width: 6),
            ],
          ),
        ),
        const SizedBox(width: 10),
        // Numéro
        Expanded(
          child: _FieldShell(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontSize: 14.5, color: _textDk),
                decoration: const InputDecoration(
                  hintText: 'Entrez votre numéro',
                  hintStyle: TextStyle(fontSize: 14, color: _textLt),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Champ mot de passe ─────────────────────────
class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool show;
  final VoidCallback onToggle;
  const _PasswordField({
    required this.controller,
    required this.hint,
    required this.show,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) => _FieldShell(
    child: Row(
      children: [
        const SizedBox(width: 14),
        SizedBox(
          width: 22,
          height: 22,
          child: Icon(Icons.lock, color: _green2),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: controller,
            obscureText: !show,
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
        GestureDetector(
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Icon(
              show ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: _textLt,
              size: 20,
            ),
          ),
        ),
      ],
    ),
  );
}

// ── Champ localisation ─────────────────────────
class _LocationField extends StatelessWidget {
  final TextEditingController controller;
  const _LocationField({required this.controller});

  @override
  Widget build(BuildContext context) => _FieldShell(
    child: Row(
      children: [
        const SizedBox(width: 14),
        SizedBox(
          width: 22,
          height: 22,
          child: Icon(Icons.location_on_outlined, color: _green2),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: controller,
            style: const TextStyle(fontSize: 14.5, color: _textDk),
            decoration: const InputDecoration(
              hintText: 'Votre ville ou région',
              hintStyle: TextStyle(fontSize: 14, color: _textLt),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        // Icône cible GPS
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SizedBox(
            width: 22,
            height: 22,
            child: Icon(Icons.my_location, color: _green2),
          ),
        ),
      ],
    ),
  );
}

// ── Shell de champ (bordure arrondie) ──────────
class _FieldShell extends StatelessWidget {
  final Widget child;
  final double? width;
  const _FieldShell({required this.child, this.width});
  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: 50,
    decoration: BoxDecoration(
      color: _fieldBg,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: _border, width: 1.3),
    ),
    alignment: Alignment.centerLeft,
    child: child,
  );
}

// ── Ligne checkbox CGU ─────────────────────────
class _TermsRow extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  const _TermsRow({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Checkbox verte personnalisée
        GestureDetector(
          onTap: () => onChanged(!value),
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: value ? _green2 : Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: value ? _green2 : _border, width: 1.8),
            ),
            child: value
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 15)
                : null,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 12.5,
                color: _textMd,
                height: 1.5,
              ),
              children: [
                const TextSpan(text: "J'accepte les "),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Conditions d\'utilisation',
                      style: TextStyle(
                        fontSize: 12.5,
                        height: 1.5,
                        color: _green2,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
                const TextSpan(text: ' et la '),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Politique de confidentialité',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: _green2,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Bouton S'inscrire ──────────────────────────
class _SignUpButton extends StatelessWidget {
  final VoidCallback onTap;
  const _SignUpButton({required this.onTap});
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
            child: Icon(Icons.person_add_alt_outlined, color: Colors.white),
          ),
          const SizedBox(width: 12),
          const Text(
            "S'inscrire",
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

// ── Divider "ou" ───────────────────────────────
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
            fontSize: 13,
            color: _textLt,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      Expanded(child: Container(height: 1, color: const Color(0xFFEEEEEE))),
    ],
  );
}

// ── Bouton social ──────────────────────────────
class _SocialBtn extends StatelessWidget {
  final Widget leading;
  final String label;
  final VoidCallback onTap;
  const _SocialBtn({
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
        borderRadius: BorderRadius.circular(13),
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

// ─── DRAPEAU CAMEROUN ─────────────────────────
class _CameroonFlagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    // Vert
    canvas.drawRect(
      Rect.fromLTWH(0, 0, s.width / 3, s.height),
      Paint()..color = const Color(0xFF007A5E),
    );
    // Rouge
    canvas.drawRect(
      Rect.fromLTWH(s.width / 3, 0, s.width / 3, s.height),
      Paint()..color = const Color(0xFFCE1126),
    );
    // Jaune
    canvas.drawRect(
      Rect.fromLTWH(s.width * 2 / 3, 0, s.width / 3, s.height),
      Paint()..color = const Color(0xFFFCD116),
    );
    // Étoile jaune au centre
    _star(canvas, Offset(s.width / 2, s.height / 2), s.height * 0.28);
    // Bord arrondi
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, s.width, s.height),
        Radius.circular(2),
      ),
      Paint()
        ..color = Colors.transparent
        ..style = PaintingStyle.stroke,
    );
  }

  void _star(Canvas canvas, Offset c, double r) {
    final path = Path();
    final inner = r * 0.40;
    for (int i = 0; i < 10; i++) {
      final radius = i.isEven ? r : inner;
      final angle = i * math.pi / 5 - math.pi / 2;
      final pt = Offset(
        c.dx + radius * math.cos(angle),
        c.dy + radius * math.sin(angle),
      );
      i == 0 ? path.moveTo(pt.dx, pt.dy) : path.lineTo(pt.dx, pt.dy);
    }
    path.close();
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFFFCD116)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

/*
// ─── PAYSAGE BAS ──────────────────────────────
class _LandscapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    void hill(double yBase, double yPeak, double xPeak, Color c) {
      final path = Path()
        ..moveTo(0, yBase)
        ..lineTo(0, yPeak + (yBase - yPeak) * 0.35)
        ..quadraticBezierTo(
          xPeak,
          yPeak,
          s.width,
          yPeak + (yBase - yPeak) * 0.35,
        )
        ..lineTo(s.width, yBase)
        ..close();
      canvas.drawPath(path, Paint()..color = c);
    }

    hill(s.height, s.height * 0.52, s.width * 0.50, const Color(0xFFA5D6A7));
    hill(s.height, s.height * 0.62, s.width * 0.20, const Color(0xFF66BB6A));
    hill(s.height, s.height * 0.60, s.width * 0.80, const Color(0xFF4CAF50));
    hill(s.height, s.height * 0.72, s.width * 0.05, const Color(0xFF2E7D32));
    hill(s.height, s.height * 0.72, s.width * 0.95, const Color(0xFF388E3C));

    // Buisson gauche
    void bush(Offset base, double r) {
      canvas.drawLine(
        base,
        Offset(base.dx, base.dy - r * 2.4),
        Paint()
          ..color = const Color(0xFF33691E)
          ..strokeWidth = 2.2
          ..strokeCap = StrokeCap.round,
      );
      for (final args in [
        [-r * 1.3, 0.0, -0.4],
        [r * 1.3, 0.0, 0.4],
        [-r * 0.5, -r * 0.7, -0.6],
        [r * 0.5, -r * 0.7, 0.6],
        [0.0, -r * 1.4, 0.0],
      ]) {
        canvas.save();
        canvas.translate(
          base.dx + (args[0] as double),
          base.dy - r * 1.1 + (args[1] as double),
        );
        canvas.rotate(args[2] as double);
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(0, -r * 0.5),
            width: r * 0.55,
            height: r * 1.1,
          ),
          Paint()..color = const Color(0xFF2E7D32),
        );
        canvas.restore();
      }
    }

    bush(Offset(s.width * 0.09, s.height * 0.68), s.width * 0.055);

    // Arbre droit
    void tree(Offset base, double r) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(base.dx - r * 0.22, base.dy, r * 0.44, r * 1.5),
          Radius.circular(r * 0.14),
        ),
        Paint()..color = const Color(0xFF5D4037),
      );
      canvas.drawCircle(
        Offset(base.dx, base.dy - r * 0.28),
        r * 0.92,
        Paint()
          ..shader =
              RadialGradient(
                colors: [const Color(0xFF4CAF50), const Color(0xFF1B5E20)],
                stops: const [0.25, 1.0],
              ).createShader(
                Rect.fromCircle(
                  center: Offset(base.dx, base.dy - r * 0.28),
                  radius: r * 0.92,
                ),
              ),
      );
      canvas.drawArc(
        Rect.fromCircle(
          center: Offset(base.dx - r * 0.2, base.dy - r * 0.48),
          radius: r * 0.30,
        ),
        math.pi * 0.85,
        math.pi * 0.85,
        false,
        Paint()
          ..color = const Color(0xFF81C784).withOpacity(0.45)
          ..strokeWidth = r * 0.22
          ..style = PaintingStyle.stroke,
      );
    }

    tree(Offset(s.width * 0.87, s.height * 0.60), s.width * 0.065);
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}
*/
