import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildDatePicker(),
                    const SizedBox(height: 24),
                    _buildStatisticsCards(),
                    const SizedBox(height: 24),
                    _buildExpensesTrends(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primaryRed,
            child: const Icon(Icons.person, color: Colors.white, size: 24),
          ),
          const Expanded(
            child: Text(
              'SMARTMobs',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Stack(
            children: [
              const Icon(
                Icons.notifications,
                size: 24,
                color: AppColors.textBlack,
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryRed,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, color: AppColors.textGray, size: 20),
          const SizedBox(width: 12),
          const Text(
            '01 Mar 2021- 31 Mar 2021',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack,
            ),
          ),
          const Spacer(),
          Icon(Icons.keyboard_arrow_down, color: AppColors.textGray, size: 24),
        ],
      ),
    );
  }

  Widget _buildStatisticsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Setor',
            'Rp. 10.000.000',
            Icons.trending_up,
            Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Total Biaya',
            'Rp. 125.000',
            Icons.trending_down,
            Colors.red,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Total Komisi',
            'Rp. 400.000',
            Icons.trending_up,
            Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String amount,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textGray,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpensesTrends() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Expenses Trends',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(height: 200, child: _buildChart()),
          const SizedBox(height: 16),
          _buildChartLabels(),
        ],
      ),
    );
  }

  Widget _buildChart() {
    return Container(
      child: Stack(
        children: [
          // Y-axis labels
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '50000',
                  style: TextStyle(fontSize: 10, color: AppColors.textGray),
                ),
                Text(
                  '40000',
                  style: TextStyle(fontSize: 10, color: AppColors.textGray),
                ),
                Text(
                  '30000',
                  style: TextStyle(fontSize: 10, color: AppColors.textGray),
                ),
                Text(
                  '20000',
                  style: TextStyle(fontSize: 10, color: AppColors.textGray),
                ),
                Text(
                  '10000',
                  style: TextStyle(fontSize: 10, color: AppColors.textGray),
                ),
              ],
            ),
          ),
          // Chart area
          Positioned(
            left: 0,
            right: 50,
            top: 0,
            bottom: 0,
            child: CustomPaint(painter: ChartPainter()),
          ),
        ],
      ),
    );
  }

  Widget _buildChartLabels() {
    return Padding(
      padding: const EdgeInsets.only(right: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('26', style: TextStyle(fontSize: 12, color: AppColors.textGray)),
          Text('27', style: TextStyle(fontSize: 12, color: AppColors.textGray)),
          Text('28', style: TextStyle(fontSize: 12, color: AppColors.textGray)),
          Text('29', style: TextStyle(fontSize: 12, color: AppColors.textGray)),
          Text('30', style: TextStyle(fontSize: 12, color: AppColors.textGray)),
          Text('31', style: TextStyle(fontSize: 12, color: AppColors.textGray)),
        ],
      ),
    );
  }
}

class ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.green.withOpacity(0.3),
          Colors.green.withOpacity(0.1),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Sample data points (normalized to chart size)
    final points = [
      Offset(0, size.height * 0.8),
      Offset(size.width * 0.1, size.height * 0.6),
      Offset(size.width * 0.2, size.height * 0.7),
      Offset(size.width * 0.3, size.height * 0.5),
      Offset(size.width * 0.4, size.height * 0.8),
      Offset(size.width * 0.5, size.height * 0.6),
      Offset(size.width * 0.6, size.height * 0.4),
      Offset(size.width * 0.7, size.height * 0.5),
      Offset(size.width * 0.8, size.height * 0.3),
      Offset(size.width * 0.9, size.height * 0.2),
      Offset(size.width, size.height * 0.1),
    ];

    // Create path for line
    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    // Create path for fill area
    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    // Draw fill
    canvas.drawPath(fillPath, fillPaint);

    // Draw line
    canvas.drawPath(path, paint);

    // Draw points
    final pointPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
