import 'package:flutter/material.dart';
import 'package:cintli_montessori/core/theme/colors.dart';

/// Representa el logotipo tipográfico con la paleta institucional.
class AppLogo extends StatelessWidget {
  final double size;
  final Color? subtitleColor;

  const AppLogo({super.key, required this.size, this.subtitleColor});

  @override
  Widget build(BuildContext context) {
    const letters = <(String, Color)>[
      ('C', AppColors.primaryRed),
      ('i', AppColors.primaryGreen),
      ('n', AppColors.primaryYellow),
      ('t', AppColors.primaryBlue),
      ('l', AppColors.primaryTurquoise),
      ('i', AppColors.primaryOrange),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children:
              letters
                  .map(
                    (letter) => Text(
                      letter.$1,
                      style: TextStyle(
                        fontFamily: 'LettersForLearners',
                        fontSize: size * 0.5,
                        fontWeight: FontWeight.bold,
                        color: letter.$2,
                      ),
                    ),
                  )
                  .toList(),
        ),
        Text(
          'Montessori',
          style: TextStyle(
            fontFamily: 'Lato',
            fontSize: size * 0.2,
            fontWeight: FontWeight.bold,
            color: subtitleColor ?? Colors.white,
          ),
        ),
      ],
    );
  }
}
