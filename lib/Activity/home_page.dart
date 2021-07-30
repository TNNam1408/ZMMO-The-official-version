import 'dart:convert';
import 'dart:core';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loginapi/Activity/login_page.dart';
import 'package:loginapi/MenuNavigation/changepassword.dart';
import 'package:loginapi/utility/app_url.dart';
import 'package:loginapi/utility/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  PageController _pageController;
  TextEditingController _textGroup = TextEditingController();
//------------------------------------------------------------------------------
//ADDGROUP ----------------------------------------
  bool _isLoading;
  addGroup(String group)async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map body = {
      "group_name": group,

    };
    var jsonResponse;
    var res = await http.post(AppUrl.addGroup, body: body,headers: {"x-access-token" :sharedPreferences.getString('token')});
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
            msg: "Add Group Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );

        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (BuildContext context)=> HomePage()),
        //         (Route<dynamic> route) => false);
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
//GET GROUP----------------------------------------

  List data;
  Future<String>getGroup() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var response = await http.get(
      AppUrl.getGroup,
      headers: {"x-access-token" :sharedPreferences.getString('token')}
    );
    print(response.body);

    setState(() {
      var converDataGroup = json.decode(response.body);
      data = converDataGroup['data'];
    });

    return "Success";
  }


//------------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    this.getGroup();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
//------------------------------------------------------------------------------
  navigateToSignout()async{
    await  Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context)=> LoginPage()),
            (Route<dynamic> route) => false);
  }

  //sign up
  navigateChangePassword()async{
    await  Navigator.push(context, MaterialPageRoute(
      builder: (context)=>ChangePassword(),
    ));
  }
//------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page ZMMO'),
          backgroundColor: Colors.orange,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(

                color: Colors.orange,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                    bottomLeft: Radius.circular(100),
                    bottomRight: Radius.circular(0)),

              ),
                child: Container(
                  margin: EdgeInsets.only(right: 100,bottom: 30),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: Colors.cyan,
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        image: new ExactAssetImage("assets/images/timmotiviration.jpg"),
                      fit: BoxFit.contain
                    ),
                  ),
                )
            ),
            ListTile(
              title: Text("Change Password", style: TextStyle(fontSize: 25, color: Colors.black),),
              onTap: (){
                navigateChangePassword();
              },
            ),
            ListTile(
              title: Text("Item 2", style: TextStyle(fontSize: 25, color: Colors.black),),
              onTap: (){},
            ),
            ListTile(
              title: Text("Item 3", style: TextStyle(fontSize: 25, color: Colors.black),),
              onTap: (){},
            ),
            // ignore: deprecated_member_use
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // ignore: deprecated_member_use
                Container(
                    color: Color(0xFF000000),
                  // ignore: deprecated_member_use
                  child: FlatButton(
                    minWidth: 200,
                    color: Color(0xFF36FF00),
                    onPressed: ()=>navigateToSignout(),
                    child: Text("Logout", style: TextStyle(fontSize: 30, color: Colors.white),),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SizedBox.expand(
        child: PageView(
          controller:  _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: [
            Container(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("HomePage",style: TextStyle(fontSize: 30, color: Colors.black),),

                  ],
                ),
              )
            ),
            Container(
              padding: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      //ADD GROUP-----------------------------
                      Text("Group User",style: TextStyle(fontSize: 25, color: Colors.black),),
                      TextFormField(
                        style: TextStyle(fontSize: 25,color: Colors.black),
                        autofocus: false,
                        controller: _textGroup,
                        validator: (value)=>value.isEmpty?"Please enter group.":null,
                        decoration: buildInputDecoration("Enter Group","Group", Icons.email),
                      ),
                      // ignore: deprecated_member_use
                      RaisedButton(
                        color: Colors.orange,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25))
                        ),
                        onPressed: ()=>addGroup(_textGroup.text),
                        child: Text("ADD GROUP", style: TextStyle(fontSize: 20, color: Colors.white),),
                      ),

                      //GET GROUP--------------------------
                      Container(
                        height: 300,
                        width: 400,
                        color: Colors.orange,
                        child: ListView.builder(
                          itemCount: data == null ? 0: data.length,
                          itemBuilder: (BuildContext context, int index){
                            return Container(
                              child: Center(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Card(
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Text(data[index]['name'], style: TextStyle(fontSize: 25),),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Text(data[index]['total_all'].toString()),
                                                  Text(data[index]['total_active'].toString()),
                                                  Text(data[index]['total_die'].toString())
                                                ],
                                              ),
                                            ],
                                          ),
                                          padding: EdgeInsets.all(20),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
            ),
            Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Money",style: TextStyle(fontSize: 30, color: Colors.black),),
                  ],
                )
            ),
            Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Setting",style: TextStyle(fontSize: 30, color: Colors.black),),
                  ],
                )
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        backgroundColor: Colors.orangeAccent,
        animationDuration: Duration(milliseconds: 300),
        curve: Curves.easeOutSine,
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: [
          BottomNavyBarItem(
            icon:  Icon(CupertinoIcons.home),
            title: Text('Home'),
            activeColor: Colors.blue,
            inactiveColor: Colors.black
          ),

          BottomNavyBarItem(
            icon:  Icon(CupertinoIcons.cloud),
            title: Text('Via'),
            activeColor: Colors.blue,
            inactiveColor: Colors.black
          ),

          BottomNavyBarItem(
            icon:  Icon(CupertinoIcons.money_dollar_circle),
            title: Text('Money'),
            activeColor: Colors.blue,
            inactiveColor: Colors.black

          ),
          BottomNavyBarItem(
            icon:  Icon(CupertinoIcons.settings),
            title: Text('Setting'),
            activeColor: Colors.blue,
            inactiveColor: Colors.black
          ),
        ],
      ),
    );
  }
}
