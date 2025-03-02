import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://b4b0-130-126-255-178.ngrok-free.app"; 

  static Future<Map<String, dynamic>> getSpendingAnalysis(String userId) async {
    print("here");
    final response = await http.get(Uri.parse('$baseUrl/spending_analysis/$userId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load spending analysis");
    }
  }


  static Future<Map<String, dynamic>> getCardRecommendations(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/credit_card_analysis/$userId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);  // Assuming it returns the entire response with the card recommendation
    } else {
      throw Exception('Failed to load card recommendations');
    }
  }
}