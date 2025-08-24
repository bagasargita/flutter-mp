import 'package:flutter/material.dart';
import 'package:smart_mob/widgets/common/watermark_widget.dart';

class WatermarkDemo extends StatelessWidget {
  const WatermarkDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watermark Demo'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildWatermarkCard(
              'Default Watermark',
              const WatermarkWidget(),
              'Standard watermark with default settings',
            ),
            const SizedBox(height: 20),
            _buildWatermarkCard(
              'High Opacity Watermark',
              const WatermarkWidget(opacity: 0.15),
              'Watermark with higher opacity for better visibility',
            ),
            const SizedBox(height: 20),
            _buildWatermarkCard(
              'Dense Watermark',
              const WatermarkWidget(spacing: 80.0),
              'Watermark with closer spacing for denser pattern',
            ),
            const SizedBox(height: 20),
            _buildWatermarkCard(
              'Large Logo Watermark',
              const WatermarkWidget(logoSize: 80.0),
              'Watermark with larger logo size',
            ),
            const SizedBox(height: 20),
            _buildWatermarkCard(
              'Custom Watermark',
              const WatermarkWidget(
                opacity: 0.08,
                spacing: 100.0,
                rotation: -30.0,
                logoSize: 60.0,
              ),
              'Custom watermark with specific settings',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWatermarkCard(String title, Widget watermark, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: watermark,
            ),
          ),
        ],
      ),
    );
  }
}
