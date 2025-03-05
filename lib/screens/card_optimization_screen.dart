import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class CardOptimizationScreen extends StatefulWidget {
  @override
  _CardOptimizationScreenState createState() => _CardOptimizationScreenState();
}

class _CardOptimizationScreenState extends State<CardOptimizationScreen> {
  String _loadingMessage = "Fetching your best card recommendations...";
  List<CardRecommendation> _recommendations = [];

  @override
  void initState() {
    super.initState();
    fetchCardRecommendations();
  }

  void fetchCardRecommendations() async {
    try {
      var data = await ApiService.getCardRecommendations("409000611074\'");
      print("Card Recommendations: $data");
      var recommendedCards = data["recommended_cards"];
      print(recommendedCards["card_name_1"]);
      print(recommendedCards["card_name_2"]);

      setState(() {
        _recommendations = [
          CardRecommendation(
            cardName: recommendedCards["card_name_1"],
            reason: recommendedCards["reason_1"],
            cardImage: "assets/boa_platinum.png",

          ),
          CardRecommendation(
            cardName: recommendedCards["card_name_2"],
            reason: recommendedCards["reason_2"],
            cardImage: "assets/chase_freedom.png",
          ),
        ];
        _loadingMessage = "Recommendations loaded.";
      });
    } catch (e) {
      setState(() {
        _loadingMessage = "Error fetching data.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Card Optimization")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _recommendations.isEmpty
            ? Center(child: Text(_loadingMessage))
            : Column(
                children: _recommendations.map((rec) => FlipCardWidget(rec)).toList(),
              ),
      ),
    );
  }
}

class CardRecommendation {
  final String cardName;
  final String reason;
  final String cardImage;

  CardRecommendation({required this.cardName, required this.reason, required this.cardImage});
}

class FlipCardWidget extends StatefulWidget {
  final CardRecommendation recommendation;

  FlipCardWidget(this.recommendation);

  @override
  _FlipCardWidgetState createState() => _FlipCardWidgetState();
}


class _FlipCardWidgetState extends State<FlipCardWidget> {
  bool _isFlipped = false;

  void _flipCard() {
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0), // Adds space between cards
      child: GestureDetector(
        onTap: _flipCard,
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return RotationTransition(
              turns: Tween(begin: 0.5, end: 1.0).animate(animation),
              child: child,
            );
          },
          child: _isFlipped
              ? Card(
                  key: ValueKey<bool>(_isFlipped),
                  color: Color(0xFFC7BFCC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Color(0xFF003E5B), width: 2), // Blue border
                  ),
                  child: Container(
                    height: 300,
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        widget.recommendation.reason,
                        style: TextStyle(color: Color(0xFF003E5B), fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              : Card(
                  key: ValueKey<bool>(_isFlipped),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Color(0xFF003E5B), width: 2), // Blue border
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(12)), // Match Card's top corners
                        child: Image.asset(
                          widget.recommendation.cardImage,
                          width: double.infinity,
                          height: 270,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.recommendation.cardName,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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