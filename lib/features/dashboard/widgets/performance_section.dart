import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PerformanceSection extends StatelessWidget {
  const PerformanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 720;

        if (isMobile) {
          return Column(
            children: [
              _BarChartCard(isMobile: isMobile),
              SizedBox(height: 20),
              _LineChartCard(isMobile: isMobile),
            ],
          );
        }

        return const Row(
          children: [
            Expanded(child: _BarChartCard(isMobile: false)),
            SizedBox(width: 20),
            Expanded(child: _LineChartCard(isMobile: false)),
          ],
        );
      },
    );
  }
}

class _BarChartCard extends StatelessWidget {
  final bool isMobile;

  const _BarChartCard({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final bars = [40, 25, 33, 40, 34, 33, 39];

    return _ChartContainer(
      isMobile: isMobile,
      title: "Content Performance",
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceBetween,
          maxY: 60,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 10,
            getDrawingHorizontalLine:
                (value) => FlLine(
                  color: Colors.grey.withValues(alpha: .1),
                  strokeWidth: 1,
                ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 10,
                reservedSize: 30,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const labels = [
                    "Post",
                    "Page",
                    "Product",
                    "About",
                    "Contact",
                    "Product",
                    "Post",
                  ];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      labels[value.toInt()],
                      style: const TextStyle(fontSize: 11),
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(
            bars.length,
            (i) => BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: bars[i].toDouble(),
                  width: 18,
                  borderRadius: BorderRadius.circular(6),
                  color: const Color(0xFF10B981),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: 55,
                    color: const Color(0xFFE5E7EB),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LineChartCard extends StatelessWidget {
  final bool isMobile;

  const _LineChartCard({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return _ChartContainer(
      isMobile: isMobile,
      title: "Content Performance",
      showLegend: true,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 120,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 20,
            getDrawingHorizontalLine:
                (value) => FlLine(
                  color: Colors.grey.withValues(alpha: .1),
                  strokeWidth: 1,
                ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 20,
                reservedSize: 40,
                getTitlesWidget:
                    (value, meta) => Text(
                      "${value.toInt()}k",
                      style: const TextStyle(fontSize: 10),
                    ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const months = [
                    "Jan",
                    "Feb",
                    "Mar",
                    "Apr",
                    "May",
                    "Jun",
                    "Jul",
                    "Aug",
                    "Sep",
                    "Oct",
                    "Nov",
                    "Dec",
                  ];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      months[value.toInt()],
                      style: const TextStyle(fontSize: 11),
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 50),
                FlSpot(1, 70),
                FlSpot(2, 65),
                FlSpot(3, 85),
                FlSpot(4, 72),
                FlSpot(5, 95),
                FlSpot(6, 80),
                FlSpot(7, 90),
                FlSpot(8, 75),
                FlSpot(9, 100),
                FlSpot(10, 110),
                FlSpot(11, 112),
              ],
              isCurved: true,
              color: const Color(0xFF10B981),
              barWidth: 3,
              dotData: const FlDotData(show: false),
            ),
            LineChartBarData(
              spots: const [
                FlSpot(0, 60),
                FlSpot(1, 75),
                FlSpot(2, 70),
                FlSpot(3, 72),
                FlSpot(4, 65),
                FlSpot(5, 60),
                FlSpot(6, 78),
                FlSpot(7, 90),
                FlSpot(8, 100),
                FlSpot(9, 95),
                FlSpot(10, 108),
                FlSpot(11, 110),
              ],
              isCurved: true,
              color: const Color(0xFF2563EB),
              barWidth: 3,
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartContainer extends StatelessWidget {
  final String title;
  final Widget child;
  final bool showLegend;
  final bool isMobile;

  const _ChartContainer({
    required this.title,
    required this.child,
    this.showLegend = false,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ================================
          /// DESKTOP / TABLET HEADER
          /// ================================
          if (!isMobile)
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (showLegend)
                  Row(
                    children: const [
                      _Legend(color: Color(0xFF10B981), text: "Visitor"),
                      SizedBox(width: 12),
                      _Legend(color: Color(0xFF2563EB), text: "Page View"),
                    ],
                  ),
                const SizedBox(width: 20),
                _Dropdown(),
              ],
            ),

          /// ================================
          /// MOBILE HEADER
          /// ================================
          if (isMobile) ...[
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                if (showLegend)
                  const Row(
                    children: [
                      _Legend(color: Color(0xFF10B981), text: "Visitor"),
                      SizedBox(width: 12),
                      _Legend(color: Color(0xFF2563EB), text: "Page View"),
                    ],
                  ),
                const Spacer(),
                _Dropdown(),
              ],
            ),
          ],

          const SizedBox(height: 20),

          Expanded(child: child),
        ],
      ),
    );
  }
}

class _Dropdown extends StatelessWidget {
  const _Dropdown();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Text("Monthly", style: TextStyle(fontSize: 12)),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String text;

  const _Legend({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 8,
          width: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 12),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
