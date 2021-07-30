import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loginapi/Activity/home_page.dart';
import 'package:loginapi/Activity/signup_page.dart';
import 'package:loginapi/utility/app_url.dart';
import 'package:loginapi/utility/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  //We need the funtion from the server API

  signIn(String email, String pass)async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map body = {
      "email": email,
      "password": pass,
    };
    var jsonResponse;
    var res = await http.post(AppUrl.login, body: body);
    //need to check the API status
    if(res.statusCode == 200){
      jsonResponse = json.decode(res.body);

      print("Response Status: ${res.statusCode}");
      print("Body: ${res.body}");

      if(jsonResponse != null){
        setState(() {
          _isLoading = false;
        });
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );

        sharedPreferences.setString("token", jsonResponse['token']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context)=> HomePage()),
            (Route<dynamic> route) => false);
      }
    }else{
      setState(() {
        _isLoading = false;
      });
      print("Response Body: ${res.body}");
      Fluttertoast.showToast(
          msg: "Login Unsuccessful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  //sign up
  navigateSignUp()async{
    await  Navigator.push(context, MaterialPageRoute(
      builder: (context)=>SignUpPage(),
    ));
  }

  //loginbutton
  // void loginButton(){
  //   _emailController.text == "" ||
  //       // ignore: unnecessary_statements
  //       _passwordController.text == "" ? null :(){
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     signIn(_emailController.text, _passwordController.text);
  //   };
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login ZMMO"),
        backgroundColor: Colors.orange,
      ),
      backgroundColor: Colors.white70,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 100, 10, 40),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Login", style: TextStyle(fontSize: 30, color: Colors.orange,fontWeight: FontWeight.bold),),
                    Text("  ZMMO  ", style:
                    TextStyle(fontSize: 30,
                        color: Colors.black,
                        backgroundColor: Colors.orange,
                        fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              Card(
                elevation: 100,
                shadowColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.white,
                child: Container(
                  alignment: Alignment.center,
                  height: 180,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          style: TextStyle(fontSize: 25,color: Colors.black),
                          autofocus: false,
                          controller: _emailController,
                          //validator: validateEmail,
                          validator: (value)=>value.isEmpty?"Please enter email.":null,
                          //onSaved: (value)=> _emailController = value as TextEditingController,
                          decoration: buildInputDecoration("Enter Email","Email", Icons.email),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          style: TextStyle(fontSize: 25,color: Colors.black),
                          autofocus: false,
                          //obscureText: true,
                          controller: _passwordController,
                          validator: (value)=>value.isEmpty?"Please enter password.":null,
                          //onSaved: (value)=>_passwordController = value as TextEditingController,
                          decoration: buildInputDecoration("Enter Password","Password", Icons.vpn_key) ,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
             // ignore: deprecated_member_use
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                child: SizedBox(
                  width: 200,
                  height: 40,
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    onPressed:
                    // _emailController.text == "" ||
                    //     // ignore: unnecessary_statements
                    //     _passwordController.text == "" ? null :(){
                    //   setState(() {
                    //     _isLoading = false;
                    //   });
                    ()=>signIn(_emailController.text, _passwordController.text),
                    // },
                    child: Text("Login", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 20),),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.orange,
                  ),
                ),
              ),
              SizedBox(height: 10),
              // ignore: deprecated_member_use
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment:CrossAxisAlignment.center,
                  children: [
                    // ignore: deprecated_member_use
                    FlatButton(onPressed: (){},
                      child: Text("Forgot password?",style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ),
                    // ignore: deprecated_member_use
                    FlatButton(onPressed: ()=>navigateSignUp(),
                      child: Text("SignUp",style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}