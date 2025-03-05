// import 'package:flutter/material.dart';
// import 'screens/transactions_screen.dart';
// import 'screens/budget_insights_screen.dart';
// import 'screens/card_optimization_screen.dart';

// void main() {
//   runApp(FinanceOptimizerApp());
// }

// class FinanceOptimizerApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Finance Optimizer',
//       // theme: ThemeData(primarySwatch: Colors.blue),
//       theme: ThemeData(
//         primaryColor: Color(0xFF003E5B), // Deep navy blue
//         scaffoldBackgroundColor: Colors.white, // Clean white background
//         appBarTheme: AppBarTheme(
//           backgroundColor: Color(0xFFD22E1E), // AppBar in deep navy blue
//           foregroundColor: Colors.white, // White text/icons on AppBar
//         ),
//         tabBarTheme: TabBarTheme(
//           labelColor: Colors.white, // Active tab text color
//           unselectedLabelColor: Colors.grey, // Inactive tab text color
//           // indicator: BoxDecoration(
//           //   // color: Colors.white.withOpacity(0.2), // Subtle tab indicator
//           //   borderRadius: BorderRadius.circular(10),
//           // ),
//         ),
//         buttonTheme: ButtonThemeData(
//           buttonColor: Color(0xFF0C0D37), // Button background color
//           textTheme: ButtonTextTheme.primary,
//         ),
//       ),
//       home: AuthScreen(), // Start with AuthScreen
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Finance Optimizer"),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => AuthScreen()),
//               );
//             },
//           ),
//         ],
        
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: [
//             Tab(text: "Overview"),
//             Tab(text: "Predictions"),
//             Tab(text: "Recommendations"),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           TransactionsScreen(),
//           BudgetInsightsScreen(),
//           CardOptimizationScreen(),
//         ],
//       ),
//     );
//   }
// }

// // Authentication Screen
// class AuthScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text("Sign In", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
//             SizedBox(height: 20),
//             TextField(
//               decoration: InputDecoration(labelText: "Email", border: OutlineInputBorder()),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               obscureText: true,
//               decoration: InputDecoration(labelText: "Password", border: OutlineInputBorder()),
//             ),
//             SizedBox(height: 10),
//             Align(
//               alignment: Alignment.centerRight,
//               child: TextButton(
//                 onPressed: () {},
//                 child: Text("Forgot Password?"),
//               ),
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => HomeScreen()),
//                 );
//               },
//               child: Text("Sign In"),
//             ),
//             SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text("Don't have an account?"),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => SignUpScreen()),
//                     );
//                   },
//                   child: Text("Create Account"),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Signup Screen
// class SignUpScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Create Account")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               decoration: InputDecoration(labelText: "Full Name", border: OutlineInputBorder()),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               decoration: InputDecoration(labelText: "Email", border: OutlineInputBorder()),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               obscureText: true,
//               decoration: InputDecoration(labelText: "Password", border: OutlineInputBorder()),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               obscureText: true,
//               decoration: InputDecoration(labelText: "Confirm Password", border: OutlineInputBorder()),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => HomeScreen()),
//                 );
//               },
//               child: Text("Sign Up"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'screens/transactions_screen.dart';
import 'screens/budget_insights_screen.dart';
import 'screens/card_optimization_screen.dart';
import 'screens/chatbot.dart';

void main() {
  runApp(FinanceOptimizerApp());
}

class FinanceOptimizerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Optimizer',
      theme: ThemeData(
        primaryColor: Color(0xFF003E5B),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFD22E1E),
          foregroundColor: Colors.white,
        ),
        tabBarTheme: TabBarTheme(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFF0C0D37),
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: AuthScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Finance Optimizer"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AuthScreen()),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Overview"),
            Tab(text: "Expense Trend"),
            Tab(text: "Cards"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TransactionsScreen(),
          BudgetInsightsScreen(),
          CardOptimizationScreen(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatScreen()),
          );
        },
        backgroundColor: Color(0xFFD22E1E),
        child: Icon(Icons.chat, color: Colors.white),
      ),
    );
  }
}

// Placeholder for chatbot screen
class ChatBotScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ChatBot")),
      body: Center(child: Text("Chatbot functionality coming soon!")),
    );
  }
}

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Logo Image
            Center(
              child: ClipOval(
                child: Image.asset(
                  'assets/app_icon.png',  // Ensure the image is in assets
                  height: 100,  // Adjust as needed
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text("Sign In", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(labelText: "Email", border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: "Password", border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text("Forgot Password?"),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Text("Sign In"),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  child: Text("Create Account"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Signup Screen
class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Account")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Logo Image
            Center(
              child: ClipOval(
                child: Image.asset(
                  'assets/app_icon.png',  // Ensure the image is in assets
                  height: 100,  // Adjust as needed
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(labelText: "Full Name", border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: "Email", border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: "Password", border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: "Confirm Password", border: OutlineInputBorder()),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}