import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messengerapp/screens/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatelessWidget {
  final _emailController=TextEditingController();
  final _passwordController=TextEditingController();
  FirebaseUser currentuser;
  SharedPreferences prefs;

  Future<FirebaseUser> login(String email,String password) async{
    FirebaseAuth _auth=FirebaseAuth.instance;

    try{
      AuthResult result =await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user =result.user;
      return user;
    }catch(e){
      print(e);
      return null;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(

                  padding: EdgeInsets.fromLTRB(75.0, 110.0, 0.0, 0.0),
                  child: Text(
                    'Natupedika',
                    style:
                    TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ),
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                        labelText: 'EMAIL',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        // hintText: 'EMAIL',
                        // hintStyle: ,
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green))),
                    controller: _emailController,
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    decoration: InputDecoration(
                        labelText: 'PASSWORD ',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green))),
                    obscureText: true,
                    controller: _passwordController,
                  ),

                  SizedBox(height: 50.0),
                  Container(
                      height: 40.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.greenAccent,
                        color: Colors.green,
                        elevation: 7.0,
                        child: GestureDetector(
                          onTap: () async{
                            final _email=_emailController.text.toString().trim();
                            final _password=_passwordController.text.toString().trim();
                            FirebaseUser user=await login(_email, _password);
                            currentuser = user;
                            prefs = await SharedPreferences.getInstance();
                            await prefs.setString('id', currentuser.uid);
                            if(user!=null){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>HomePage(currentuserid: user.uid)),
                              );
                            }else{
                              print("Not able to login");
                            }
                          },
                          child: Center(
                            child: Text(
                              'SIGN IN',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      )),
                ],
              )),
        ]));
  }
}