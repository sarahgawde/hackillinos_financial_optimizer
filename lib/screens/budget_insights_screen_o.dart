// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import '../../services/api_service.dart';

// class BudgetInsightsScreen extends StatefulWidget {
//   @override
//   _BudgetInsightsScreenState createState() => _BudgetInsightsScreenState();
// }

// class _BudgetInsightsScreenState extends State<BudgetInsightsScreen> {
//   List<FlSpot> _chartData = [];
//   String _budgetMessage = "Loading...";
//   Timer? _timer;

//   @override
//   void initState() {
//     super.initState();
//     fetchSpendingData();
//   }

//   void fetchSpendingData() async {
//     try {
//       print("Account no: 409000611074\'");
//       var data = await ApiService.getSpendingAnalysis("409000611074\'");
//       print("Data: $data");

//       setState(() {
//         _budgetMessage = data["insight"];
//         _updateChartData(data["prediction"]);
//       });
//     } catch (e) {
//       setState(() {
//         _budgetMessage = "Error fetching data.";
//       });
//     }
//   }

//   void _updateChartData(List<dynamic> predictions) {
//     List<FlSpot> newSpots = [];
//     for (int i = 0; i < predictions.length; i++) {
//       newSpots.add(FlSpot(i.toDouble(), predictions[i].toDouble()));
//     }

//     setState(() {
//       _chartData.addAll(newSpots);
//       if (_chartData.length > 30) {
//         _chartData.removeRange(0, _chartData.length - 30); // Keep last 30 points
//       }
//     });
//   }

//   @override
//   void dispose() {
//     // _timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Budget Insights")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Insight Message
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

//             // Graph inside a Card
//             Expanded(
//               child: Card(
//                 elevation: 6,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.all(16.0),
//                   child: _chartData.isEmpty
//                       ? Center(child: CircularProgressIndicator())
//                       : LineChart(
//                           LineChartData(
//                             backgroundColor: Colors.white,
//                             gridData: FlGridData(show: false),
//                             titlesData: FlTitlesData(
//                               leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                               bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                               topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                               rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                             ),
//                             borderData: FlBorderData(show: false),
//                             lineBarsData: [
//                               LineChartBarData(
//                                 spots: _chartData,
//                                 isCurved: true,
//                                 color: Colors.blueAccent,
//                                 barWidth: 2.5,
//                                 isStrokeCapRound: true,
//                                 belowBarData: BarAreaData(
//                                   show: true,
//                                   gradient: LinearGradient(
//                                     colors: [
//                                       Colors.blueAccent.withOpacity(0.3),
//                                       Colors.blueAccent.withOpacity(0.0)
//                                     ],
//                                     begin: Alignment.topCenter,
//                                     end: Alignment.bottomCenter,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/api_service.dart';

class BudgetInsightsScreen extends StatefulWidget {
  @override
  _BudgetInsightsScreenState createState() => _BudgetInsightsScreenState();
}

