import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'data/datasources/dummy_auth_api.dart';
import 'profile.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _identifierCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _authApi = DummyAuthApi();
  bool _obscure = true;
  bool _loading = false;

  late final AnimationController _anim;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))
      ..forward();
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.03), end: Offset.zero)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _anim.dispose();
    _identifierCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_identifierCtrl.text.isEmpty || _passCtrl.text.isEmpty) {
      return;
    }

    try {
      setState(() => _loading = true);
      final authUser = await _authApi.login(
        identifier: _identifierCtrl.text.trim(),
        password: _passCtrl.text,
      );

      if (!mounted) {
        return;
      }

      setState(() => _loading = false);

      final firstName = authUser['firstName'] as String? ?? '';
      final lastName = authUser['lastName'] as String? ?? '';
      final fullName = '$firstName $lastName'.trim().isEmpty
          ? (_identifierCtrl.text.trim())
          : '$firstName $lastName'.trim();

      final profile = UserProfile(
        name: fullName,
        email: authUser['email'] as String? ?? '-',
        origin: ((authUser['address'] as Map<String, dynamic>?)?['country']
                as String?) ??
            'Unknown',
        craft: 'DummyJSON Auth User',
        bio: 'Signed in via DummyJSON API',
        stack: const ['Flutter', 'DummyJSON', 'REST API'],
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(profile: profile),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Login gagal: $error\nCoba akun demo: emilys / emilyspass',
            style: AppText.body(size: 13),
          ),
          backgroundColor: AppColors.surface,
        ),
      );
    }
  }

  void _showComingSoon(String featureName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$featureName segera hadir.',
          style: AppText.body(size: 13),
        ),
        backgroundColor: AppColors.surface,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BrandHeader(
                    appName: "l's profile",
                    subtitle: 'Masuk dengan akun DummyJSON.',
                  ),

                  Text('Masuk ke akun', style: AppText.heading()),
                  const SizedBox(height: 24),

                  AppField(
                    label: 'Username / Email',
                    controller: _identifierCtrl,
                    placeholder: 'emilys atau email@kamu.com',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  AppField(
                    label: 'Password',
                    controller: _passCtrl,
                    obscure: _obscure,
                    placeholder: 'Password kamu',
                    onToggleObscure: () => setState(() => _obscure = !_obscure),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => _showComingSoon('Fitur lupa password'),
                      child: Text(
                        'Lupa password?',
                        style: AppText.body(size: 13).copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  AppButtonPrimary(
                    label: 'Masuk',
                    loading: _loading,
                    onTap: _handleLogin,
                  ),
                  const SizedBox(height: 32),

                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) {
                            return const RegisterScreen();
                          },
                          transitionsBuilder: (context, anim, secondaryAnimation, child) {
                            return FadeTransition(opacity: anim, child: child);
                          },
                          transitionDuration: const Duration(milliseconds: 300),
                        ),
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: AppText.caption(size: 13).copyWith(
                            color: AppColors.textMuted,
                          ),
                          children: [
                            const TextSpan(text: 'Belum punya akun?  '),
                            TextSpan(
                              text: 'Daftar',
                              style: AppText.caption(size: 13).copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
