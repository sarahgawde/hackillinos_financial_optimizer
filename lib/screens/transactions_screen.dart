import 'dart:convert';
import 'package:flutter/services.dart'; // To load local assets
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:csv/csv.dart'; // Import the csv package

class TransactionsScreen extends StatefulWidget {
  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  List<Map<String, dynamic>> transactions = [];

  @override
  void initState() {
    super.initState();
    loadCSVData();
  }

  // Load and parse CSV data
  Future<void> loadCSVData() async {

    final csvData = await rootBundle.loadString('assets/data/category.csv'); // Path to your CSV file

    List<List<dynamic>> rows = const CsvToListConverter().convert(csvData);

    // Assuming first row contains headers and remaining rows contain data
    List<Map<String, dynamic>> loadedTransactions = [];

    for (var row in rows.sublist(1)) {
      loadedTransactions.add({
        'amount': row[1], // Assuming amount is in the second column
        'category': row[0], // Assuming category is in the first column
        'date': row[2], // Assuming date is in the third column
      });
    }
    print(loadedTransactions);
    setState(() {
      transactions = loadedTransactions;
    });
  }
  
  Map<String, double> getChartData() {
    Map<String, double> data = {};
    for (var transaction in transactions) {
      data[transaction['category']] = (data[transaction['category']] ?? 0) + (transaction['amount']/84).round();
    }
    print("");
    print(data);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Transactions")),
      body: transactions.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show loading indicator until data is fetched
          : Column(
              children: [
                SizedBox(height: 20),
                Text(
                  "Spending Breakdown",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: PieChart(
                    dataMap: getChartData(),
                    animationDuration: Duration(seconds: 1),
                    chartRadius: MediaQuery.of(context).size.width * 0.6,
                    chartType: ChartType.ring,
                    ringStrokeWidth: 32,
                    centerText: "Expenses",
                    legendOptions: LegendOptions(
                      showLegends: true,
                      legendPosition: LegendPosition.bottom,
                      legendTextStyle: TextStyle(fontSize: 14),
                    ),
                    chartValuesOptions: ChartValuesOptions(
                      showChartValues: true,
                      showChartValuesInPercentage: true,
                      decimalPlaces: 1,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          title: Text("${transaction['category']}", style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(transaction['date']),
                          trailing: Text(
                            "\$${(transaction['amount']/84).round()}",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:pie_chart/pie_chart.dart';

// class TransactionsScreen extends StatefulWidget {
//   @override
//   _TransactionsScreenState createState() => _TransactionsScreenState();
// }

// class _TransactionsScreenState extends State<TransactionsScreen> {
//   final List<Map<String, dynamic>> transactions = [
//     {"date": "Feb 28", "amount": 50.0, "category": "Food"},
//     {"date": "Feb 27", "amount": 120.0, "category": "Shopping"},
//     {"date": "Feb 26", "amount": 80.0, "category": "Transport"},
//   ];

//   Map<String, double> getChartData() {
//     Map<String, double> data = {};
//     for (var transaction in transactions) {
//       data[transaction['category']] = (data[transaction['category']] ?? 0) + transaction['amount'];
//     }
//     return data;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Transactions")),
//       body: Column(
//         children: [
//           SizedBox(height: 20),
//           Text(
//             "Spending Breakdown",
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 20),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: PieChart(
//               dataMap: getChartData(),
//               animationDuration: Duration(seconds: 1),
//               chartRadius: MediaQuery.of(context).size.width * 0.6,
//               chartType: ChartType.ring,
//               ringStrokeWidth: 32,
//               centerText: "Expenses",
//               legendOptions: LegendOptions(
//                 showLegends: true,
//                 legendPosition: LegendPosition.bottom,
//                 legendTextStyle: TextStyle(fontSize: 14),
//               ),
//               chartValuesOptions: ChartValuesOptions(
//                 showChartValues: true,
//                 showChartValuesInPercentage: true,
//                 decimalPlaces: 1,
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: transactions.length,
//               itemBuilder: (context, index) {
//                 final transaction = transactions[index];
//                 return Card(
//                   margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   child: ListTile(
//                     title: Text("${transaction['category']}", style: TextStyle(fontWeight: FontWeight.bold)),
//                     subtitle: Text(transaction['date']),
//                     trailing: Text(
//                       "\$${transaction['amount']}",
//                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';

// class TransactionsScreen extends StatelessWidget {
//   final List<Map<String, dynamic>> transactions = [
//     {"date": "Feb 28", "amount": 50.0, "category": "Food"},
//     {"date": "Feb 27", "amount": 120.0, "category": "Shopping"},
//     {"date": "Feb 26", "amount": 80.0, "category": "Transport"},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Transactions")),
//       body: ListView.builder(
//         itemCount: transactions.length,
//         itemBuilder: (context, index) {
//           final transaction = transactions[index];
//           return ListTile(
//             title: Text("${transaction['category']}"),
//             subtitle: Text(transaction['date']),
//             trailing: Text("\$${transaction['amount']}", style: TextStyle(fontWeight: FontWeight.bold)),
//           );
//         },
//       ),
//     );
//   }
// }