class _BudgetInsightsScreenState extends State<BudgetInsightsScreen> {
  List<FlSpot> _historicalData = []; // Past transactions
  List<FlSpot> _predictionData = []; // Future predictions
  String _budgetMessage = "Loading...";
  // Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchSpendingData();
  }

  void fetchSpendingData() async {
    try {
      print("Fetching data for account: 409000611074\'");
      var data = await ApiService.getSpendingAnalysis("409000611074\'");
      print("Data received: $data");

      setState(() {
        _budgetMessage = data["insight"];
        _updateChartData(data["historical"], data["prediction"]);
      });
    } catch (e) {
      setState(() {
        _budgetMessage = "Error fetching data.";
      });
    }
  }

  void _updateChartData(List<dynamic> historical, List<dynamic> predictions) {
    List<FlSpot> historicalSpots = [];
    List<FlSpot> predictionSpots = [];
    
    // Add historical data
    for (int i = 0; i < historical.length; i++) {
      historicalSpots.add(FlSpot(i.toDouble(), historical[i].toDouble()));
    }

    // Add predicted data, continuing from where historical ends
    for (int i = 0; i < predictions.length; i++) {
      predictionSpots.add(FlSpot((historical.length + i).toDouble(), predictions[i].toDouble()));
    }

    setState(() {
      _historicalData = historicalSpots;
      _predictionData = predictionSpots;
    });
  }

  @override
  void dispose() {
    // _timer?.cancel();
    super.dispose();
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Budget Insights")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Insight Message
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

            // Graph inside a Card
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
                      : LineChart(
                          LineChartData(
                            backgroundColor: Colors.white,
                            gridData: FlGridData(show: true, drawHorizontalLine: true, drawVerticalLine: false),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      value.toString(),
                                      style: TextStyle(color: Colors.black),
                                    );
                                  },
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.toString(),
                                    style: TextStyle(color: Colors.black),
                                  );
                                }),
                              ),
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey, width: 1)),
                            lineBarsData: [
                              // Historical Data (Blue)
                              LineChartBarData(
                                spots: _historicalData,
                                isCurved: true,
                                color: Colors.blue,
                                barWidth: 3,
                                isStrokeCapRound: true,
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    colors: [Colors.blue.withOpacity(0.3), Colors.blue.withOpacity(0.0)],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                dotData: FlDotData(show: true, getDotPainter: (spot, percent, lineChartBarData, index) {
                                  return FlDotCirclePainter(radius: 5, color: Colors.blue, strokeWidth: 2, strokeColor: Colors.white);
                                }),
                              ),
                              // Future Predictions (Red)
                              LineChartBarData(
                                spots: _predictionData,
                                isCurved: true,
                                color: Colors.red,
                                barWidth: 3,
                                isStrokeCapRound: true,
                                dashArray: [5, 5], // Dashed line for predictions
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    colors: [Colors.red.withOpacity(0.3), Colors.red.withOpacity(0.0)],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                dotData: FlDotData(show: true, getDotPainter: (spot, percent, lineChartBarData, index) {
                                  return FlDotCirclePainter(radius: 5, color: Colors.red, strokeWidth: 2, strokeColor: Colors.white);
                                }),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
            Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 4),
                    Text('Historical'),
                  ],
                ),
                SizedBox(width: 24),
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      color: Colors.red,
                    ),
                    SizedBox(width: 4),
                    Text('Prediction'),
                  ],
                ),
              ],
            ),
          ),
          ],
        ),
      ),
    );
  }
//   Widget build(BuildContext context) {
//   return Scaffold(
//     // appBar: AppBar(title: Text("Budget Insights")),
//     body: Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Insight Message
//           Container(
//             padding: EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.blueAccent.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Text(
//               _budgetMessage,
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//             ),
//           ),
//           SizedBox(height: 16),

//           // Graph inside a Card
//           Expanded(
//             child: Card(
//               elevation: 6,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: (_historicalData.isEmpty && _predictionData.isEmpty)
//                     ? Center(child: CircularProgressIndicator())
//                     : LineChart(
//                         LineChartData(
//                           backgroundColor: Colors.white,
//                           gridData: FlGridData(
//                             show: true, 
//                             drawHorizontalLine: true, 
//                             drawVerticalLine: false,
//                             horizontalInterval: 100, // Add interval to reduce grid density
//                           ),
//                           titlesData: FlTitlesData(
//                             leftTitles: AxisTitles(
//                               sideTitles: SideTitles(
//                                 showTitles: true,
//                                 reservedSize: 40, // Provide more space for labels
//                                 interval: 200, // Set interval between labels
//                                 getTitlesWidget: (value, meta) {
//                                   // Only show values divisible by 200
//                                   if (value % 200 != 0) return SizedBox();
                                  
