import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'data/datasources/dummy_auth_api.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _agreed = false;
  bool _loading = false;
  final _authApi = DummyAuthApi();

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
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_agreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Harap setujui syarat & ketentuan terlebih dahulu.',
            style: AppText.body(size: 13),
          ),
          backgroundColor: AppColors.surface,
        ),
      );
      return;
    }

    if (_nameCtrl.text.isEmpty || _emailCtrl.text.isEmpty || _passCtrl.text.isEmpty) {
      return;
    }

    try {
      setState(() => _loading = true);
      final createdUser = await _authApi.register(
        fullName: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
      );

      if (!mounted) {
        return;
      }

      setState(() => _loading = false);

      final username = createdUser['username'] as String? ?? '-';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Registrasi simulasi berhasil. Username: $username\nAkun ini tidak tersimpan untuk login nyata.',
            style: AppText.body(size: 13),
          ),
          backgroundColor: AppColors.surface,
        ),
      );
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Register gagal: $error',
            style: AppText.body(size: 13),
          ),
          backgroundColor: AppColors.surface,
        ),
      );
    }
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
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 16,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 20),

                  const BrandHeader(
                    appName: "l's profile",
                    subtitle: 'Buat akun baru di DummyJSON.',
                  ),

                  Text('Buat akun baru', style: AppText.heading()),
                  const SizedBox(height: 24),

                  AppField(
                    label: 'Nama lengkap',
                    controller: _nameCtrl,
                    placeholder: 'Muhammad Labiq Jazli',
                    keyboardType: TextInputType.name,
                  ),
                  AppField(
                    label: 'Email',
                    controller: _emailCtrl,
                    placeholder: 'email@example.com',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  AppField(
                    label: 'Password',
                    controller: _passCtrl,
                    placeholder: 'Minimal 8 karakter',
                    obscure: _obscure,
                    onToggleObscure: () => setState(() => _obscure = !_obscure),
                  ),

                  AppCheckbox(
                    value: _agreed,
                    onChanged: (v) => setState(() => _agreed = v),
                    label: RichText(
                      text: TextSpan(
                        style: AppText.caption(size: 12).copyWith(
                          color: AppColors.textMuted,
                          height: 1.5,
                        ),
                        children: [
                          const TextSpan(text: 'Saya setuju dengan '),
                          TextSpan(
                            text: 'syarat & ketentuan',
                            style: AppText.caption(size: 12).copyWith(
                              color: AppColors.textSecondary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const TextSpan(text: ' dan '),
                          TextSpan(
                            text: 'kebijakan privasi',
                            style: AppText.caption(size: 12).copyWith(
                              color: AppColors.textSecondary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  AppButtonPrimary(
                    label: 'Daftar',
                    loading: _loading,
                    onTap: _handleRegister,
                  ),
                  const SizedBox(height: 32),

                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: RichText(
                        text: TextSpan(
                          style: AppText.caption(size: 13).copyWith(
                            color: AppColors.textMuted,
                          ),
                          children: [
                            const TextSpan(text: 'Sudah punya akun?  '),
                            TextSpan(
                              text: 'Masuk',
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
