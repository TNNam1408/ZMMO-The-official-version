import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loginapi/Activity/home_page.dart';
import 'package:loginapi/Activity/login_page.dart';
import 'package:loginapi/utility/app_url.dart';
import 'package:loginapi/utility/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController _oldpasswordController = TextEditingController();
  TextEditingController _newpasswordController = TextEditingController();
  TextEditingController _repasswordController = TextEditingController();
  bool _isLoading = false;
  //We need the funtion from the server API
  changePassword(String oldpass, String newpass, String repass)async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // Map headers = {
    //   "x-access-token":token,
    // };
    Map body = {

      "Old_password": oldpass,
      "New_password": newpass,
      "Re_enter_password":repass,
    };
    print("${oldpass + newpass + repass}");
    var jsonResponse;
    //eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYwZDAzNzgzOTdjZTE5NWQ4Yjk1ZjM1NCIsImlhdCI6MTYyNDQ5ODg1NH0.v4YhBxajzmo0NV-TExCsi7rBvdWmqmLHYhRl6k-wneY
    var res = await http.put(AppUrl.changePassword, body: body, headers: {"x-access-token" :sharedPreferences.getString('token')});
      //   .then((result) {
      // print(result.statusCode);
      // print(result.body);
      // });

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
            msg: "Change Password Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
        //sharedPreferences.setString("token", jsonResponse['token']);
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
          msg: "${res.body}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password"),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 100),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Change", style: TextStyle(fontSize: 30, color: Colors.orange,fontWeight: FontWeight.bold),),
                    Text("  Password  ", style:
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
                  height: 250,
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
                          controller: _oldpasswordController,
                          validator: (value)=>value.isEmpty?"Please enter old_password.":null,
                          decoration: buildInputDecoration("Enter Old_Password","Old_Password", Icons.lock),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          style: TextStyle(fontSize: 25,color: Colors.black),
                          autofocus: false,
                          //obscureText: true,
                          controller: _newpasswordController,
                          validator: (value)=>value.isEmpty?"Please enter new_password..":null,
                          decoration: buildInputDecoration("Enter New_Password","New_Password", Icons.lock) ,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          style: TextStyle(fontSize: 25,color: Colors.black),
                          autofocus: false,
                          //obscureText: true,
                          controller: _repasswordController,
                          validator: (value)=>value.isEmpty?"Please Re_enter_password..":null,
                          decoration: buildInputDecoration("Re_Enter_Password.","Re_Enter_Password.", Icons.lock) ,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                child: SizedBox(
                  width: 200,
                  height: 40,
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    onPressed: ()=>changePassword(
                        _oldpasswordController.text,
                        _newpasswordController.text,
                        _repasswordController.text),
                    child: Text("Change Password", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 20),),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