//                                   return Padding(
//                                     padding: const EdgeInsets.only(right: 8.0),
//                                     child: Text(
//                                       value.toInt().toString(),
//                                       style: TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 10,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                             bottomTitles: AxisTitles(
//                               sideTitles: SideTitles(
//                                 showTitles: true,
//                                 interval: 1, // Show every other label
//                                 reservedSize: 30, // More space for labels
//                                 getTitlesWidget: (value, meta) {
//                                   // Only show integer values
//                                   if (value != value.toInt()) return SizedBox();
                                  
//                                   // Skip some labels to avoid crowding
//                                   if (value.toInt() % 2 != 0) return SizedBox();
                                  
//                                   return Padding(
//                                     padding: const EdgeInsets.only(top: 8.0),
//                                     child: Text(
//                                       value.toInt().toString(),
//                                       style: TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 10,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                             topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                             rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                           ),
//                           lineTouchData: LineTouchData(
//                             touchTooltipData: LineTouchTooltipData(
//                               tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
//                               getTooltipItems: (List<LineBarSpot> touchedSpots) {
//                                 return touchedSpots.map((spot) {
//                                   final String text = '${spot.x.toInt()}: \$${spot.y.toInt()}';
//                                   return LineTooltipItem(
//                                     text,
//                                     const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                                   );
//                                 }).toList();
//                               },
//                             ),
//                           ),
//                           borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey, width: 1)),
//                           lineBarsData: [
//                             // Historical Data (Blue)
//                             LineChartBarData(
//                               spots: _historicalData,
//                               isCurved: true,
//                               color: Colors.blue,
//                               barWidth: 3,
//                               isStrokeCapRound: true,
//                               belowBarData: BarAreaData(
//                                 show: true,
//                                 gradient: LinearGradient(
//                                   colors: [Colors.blue.withOpacity(0.3), Colors.blue.withOpacity(0.0)],
//                                   begin: Alignment.topCenter,
//                                   end: Alignment.bottomCenter,
//                                 ),
//                               ),
//                               dotData: FlDotData(
//                                 show: true, 
//                                 getDotPainter: (spot, percent, lineChartBarData, index) {
//                                   return FlDotCirclePainter(
//                                     radius: 5, 
//                                     color: Colors.blue, 
//                                     strokeWidth: 2, 
//                                     strokeColor: Colors.white
//                                   );
//                                 }
//                               ),
//                             ),
//                             // Future Predictions (Red)
//                             LineChartBarData(
//                               spots: _predictionData,
//                               isCurved: true,
//                               color: Colors.red,
//                               barWidth: 3,
//                               isStrokeCapRound: true,
//                               dashArray: [5, 5], // Dashed line for predictions
//                               belowBarData: BarAreaData(
//                                 show: true,
//                                 gradient: LinearGradient(
//                                   colors: [Colors.red.withOpacity(0.3), Colors.red.withOpacity(0.0)],
//                                   begin: Alignment.topCenter,
//                                   end: Alignment.bottomCenter,
//                                 ),
//                               ),
//                               dotData: FlDotData(
//                                 show: true, 
//                                 getDotPainter: (spot, percent, lineChartBarData, index) {
//                                   return FlDotCirclePainter(
//                                     radius: 5, 
//                                     color: Colors.red, 
//                                     strokeWidth: 2, 
//                                     strokeColor: Colors.white
//                                   );
//                                 }
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//               ),
//             ),
//           ),
          
//           // Legend
//           Padding(
//             padding: const EdgeInsets.only(top: 8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       width: 12,
//                       height: 12,
//                       color: Colors.blue,
//                     ),
//                     SizedBox(width: 4),
//                     Text('Historical'),
//                   ],
//                 ),
//                 SizedBox(width: 24),
//                 Row(
//                   children: [
//                     Container(
//                       width: 12,
//                       height: 12,
//                       color: Colors.red,
//                     ),
//                     SizedBox(width: 4),
//                     Text('Prediction'),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
}
