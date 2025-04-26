import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:intl/intl.dart';

class TransactionLineChart extends StatelessWidget {
  final List<Map<String, dynamic>> transactionData;
  final double height;
  final Color lineColor;
  final Color gradientStartColor;
  final Color gradientEndColor;

  const TransactionLineChart({
    super.key,
    required this.transactionData,
    this.height = 200,
    this.lineColor = Colors.white,
    this.gradientStartColor = Colors.white,
    this.gradientEndColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    if (transactionData.isEmpty) {
      return SizedBox(
        height: height,
        child: Center(
          child: Text(
            'No transactions found',
            style: TextStyle(
              color: lineColor.withOpacity(0.7),
            ),
          ),
        ),
      );
    }

    // Calculate the maximum Y value dynamically
    final maxTransactionAmount = transactionData
        .map((transaction) => transaction['amount'] as double)
        .reduce((a, b) => a > b ? a : b);

    // Add more padding to the maxY for better visualization and tooltip space
    final maxY = maxTransactionAmount + (maxTransactionAmount * 0.2);

    // Add extra space to the right for better visibility
    const extraSpace = 0.1;

    // Calculate the minimum width needed based on number of data points
    final minWidth = transactionData.length * 50.0;
    final screenWidth = MediaQuery.of(context).size.width - 32;
    final chartWidth = minWidth > screenWidth ? minWidth : screenWidth + 50;

    // Calculate minimum height needed for the chart
    final minHeight = height + 60; // Add extra space for tooltips

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Container(
          width: chartWidth,
          height: minHeight,
          padding: const EdgeInsets.only(top: 30), // Space for top tooltips
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: Colors.white.withOpacity(0.8),
                  tooltipRoundedRadius: 8,
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      return LineTooltipItem(
                        '₱${NumberFormat('#,##0.00').format(spot.y)}',
                        const TextStyle(
                          color: GinaAppTheme.lightOnPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: maxY / 5,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: lineColor.withOpacity(0.2),
                    strokeWidth: 0.5,
                    dashArray: [5, 5],
                  );
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= transactionData.length) {
                        return const SizedBox.shrink();
                      }
                      final date = transactionData[value.toInt()]['date'];
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          DateFormat('MMM d').format(DateTime.parse(date)),
                          style: TextStyle(
                            color: lineColor.withOpacity(0.7),
                            fontSize: 10,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: maxY / 5,
                    reservedSize: 42,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '₱${NumberFormat.compact().format(value)}',
                        style: TextStyle(
                          color: lineColor.withOpacity(0.7),
                          fontSize: 10,
                        ),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: false,
              ),
              minX: 0,
              maxX: (transactionData.length - 1).toDouble() +
                  extraSpace, // Add extra space
              minY: 0,
              maxY: maxY,
              lineBarsData: [
                LineChartBarData(
                  spots: transactionData.asMap().entries.map((entry) {
                    return FlSpot(entry.key.toDouble(), entry.value['amount']);
                  }).toList(),
                  isCurved: true,
                  curveSmoothness: 0.35,
                  preventCurveOverShooting: true,
                  gradient: const LinearGradient(
                    colors: [Colors.white, Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 3,
                        color: lineColor,
                        strokeWidth: 2,
                        strokeColor: lineColor,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        GinaAppTheme.appbarColorLight.withOpacity(0.6),
                        GinaAppTheme.appbarColorLight.withOpacity(0.2),
                        GinaAppTheme.lightTertiaryContainer.withOpacity(0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
            duration: const Duration(milliseconds: 250),
          ),
        ),
      ),
    );
  }
}
