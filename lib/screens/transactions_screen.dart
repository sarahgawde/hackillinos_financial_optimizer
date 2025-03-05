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
                // SizedBox(height: 20),
                // Text(
                //   "Spending Breakdown",
                //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                // ),
                // SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
  margin: EdgeInsets.all(16), // Spacing around the chart
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 10,
        spreadRadius: 3,
        offset: Offset(0, 5), // Creates a shadow effect
      ),
    ],
    gradient: LinearGradient(
      colors: [Colors.white, Colors.grey.shade200], // Soft gradient effect
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  child: Card(
    elevation: 10, // Adds a floating effect
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: PieChart(
        dataMap: getChartData(),
        animationDuration: Duration(seconds: 1),
        chartRadius: MediaQuery.of(context).size.width * 0.6,
        chartType: ChartType.ring,
        ringStrokeWidth: 32,
        centerText: "Expenses",
        centerTextStyle: TextStyle(  // Increase font size of "Expenses"
          fontSize: 18, 
          fontWeight: FontWeight.bold, 
          color: Colors.black,
        ),
        colorList: [
          Color(0xFF011f4b),
          Color(0xFFb3cde0),
          Color(0xFF005b96),
          Color(0xFF6497b1),
          Color(0xFF03396c)
        ],
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
  ),
),
                ),
                Expanded(
  child: ListView.builder(
    itemCount: transactions.length,
    itemBuilder: (context, index) {
      final transaction = transactions[index];
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFF004481), width: 1.5), // Capital One blue
          borderRadius: BorderRadius.circular(12),
          color: Colors.white, // Keeping it subtle
        ),
        child: ListTile(
          title: Text(
            transaction['category'],
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF004481)), // Capital One blue
          ),
          subtitle: Text(
            transaction['date'],
            style: TextStyle(color: Colors.grey[600]),
          ),
          trailing: Text(
            "\$${(transaction['amount'] / 84).round()}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFFd03b3b), // Capital One red
            ),
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