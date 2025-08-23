import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class MapSection extends StatelessWidget {
  final double height;
  final List<MapPin> pins;

  const MapSection({super.key, this.height = 200, this.pins = const []});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Center(child: Icon(Icons.map, size: 80, color: Colors.grey[400])),
          ...pins.map((pin) => _buildPin(pin)),
        ],
      ),
    );
  }

  Widget _buildPin(MapPin pin) {
    return Positioned(
      top: pin.top,
      left: pin.left,
      child: Container(
        width: pin.size,
        height: pin.size,
        decoration: BoxDecoration(color: pin.color, shape: BoxShape.circle),
      ),
    );
  }
}

class MapPin {
  final double top;
  final double left;
  final double size;
  final Color color;

  const MapPin({
    required this.top,
    required this.left,
    this.size = 8,
    required this.color,
  });
}
