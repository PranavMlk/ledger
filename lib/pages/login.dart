import 'package:flutter/material.dart';
import 'package:ledger/pages/homepage.dart';
import 'package:ledger/pages/sign_up.dart';
import '../controller/sql_helper.dart';
import 'admin.dart';
import 'login_signup.dart';

class Login_Form extends StatefulWidget {
  @override
  State<Login_Form> createState() => _Login_FormState();
}

class _Login_FormState extends State<Login_Form> {
  var formkey = GlobalKey<FormState>();
  final TextEditingController conemail = TextEditingController();
  final TextEditingController conpass = TextEditingController();

  void logincheck (String email,String password) async{
    if( email == 'admin@gmail.com' &&  password == '123456'){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AdminHome()));

    }else {
      var data = await SQLHelper.CheckLogin(email, password);
      if(data.isNotEmpty){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Homepage()));
        print('Login Success');
      }else if(data.isEmpty){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Login_Signup()));
        print('Login faild');
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    bool hidepass = true;
    return Scaffold(
      appBar: AppBar(

        title: Text("LOGIN PAGE"),
      ),
      body: Form(
        key: formkey,
        child: ListView(
          children: [
            Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    "Login Page",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                controller: conemail,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.drive_file_rename_outline),
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
                validator: (value) {
                  if (value != null) {
                    if (value.contains('@') && value.endsWith('.com')) {
                      return null;
                    }
                    return 'Enter a Valid Email Address';
                  }
                },
                textInputAction: TextInputAction.next,
              ),
            ),
            Padding(
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  controller: conpass,
                  obscureText: hidepass,
                  obscuringCharacter: "*",
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          if (hidepass)
                            hidepass = false;
                          else
                            hidepass = true;
                        });
                      },
                      icon: Icon(
                          hidepass ? Icons.visibility : Icons.visibility_off),
                    ),
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (pass) {
                    if (pass == null || pass.trim().isEmpty) {
                      return 'This field is required';
                    }
                    if (pass.trim().length < 8) {
                      return 'Password must be at least 8 characters in length';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                )),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: MaterialButton(
                color: Colors.pink,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                onPressed: () {
                  final valid = formkey.currentState!.validate();

                  if(valid) {
                    logincheck(conemail.text,conpass.text);
                  } else {

                  }
                },
                child: Text("LOGIN"),
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>  Signup_Form()));
                }, child: Text('Not a User? Register Here!!!'))
          ],
        ),
      ),
    );
  }
}
