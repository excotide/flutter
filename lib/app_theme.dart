import 'package:flutter/material.dart';

class AppColors {
  static const bg = Color(0xFF111111);
  static const surface = Color(0xFF1A1A1A);
  static const surfaceAlt = Color(0xFF1E1E1E);
  static const border = Color(0xFF252525);
  static const borderSub = Color(0xFF1A1A1A);

  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFCCCCCC);
  static const textMuted = Color(0xFF666666);
  static const textHint = Color(0xFF444444);

  static const cream = Color(0xFFF0EDE6);
  static const danger = Color(0xFFC0392B);
}

class AppText {
  static const _tnr = 'Times New Roman';
  static const _fallback = ['TimesNewRoman', 'serif'];

  static TextStyle heading({double size = 22}) => TextStyle(
    fontFamily: _tnr,
    fontFamilyFallback: _fallback,
    fontSize: size,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle body({double size = 14}) => TextStyle(
    fontFamily: _tnr,
    fontFamilyFallback: _fallback,
    fontSize: size,
    color: AppColors.textSecondary,
  );

  static TextStyle label({double size = 13}) => TextStyle(
    fontFamily: _tnr,
    fontFamilyFallback: _fallback,
    fontSize: size,
    color: AppColors.textMuted,
  );

  static TextStyle field({double size = 15}) => TextStyle(
    fontFamily: _tnr,
    fontFamilyFallback: _fallback,
    fontSize: size,
    color: AppColors.textSecondary,
  );

  static TextStyle hint({double size = 15}) => TextStyle(
    fontFamily: _tnr,
    fontFamilyFallback: _fallback,
    fontSize: size,
    fontStyle: FontStyle.italic,
    color: AppColors.textHint,
  );

  static TextStyle caption({double size = 12}) => TextStyle(
    fontFamily: _tnr,
    fontFamilyFallback: _fallback,
    fontSize: size,
    color: AppColors.textMuted,
  );

  static TextStyle btnPrimary({double size = 15}) => TextStyle(
    fontFamily: _tnr,
    fontFamilyFallback: _fallback,
    fontSize: size,
    fontWeight: FontWeight.w700,
    color: AppColors.bg,
    letterSpacing: 0.2,
  );
}

class AppField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? placeholder;
  final bool obscure;
  final VoidCallback? onToggleObscure;
  final TextInputType keyboardType;

  const AppField({
    super.key,
    required this.label,
    required this.controller,
    this.placeholder,
    this.obscure = false,
    this.onToggleObscure,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppText.label()),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          style: AppText.field(),
          cursorColor: AppColors.textSecondary,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: AppText.hint(),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF3A3A3A), width: 1.5),
            ),
            suffixIcon: onToggleObscure != null
                ? IconButton(
                    onPressed: onToggleObscure,
                    icon: Icon(
                      obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 18,
                      color: AppColors.textHint,
                    ),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class AppButtonPrimary extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool loading;

  const AppButtonPrimary({
    super.key,
    required this.label,
    required this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: loading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.cream,
          foregroundColor: AppColors.bg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
        ),
        child: loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.bg,
                ),
              )
            : Text(label, style: AppText.btnPrimary()),
      ),
    );
  }
}

class AppCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget label;

  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 18,
            height: 18,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: value ? AppColors.cream : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: value ? AppColors.cream : AppColors.border,
                width: 1.5,
              ),
            ),
            child: value
                ? const Icon(Icons.check, size: 12, color: AppColors.bg)
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(child: label),
        ],
      ),
    );
  }
}

class BrandHeader extends StatelessWidget {
  final String appName;
  final String subtitle;

  const BrandHeader({
    super.key,
    required this.appName,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: AppColors.border),
              ),
              child: const Center(
                child: Icon(Icons.auto_awesome, size: 18, color: AppColors.cream),
              ),
            ),
            const SizedBox(width: 10),
            Text(appName, style: AppText.heading(size: 20)),
          ],
        ),
        const SizedBox(height: 6),
        Text(subtitle, style: AppText.hint(size: 13)),
        const SizedBox(height: 28),
      ],
    );
  }
}
