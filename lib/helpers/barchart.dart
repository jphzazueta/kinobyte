// import 'package:fl_chart/presentation/resources/app_resources.dart';
// import 'package:fl_chart/util/extensions/color_extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class _BarChart extends StatelessWidget {
  final List<Map<String, dynamic>> chartData;  
  const _BarChart({
    required this.chartData,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate maximum Y-axis value
    double maxY;
    maxY = chartData[0]['movies_watched'].toDouble();
    for (var item in chartData) {
      if (item['movies_watched'] > maxY) maxY = item['movies_watched'].toDouble();
    }
    maxY = maxY * 1.15; // Give max value some room for label
    print(maxY);
    

    // print(chartData);
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        gridData: const FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
        // backgroundColor: Color.fromARGB(255, 23, 23, 70),
      )
    );
  }


  BarTouchData get barTouchData => BarTouchData(
    enabled: false,
    touchTooltipData: BarTouchTooltipData(
      fitInsideVertically: true,
      getTooltipColor: (group) => Colors.transparent,
      tooltipPadding: EdgeInsets.all(0),
      tooltipMargin: 10,
      getTooltipItem: (
        BarChartGroupData group,
        int groupIndex,
        BarChartRodData rod,
        int rodIndex,
      ) {
        return BarTooltipItem(
          rod.toY.round().toString(),
          TextStyle(
            color: Colors.indigo[100],
            fontWeight: FontWeight.bold,
          )
        );
      }
    )
  );

  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Colors.indigo[200],
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8,
      child: Text(value.round().toString(), style: style),
    );
  }

  // Labels at the bottom of the chart
  FlTitlesData get titlesData => FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        getTitlesWidget: getTitles,
      ),
    ),
    leftTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
  );

  FlBorderData get borderData => FlBorderData(
    show: false,
    border: Border.all(
      color: Colors.white,
    )
  );

  LinearGradient get _barsGradient => LinearGradient(
    colors: [
      // Colors.indigo,
      // // Colors.cyan,
      // Color.fromARGB(255, 113, 23, 146),
      // Color.fromARGB(255, 113, 23, 146),
      Color(0xFFAFFFFF),
      Color(0xFFAFFFFF),
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  List<BarChartGroupData> get barGroups { 
    List<BarChartGroupData> barGroups = [];
    for(Map<String, dynamic> data in chartData) {
      barGroups.add(
        BarChartGroupData(
          x: data['year_watched'],
          barRods: [
            BarChartRodData(
              toY: data['movies_watched'].toDouble(),
              gradient: _barsGradient,
              width: 17,
            )
          ],
          showingTooltipIndicators: [0],
        )
      );
    }
    return barGroups;
  }
}

class BarChartStats extends StatefulWidget {
  final List<Map<String, dynamic>> chartData;
  
  const BarChartStats({
    super.key,
    required this.chartData,
  });

  @override
  State<BarChartStats> createState() => _BarChartStatsState();
}

class _BarChartStatsState extends State<BarChartStats> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: _BarChart(
        chartData: widget.chartData,
      ),
    );
  }
}