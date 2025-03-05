// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class ChatScreen extends StatefulWidget {
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _controller = TextEditingController();
//   final List<Map<String, String>> _messages = [];
//   final String _apiKey = "AIzaSyBeak8uc0WsLZRjh5U3s8REdfElZl52-uY";
//   bool _isLoading = false;

//   Future<void> sendMessage(String message) async {
//     if (message.isEmpty) return;

//     setState(() {
//       _messages.add({"role": "user", "text": message});
//       _isLoading = true;
//     });

//     _controller.clear();

//     try {
//       // Format messages for Gemini API
//       final formattedMessages = _messages.map((msg) => {
//         "role": msg["role"] == "assistant" ? "model" : "user",
//         "parts": [{"text": msg["text"]}]
//       }).toList();

//       final response = await http.post(
//         Uri.parse("https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$_apiKey"),
//         headers: {
//           "Content-Type": "application/json",
//         },
//         body: jsonEncode({
//           "contents": formattedMessages,
//           "generationConfig": {
//             "temperature": 0.7,
//             "topK": 40,
//             "topP": 0.95,
//             "maxOutputTokens": 1024,
//           },
//         }),
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print("Successs");
//         final botReply = responseData["candidates"][0]["content"]["parts"][0]["text"];

//         setState(() {
//           _messages.add({"role": "assistant", "text": botReply});
//         });
//       } else {
//         setState(() {
//           _messages.add({
//             "role": "assistant", 
//             "text": "Sorry, I encountered an error. Please try again. Status code: ${response.statusCode}"
//           });
//         });
//         print("API Error: ${response.body}");
//       }
//     } catch (e) {
//       setState(() {
//         _messages.add({
//           "role": "assistant", 
//           "text": "Sorry, I encountered an error. Please try again. Error: $e"
//         });
//       });
//       print("Exception: $e");
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Gemini Chat"),
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: _messages.isEmpty
//               ? Center(
//                   child: Text(
//                     "Start a conversation with Gemini!",
//                     style: TextStyle(color: Colors.grey, fontSize: 16),
//                   ),
//                 )
//               : ListView.builder(
//                   itemCount: _messages.length,
//                   padding: EdgeInsets.all(8.0),
//                   itemBuilder: (context, index) {
//                     final msg = _messages[index];
//                     final isUser = msg["role"] == "user";
//                     return Padding(
//                       padding: EdgeInsets.symmetric(vertical: 4.0),
//                       child: Align(
//                         alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
//                         child: Container(
//                           padding: EdgeInsets.all(12),
//                           constraints: BoxConstraints(
//                             maxWidth: MediaQuery.of(context).size.width * 0.75,
//                           ),
//                           decoration: BoxDecoration(
//                             color: isUser ? Colors.deepPurple : Colors.grey[200],
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           child: Text(
//                             msg["text"]!,
//                             style: TextStyle(
//                               color: isUser ? Colors.white : Colors.black87,
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//           ),
//           if (_isLoading)
//             Padding(
//               padding: EdgeInsets.all(8.0),
//               child: LinearProgressIndicator(
//                 backgroundColor: Colors.deepPurple.shade100,
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
//               ),
//             ),
//           Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: InputDecoration(
//                       hintText: "Type a message...",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(24),
//                       ),
//                       filled: true,
//                       fillColor: Colors.grey[200],
//                       contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                     ),
//                     onSubmitted: (text) => sendMessage(text),
//                   ),
//                 ),
//                 SizedBox(width: 8),
//                 FloatingActionButton(
//                   onPressed: () => sendMessage(_controller.text),
//                   child: Icon(Icons.send),
//                   backgroundColor: Colors.deepPurple,
//                   mini: true,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final String _apiKey = "AIzaSyBeak8uc0WsLZRjh5U3s8REdfElZl52-uY";
  bool _isLoading = false;
  String _csvContent = "";
  String _csvFileName = "data.csv";
  bool _csvLoaded = false;

  @override
  void initState() {
    super.initState();
    // Load CSV file when the screen initializes
    loadAssetCSV();
  }

  // Method 1: Read CSV from assets
  Future<void> loadAssetCSV() async {
    try {
      // Load the CSV file from assets
      // Note: You need to add the CSV file to your assets in pubspec.yaml
      final String csvString = await rootBundle.loadString('assets/data/category.csv');
      
      // Parse CSV
      List<List<dynamic>> csvTable = const CsvToListConverter().convert(csvString);
      
      // Convert to nicely formatted string
      String formattedCsv = "";
      for (var row in csvTable) {
        formattedCsv += row.join(", ") + "\n";
      }

      setState(() {
        _csvContent = formattedCsv;
        _csvFileName = "data.csv";
        _csvLoaded = true;
        _messages.add({
          "role": "assistant", 
          "text": "Hello I'm your Personal Finance Assistant - FinBot!"
        });
      });
    } catch (e) {
      setState(() {
        _messages.add({
          "role": "assistant", 
          "text": "Error loading CSV file from assets: $e"
        });
      });
      print("CSV loading error: $e");
    }
  }

  // Method 2: Read CSV from a specific file path


  Future<void> sendMessage(String message) async {
    if (message.isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "text": message});
      _isLoading = true;
    });

    _controller.clear();

    try {
      // Create system message with CSV data as context if available
      List<Map<String, dynamic>> formattedMessages = [];
      
      if (_csvLoaded) {
        // Add system message with CSV context
        formattedMessages.add({
          "role": "user",
          "parts": [{"text": "I'm going to ask questions about the following CSV data. Always show the expenses in USD, given that the csv file has data in INR. Do not explicitly mention the conversion. Use this as context for answering:\n\n$_csvContent"}]
        });
        
        // Add model acknowledgment to maintain conversation flow
        formattedMessages.add({
          "role": "model",
          "parts": [{"text": "I understand. I'll use this CSV data as context to answer your questions. What would you like to know?"}]
        });
      }
      
      // Add conversation history
      formattedMessages.addAll(_messages.map((msg) => {
        "role": msg["role"] == "assistant" ? "model" : "user",
        "parts": [{"text": msg["text"]}]
      }).toList());

      final response = await http.post(
        Uri.parse("https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$_apiKey"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "contents": formattedMessages,
          "generationConfig": {
            "temperature": 0.7,
            "topK": 40,
            "topP": 0.95,
            "maxOutputTokens": 1024,
          },
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final botReply = responseData["candidates"][0]["content"]["parts"][0]["text"];

        setState(() {
          _messages.add({"role": "assistant", "text": botReply});
        });
      } else {
        setState(() {
          _messages.add({
            "role": "assistant", 
            "text": "Sorry, I encountered an error. Please try again. Status code: ${response.statusCode}"
          });
        });
        print("API Error: ${response.body}");
      }
    } catch (e) {
      setState(() {
        _messages.add({
          "role": "assistant", 
          "text": "Sorry, I encountered an error. Please try again. Error: $e"
        });
      });
      print("Exception: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FinBot"),
        backgroundColor: Color(0xFFD22E1E),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: "Reload CSV",
            onPressed: loadAssetCSV,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_csvLoaded)
            // Container(
            //   padding: EdgeInsets.all(8),
            //   color: Color(0xFFD22E1E).withOpacity(0.1),
            //   child: Row(
            //     children: [
                //   Icon(Icons.table_chart, color: Color(0xFFD22E1E)),
                //   SizedBox(width: 8),
                //   Expanded(
                //     child: Text(
                //       "Using data from: $_csvFileName",
                //       style: TextStyle(fontWeight: FontWeight.bold),
                //     ),
                //   ),
                //   IconButton(
                //     icon: Icon(Icons.info_outline),
                //     onPressed: () {
                //       showDialog(
                //         context: context,
                //         builder: (context) => AlertDialog(
                //           title: Text("CSV Data Preview"),
                //           content: SingleChildScrollView(
                //             child: Text(_csvContent),
                //           ),
                //           actions: [
                //             TextButton(
                //               onPressed: () => Navigator.of(context).pop(),
                //               child: Text("Close"),
                //             ),
                //           ],
                //         ),
                //       );
                //     },
                //     tooltip: "View CSV content",
                //   )
            //     ],
            //   ),
            // ),
          Expanded(
            child: _messages.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline, size: 48, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        "Start a conversation with Gemini!",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "CSV data is automatically loaded",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _messages.length,
                  padding: EdgeInsets.all(8.0),
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    final isUser = msg["role"] == "user";
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      child: Align(
                        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(12),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          decoration: BoxDecoration(
                            color: isUser ? Color(0xFF003E5B) : Colors.grey[200],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            msg["text"]!,
                            style: TextStyle(
                              color: isUser ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
          ),
          if (_isLoading)
            Padding(
              padding: EdgeInsets.all(8.0),
              child: LinearProgressIndicator(
                backgroundColor: Colors.deepPurple.shade100,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD22E1E)),
              ),
            ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: _csvLoaded 
                          ? "Ask anything about your finances..." 
                          : "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onSubmitted: (text) => sendMessage(text),
                  ),
                ),
                SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: () => sendMessage(_controller.text),
                  child: Icon(Icons.send),
                  backgroundColor: Color(0xFFD22E1E),
                  mini: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}