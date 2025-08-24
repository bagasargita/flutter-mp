import 'dart:math';
import 'package:flutter/material.dart';
import 'package:smart_mob/constants/app_colors.dart';

class WatermarkWidget extends StatelessWidget {
  final double opacity;
  final double spacing;
  final double rotation;
  final double logoSize;

  const WatermarkWidget({
    super.key,
    this.opacity = 0.08,
    this.spacing = 120.0,
    this.rotation = -45.0,
    this.logoSize = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (
          double y = -spacing;
          y < MediaQuery.of(context).size.height + spacing;
          y += spacing
        )
          for (
            double x = -spacing;
            x < MediaQuery.of(context).size.width + spacing;
            x += spacing
          )
            Positioned(
              left: x,
              top: y,
              child: Transform.rotate(
                angle: rotation * pi / 180,
                child: Opacity(
                  opacity: opacity,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/LOGO-SVG.png',
                        width: logoSize,
                        height: logoSize,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'MerahPutih',
                        style: TextStyle(
                          color: AppColors.primaryRed,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      ],
    );
  }
}
