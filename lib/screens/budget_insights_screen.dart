// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import '../../services/api_service.dart';

// class BudgetInsightsScreen extends StatefulWidget {
//   @override
//   _BudgetInsightsScreenState createState() => _BudgetInsightsScreenState();
// }

// class _BudgetInsightsScreenState extends State<BudgetInsightsScreen> {
//   List<_ChartData> _historicalData = [];
//   List<_ChartData> _predictionData = [];
//   String _budgetMessage = "Loading...";

//   @override
//   void initState() {
//     super.initState();
//     fetchSpendingData();
//   }

//   void fetchSpendingData() async {
//     try {
//       var data = await ApiService.getSpendingAnalysis("409000611074");
//       setState(() {
//         _budgetMessage = data["insight"];
//         _updateChartData(data["historical"], data["prediction"], data['da']);
//       });
//     } catch (e) {
//       setState(() {
//         _budgetMessage = "Error fetching data.";
//       });
//     }
//   }

//   void _updateChartData(List<dynamic> historical, List<dynamic> predictions, List<dynamic> dates) {
//     List<_ChartData> historicalSpots = [];
//     List<_ChartData> predictionSpots = [];
    
//     for (int i = 0; i < historical.length; i++) {
//       historicalSpots.add(_ChartData(i, historical[i].toDouble()));
//     }

//     for (int i = 0; i < predictions.length; i++) {
//       predictionSpots.add(_ChartData(historical.length + i, predictions[i].toDouble()));
//     }

//     setState(() {
//       _historicalData = historicalSpots;
//       _predictionData = predictionSpots;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.blueAccent.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Text(
//                 _budgetMessage,
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//               ),
//             ),
//             SizedBox(height: 16),
//             Expanded(
//               child: Card(
//                 elevation: 6,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.all(16.0),
//                   child: SfCartesianChart(
//                     primaryXAxis: NumericAxis(),
//                     primaryYAxis: NumericAxis(),
//                     series: <LineSeries<_ChartData, int>>[
//                       LineSeries<_ChartData, int>(
//                         dataSource: _historicalData,
//                         xValueMapper: (_ChartData data, _) => data.time,
//                         yValueMapper: (_ChartData data, _) => data.value,
//                         color: Colors.blue,
//                         name: 'Historical',
//                       ),
//                       LineSeries<_ChartData, int>(
//                         dataSource: _predictionData,
//                         xValueMapper: (_ChartData data, _) => data.time,
//                         yValueMapper: (_ChartData data, _) => data.value,
//                         color: Colors.red,
//                         name: 'Prediction',
//                         dashArray: [5, 5],
//                       ),
//                     ],
//                     legend: Legend(isVisible: true),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _ChartData {
//   final int time;
//   final double value;
//   _ChartData(this.time, this.value);
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import '../../services/api_service.dart';

class BudgetInsightsScreen extends StatefulWidget {
  @override
  _BudgetInsightsScreenState createState() => _BudgetInsightsScreenState();
}

class _BudgetInsightsScreenState extends State<BudgetInsightsScreen> {
  List<_ChartData> _historicalData = [];
  List<_ChartData> _predictionData = [];
  String _budgetMessage = "Loading...";
  late ZoomPanBehavior _zoomPanBehavior;
  late TrackballBehavior _trackballBehavior;
  double _zoomPosition = 0.7; // Start closer to more recent data
  double _zoomFactor = 0.3; // Show about 30% of the data at once

  @override
  void initState() {
    super.initState();
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enablePanning: true,
      enableDoubleTapZooming: true,
      enableSelectionZooming: true,
      enableMouseWheelZooming: true,
      zoomMode: ZoomMode.x,
    );
    
