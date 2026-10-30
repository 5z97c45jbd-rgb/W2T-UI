import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/core/ui/app_snack_bar.dart';
import 'package:w2t_mobile/features/home/widgets/ai_app_bar.dart';

class AiRegisterScreen extends StatefulWidget {
  const AiRegisterScreen({super.key});

  @override
  State<AiRegisterScreen> createState() => _AiRegisterScreenState();
}

class _AiRegisterScreenState extends State<AiRegisterScreen> {
  bool _showDocuments = false;
  final _inputController = TextEditingController();
  final _inputFocus = FocusNode();

  static const _steps = [
    (
      icon: Icons.person_add_alt_1_rounded,
      title: 'Create Merchant Account',
      detail: 'Provide basic business details',
    ),
    (
      icon: Icons.shopping_cart_rounded,
      title: 'Select Category',
      detail: "Choose 'Grocery' from the list",
    ),
    (
      icon: Icons.storefront_rounded,
      title: 'Add Store Information',
      detail: 'Store name, address, contact details',
    ),
    (
      icon: Icons.file_upload_rounded,
      title: 'Upload Documents',
      detail: 'GST, shop license (optional), store photos',
    ),
    (
      icon: Icons.fact_check_rounded,
      title: 'Start Listing Products',
      detail: 'Add your products, prices and delivery details',
    ),
  ];

  @override
  void dispose() {
    _inputController.dispose();
    _inputFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AiAppBar(onBack: () => Navigator.of(context).maybePop()),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                children: [
                  const Align(
                    alignment: Alignment.centerRight,
                    child: _UserBubble(
                      text:
                          'How can I register my grocery store as a merchant on W2T?',
                    ),
                  ),
                  const SizedBox(height: 18),
                  _BotBubble(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'You can register your grocery store as a merchant on W2T in a few simple steps:',
                          style: GoogleFonts.inter(
                            fontSize: 14.5,
                            height: 1.45,
                            color: const Color(0xFF2C2C2C),
                          ),
                        ),
                        const SizedBox(height: 18),
                        for (var i = 0; i < _steps.length; i++) ...[
                          if (i > 0) const SizedBox(height: 16),
                          _StepRow(
                            number: i + 1,
                            icon: _steps[i].icon,
                            title: _steps[i].title,
                            detail: _steps[i].detail,
                          ),
                        ],
                        const SizedBox(height: 18),
                        Text(
                          'Would you like me to take you to the merchant registration page now?',
                          style: GoogleFonts.inter(
                            fontSize: 14.5,
                            height: 1.45,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF2C2C2C),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_showDocuments) ...[
                    const SizedBox(height: 14),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: _UserBubble(text: 'Tell me required documents'),
                    ),
                    const SizedBox(height: 14),
                    const _BotBubble(
                      child: _DocumentsMessage(),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Text(
                    '9:41 AM',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          label: 'Yes, take me there',
                          filled: true,
                          onTap: () {
                            AppSnackBar.show(
                              context,
                              'Merchant registration will be available soon.',
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ActionButton(
                          label: 'Tell me required documents',
                          filled: false,
                          onTap: () {
                            if (_showDocuments) return;
                            setState(() => _showDocuments = true);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _AskAnythingBar(
              controller: _inputController,
              focusNode: _inputFocus,
              onSend: () => _inputFocus.unfocus(),
            ),
          ],
        ),
      ),
    );
  }
}

class _AskAnythingBar extends StatelessWidget {
  const _AskAnythingBar({
    required this.controller,
    required this.focusNode,
    required this.onSend,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 10 + bottomInset),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 52,
              padding: const EdgeInsets.only(left: 6, right: 14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xFFE6EEF2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFF3FBFD),
                      border: Border.all(color: const Color(0xFFC9EAF3)),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      size: 18,
                      color: Color(0xFF12A8C7),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => onSend(),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Ask anything about W2T...',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFFB0B8C1),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Material(
            color: const Color(0xFF12A8C7),
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onSend,
              child: const SizedBox(
                width: 48,
                height: 48,
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserBubble extends StatelessWidget {
  const _UserBubble({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width * 0.78,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            decoration: const BoxDecoration(
              color: Color(0xFF12A8C7),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(6),
              ),
            ),
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                height: 1.4,
                color: AppColors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '9:41 AM',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.done_all_rounded,
                size: 14,
                color: Color(0xFF12A8C7),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BotBubble extends StatelessWidget {
  const _BotBubble({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _BotAvatar(),
        const SizedBox(width: 8),
        Expanded(child: child),
      ],
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.number,
    required this.icon,
    required this.title,
    required this.detail,
  });

  final int number;
  final IconData icon;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 26,
          height: 26,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color(0xFFE5F6FB),
            shape: BoxShape.circle,
          ),
          child: Text(
            '$number',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF12A8C7),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Icon(icon, size: 18, color: const Color(0xFF12A8C7)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1B2A4A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                detail,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DocumentsMessage extends StatelessWidget {
  const _DocumentsMessage();

  @override
  Widget build(BuildContext context) {
    const items = [
      'GST certificate (if registered)',
      'Shop license or FSSAI (optional)',
      'Store photos of the shopfront and interiors',
      'Owner ID proof and a contact number',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Keep these documents ready before you start:',
          style: GoogleFonts.inter(
            fontSize: 14,
            height: 1.45,
            color: const Color(0xFF2C2C2C),
          ),
        ),
        const SizedBox(height: 10),
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              '•  $item',
              style: GoogleFonts.inter(
                fontSize: 13,
                height: 1.4,
                color: const Color(0xFF2C2C2C),
              ),
            ),
          ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.filled,
    required this.onTap,
  });

  final String label;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Text(
      label,
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );

    return SizedBox(
      height: 44,
      child: filled
          ? FilledButton(
              onPressed: onTap,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF12A8C7),
                foregroundColor: AppColors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                textStyle: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
              child: text,
            )
          : OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF12A8C7),
                side: const BorderSide(color: Color(0xFF12A8C7)),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                textStyle: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
              child: text,
            ),
    );
  }
}

class _BotAvatar extends StatelessWidget {
  const _BotAvatar();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 28,
      height: 28,
      child: CustomPaint(painter: _MiniBotPainter()),
    );
  }
}

class _MiniBotPainter extends CustomPainter {
  const _MiniBotPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawCircle(
      Offset(w / 2, h / 2),
      w / 2,
      Paint()..color = const Color(0xFFEAF7FB),
    );

    final head = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(w / 2, h * 0.52),
        width: w * 0.78,
        height: h * 0.72,
      ),
      Radius.circular(w * 0.32),
    );
    canvas.drawRRect(head, Paint()..color = const Color(0xFF3EC4E0));

    final visor = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(w / 2, h * 0.50),
        width: w * 0.58,
        height: h * 0.42,
      ),
      Radius.circular(w * 0.22),
    );
    canvas.drawRRect(visor, Paint()..color = const Color(0xFF102A44));

    final eye = Paint()
      ..color = const Color(0xFF6EE7FF)
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(w * 0.40, h * 0.50),
        width: w * 0.16,
        height: h * 0.12,
      ),
      3.5,
      2.3,
      false,
      eye,
    );
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(w * 0.60, h * 0.50),
        width: w * 0.16,
        height: h * 0.12,
      ),
      3.5,
      2.3,
      false,
      eye,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
