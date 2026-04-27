import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VColors {
  static const bg = Color(0xFF161210);
  static const border = Color(0xFF2E2418);
  static const gold = Color(0xFFB8956A);
  static const goldDim = Color(0xFF6B5036);
  static const ink = Color(0xFF4A3C28);
  static const inkDim = Color(0xFF3D3020);
  static const white = Color(0xFFE8DCC8);
}

class VText {
  static TextStyle title({double size = 32}) => GoogleFonts.imFellEnglish(
    fontSize: size,
    color: VColors.gold,
    height: 1.1,
    letterSpacing: 0.4,
  );

  static TextStyle titleItalic({double size = 32}) => GoogleFonts.imFellEnglish(
    fontStyle: FontStyle.italic,
    fontSize: size,
    color: VColors.goldDim,
    height: 1.1,
  );

  static TextStyle quote({double size = 11}) => GoogleFonts.imFellEnglish(
    fontStyle: FontStyle.italic,
    fontSize: size,
    color: VColors.inkDim,
    height: 1.75,
  );

  static TextStyle label({double size = 9}) => GoogleFonts.specialElite(
    fontSize: size,
    color: VColors.ink,
    letterSpacing: 1.8,
  );

  static TextStyle field({double size = 13}) => GoogleFonts.imFellEnglish(
    fontSize: size,
    color: VColors.gold,
  );

  static TextStyle ghost({double size = 12}) => GoogleFonts.imFellEnglish(
    fontStyle: FontStyle.italic,
    fontSize: size,
    color: VColors.inkDim,
  );

  static TextStyle cta({double size = 10}) => GoogleFonts.specialElite(
    fontSize: size,
    color: VColors.gold,
    letterSpacing: 2.2,
  );

  static TextStyle footer({double size = 9}) => GoogleFonts.specialElite(
    fontSize: size,
    color: VColors.inkDim,
    letterSpacing: 1.0,
  );

  static TextStyle chapter({double size = 8}) => GoogleFonts.specialElite(
    fontSize: size,
    color: VColors.inkDim,
    letterSpacing: 2.0,
  );
}

class VRule extends StatelessWidget {
  const VRule({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(color: VColors.border, thickness: 1, height: 1);
  }
}

class VField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback? onToggleObscure;
  final String? placeholder;

  const VField({
    super.key,
    required this.label,
    required this.controller,
    this.obscure = false,
    this.onToggleObscure,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: VText.label()),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                obscureText: obscure,
                style: VText.field(),
                cursorColor: VColors.goldDim,
                cursorWidth: 1,
                decoration: InputDecoration(
                  hintText: placeholder,
                  hintStyle: VText.ghost(),
                  isDense: true,
                  contentPadding: const EdgeInsets.only(bottom: 8),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: VColors.border, width: 1),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: VColors.ink, width: 1),
                  ),
                ),
              ),
            ),
            if (onToggleObscure != null) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onToggleObscure,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: VColors.inkDim, width: 1),
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class VButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const VButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 46,
        decoration: BoxDecoration(
          border: Border.all(color: VColors.border, width: 1),
        ),
        child: Center(child: Text(label.toUpperCase(), style: VText.cta())),
      ),
    );
  }
}
