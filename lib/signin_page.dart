import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'menu_page.dart';
import 'homepage.dart';
import 'data/database_helper.dart';
import 'widgets/sline.dart';
import 'widgets/custom_input.dart';
import 'widgets/signin_button.dart';


class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController signInEmailController = TextEditingController();
  TextEditingController signInPasswordController = TextEditingController();
  TextEditingController signUpEmailController = TextEditingController();
  TextEditingController signUpPasswordController = TextEditingController();
  TextEditingController signUpConfirmPasswordController = TextEditingController();



  void signIn(BuildContext context) async {
  String email = signInEmailController.text;
  String password = signInPasswordController.text;

  List<Map<String, dynamic>> users = await DatabaseHelper().getAllUsers();
  bool isUserValid = users.any((user) =>
      user['email'] == email && user['password'] == password);

  if (isUserValid) {
    // Get the user data
    Map<String, dynamic> userData =
        users.firstWhere((user) => user['email'] == email);

    // Navigate to the profile page with user data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(userData: userData),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Incorrect username or password.'),
      ),
    );
  }
}

void signUp(BuildContext context) async {
  String email = signUpEmailController.text;
  String password = signUpPasswordController.text;
  String cpassword = signUpConfirmPasswordController.text;

  // Check if the password and confirm password match
  if (password != cpassword) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Passwords do not match!!!'),
      ),
    );
    return;
  }

  List<Map<String, dynamic>> users = await DatabaseHelper().getAllUsers();
  bool isUserExists = users.any((user) => user['email'] == email);

  if (isUserExists) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('User exists!!!'),
      ),
    );
    return;
  }

  // Insert the new user into the database
  await DatabaseHelper().insertUser({'email': email, 'password': password});

  // Get the user data
  Map<String, dynamic> userData =
      users.firstWhere((user) => user['email'] == email);

  // Navigate to the profile page with user data
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProfilePage(userData: userData),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Color(0xFFFEF7FF),
        title: Center(
          child: Image.asset(
            'assets/logo.png',
            width: 150,
            height: 50,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => MenuPage()));
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
      child:GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MenuPage()));
          }
        },
        child:Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'SIGN IN',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                    height: 0.04,
                    letterSpacing: 0.50,
                  ),
                ),
                SizedBox(height: 30),
                // Input boxes
                customInput('Email', signInEmailController, context: context),
                SizedBox(height: 16),
                customInput('Password', signInPasswordController, isPassword: true, context: context),
                SizedBox(height: 16),
                // Sign-in button
                singinbutton(
                  onPressed: () => signIn(context),
                  buttonText: 'Sign in',
                ),
                SizedBox(height: 16),
                sline(),
                const SizedBox(height: 25),

                Text(
                  'SIGN UP',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                    height: 0.04,
                    letterSpacing: 0.50,                ),
                ),
                SizedBox(height: 30),
                // Input boxes
                customInput('Email', signUpEmailController, context: context),
                SizedBox(height: 16),
                customInput('Password', signUpPasswordController, isPassword: true, context: context),
                SizedBox(height: 16),
                customInput('Confirm Password', signUpConfirmPasswordController, isPassword: true, context: context),
                SizedBox(height: 16),
                // Sign-up button
                singinbutton(
                  onPressed: () => signUp(context),
                  buttonText: 'Sign up',
                ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}