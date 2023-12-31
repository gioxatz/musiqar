
import 'package:flutter/material.dart';
import 'signin_page.dart';
import 'menu_page.dart';
import 'swipe_right_page.dart';
import 'data/database_helper.dart';




class HomePage extends StatelessWidget {


  final DatabaseHelper dbHelper = DatabaseHelper();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Center(
          child: Image.asset(
            'assets/logo.png',
            width: 120,
            height: 40,
          ),
        ),
      ),
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.primaryDelta! > 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SwipeRightPage()),
            );
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignInPage()),
                  );
                },
                child: Text('Sign in'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MenuPage()),
                  );
                },
                child: Text('Menu'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Inside a button's onPressed handler or another relevant part of your app
                  int insertedId1 = await dbHelper.insertUser({
                    'email': 'user2@example.com',
                    'password': 'password1234',
                    'name': 'Name2',
                    'surname': 'Surname2',
                    'dateofbirth': '2002-10-10',
                    'bio': 'My short bio',
                  });
                  int insertedId2 = await dbHelper.insertUser({
                    'email': 'user3@example.com',
                    'password': 'password1234',
                    'name': 'Name3',
                    'surname': 'Surname3',
                    'dateofbirth': '2002-09-09',
                    'bio': 'My short bio - 2',
                  });

                  print('Inserted ID: $insertedId1');
                  print('Inserted ID: $insertedId2');
                },
                child: Text('Add data'),
              ),
                ElevatedButton(
                onPressed: () async {
                  // Inside a button's onPressed handler or another relevant part of your app
                  List<Map<String, dynamic>> users = await dbHelper.getAllUsers();
                  print(users);
                },
                child: Text('See data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}