    _trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
      tooltipSettings: InteractiveTooltip(
        enable: true,
        format: 'point.x : \$point.y',
      ),
      lineType: TrackballLineType.vertical,
      markerSettings: TrackballMarkerSettings(
        markerVisibility: TrackballVisibilityMode.visible,
      ),
    );
    
    fetchSpendingData();
  }

  void fetchSpendingData() async {
    try {
      var data = await ApiService.getSpendingAnalysis("409000611074\'");
      setState(() {
        _budgetMessage = data["insight"];
        _updateChartData(
          data["historical"], 
          data["prediction"], 
          data['date']
        );
      });
    } catch (e) {
      setState(() {
        _budgetMessage = "Error fetching data: $e";
      });
    }
  }

  void _updateChartData(List<dynamic> historical, List<dynamic> predictions, List<dynamic> dates) {
    List<_ChartData> historicalSpots = [];
    List<_ChartData> predictionSpots = [];
    
    // Process historical data with dates
    for (int i = 0; i < historical.length; i++) {
      // Parse date from string to DateTime
      DateTime date = DateTime.parse(dates[i]);
      historicalSpots.add(_ChartData(date, historical[i].toDouble(), 'Historical'));
    }

    // Process prediction data with dates
    for (int i = 0; i < predictions.length; i++) {
      // For predictions, the dates continue from where historical ends
      DateTime lastHistoricalDate = DateTime.parse(dates[dates.length - 1]);
      DateTime predictionDate = lastHistoricalDate.add(Duration(days: i + 1));
      predictionSpots.add(_ChartData(predictionDate, predictions[i].toDouble(), 'Prediction'));
    }

    setState(() {
      _historicalData = historicalSpots;
      _predictionData = predictionSpots;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _budgetMessage,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: (_historicalData.isEmpty && _predictionData.isEmpty)
                    ? Center(child: CircularProgressIndicator())
                    : SfCartesianChart(
                        plotAreaBorderWidth: 0,
                        legend: Legend(
                          isVisible: true,
                          position: LegendPosition.bottom,
                          overflowMode: LegendItemOverflowMode.wrap,
                        ),
                        primaryXAxis: DateTimeAxis(
                          dateFormat: DateFormat('MM/dd'),
                          intervalType: DateTimeIntervalType.days,
                          interval: 50, // Show every 2 days to prevent overlap
                          majorGridLines: MajorGridLines(width: 0),
                          edgeLabelPlacement: EdgeLabelPlacement.shift,
                          labelRotation: -45, // Rotate labels to prevent overlap
                        ),
                        primaryYAxis: NumericAxis(
                          numberFormat: NumberFormat.currency(
                            symbol: '\$',
                            decimalDigits: 0
                          ),
                          majorGridLines: MajorGridLines(width: 0.5),
                          axisLine: AxisLine(width: 0),
                          labelPosition: ChartDataLabelPosition.outside,
                        ),
                        zoomPanBehavior: _zoomPanBehavior,
                        trackballBehavior: _trackballBehavior,
                        tooltipBehavior: TooltipBehavior(
                          enable: true,
                          format: 'point.x : \$point.y',
                          header: '',
                        ),
                        series: <ChartSeries>[
                          // Historical Data Series
                          SplineAreaSeries<_ChartData, DateTime>(
                            dataSource: _historicalData,
                            xValueMapper: (_ChartData data, _) => data.date,
                            yValueMapper: (_ChartData data, _) => data.value,
                            name: 'Historical',
                            color: Colors.blue.withOpacity(0.7),
                            borderColor: Colors.blue,
                            borderWidth: 2,
                            opacity: 0.3,
                            markerSettings: MarkerSettings(
                              isVisible: true,
                              shape: DataMarkerType.circle,
                              borderWidth: 2,
                              borderColor: Colors.blue,
                              color: Colors.white,
                            ),
                          ),
                          // Prediction Data Series
                          SplineAreaSeries<_ChartData, DateTime>(
                            dataSource: _predictionData,
                            xValueMapper: (_ChartData data, _) => data.date,
                            yValueMapper: (_ChartData data, _) => data.value,
                            name: 'Prediction',
                            color: Colors.red.withOpacity(0.6),
                            borderColor: Colors.red,
                            borderWidth: 2,
                            opacity: 0.3,
                            dashArray: <double>[5, 5],
                            markerSettings: MarkerSettings(
                              isVisible: true,
                              shape: DataMarkerType.diamond,
                              borderWidth: 2,
                              borderColor: Colors.red,
                              color: Colors.white,
                            ),
                          ),
                        ],
                        crosshairBehavior: CrosshairBehavior(
                          enable: true,
                          lineType: CrosshairLineType.vertical,
                        ),
                        onZooming: (ZoomPanArgs args) {
                          // Update the zoom position and factor for restoring after rebuild
                          _zoomPosition = args.currentZoomPosition;
                          _zoomFactor = args.currentZoomFactor;
                        },
                      ),
                ),
              ),
            ),
            // Instructions for zoom interaction
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Center(
                child: Text(
                  'Pinch or use trackpad to zoom, drag to pan',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartData {
  final DateTime date;
  final double value;
  final String series;
  
  _ChartData(this.date, this.value, this.series);
}
