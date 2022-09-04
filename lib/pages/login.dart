import 'package:finstagram/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:get_it/get_it.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  double? height,width;
  final  _key = GlobalKey<FormState>();
  String? email,password;

  FireBaseService? fireBaseService;

  @override
  void initState() {
    super.initState();
    fireBaseService = GetIt.instance.get<FireBaseService>();
  }

  @override
  Widget build(BuildContext context) {
     height = MediaQuery.of(context).size.height;
     width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child:Container(
            padding: EdgeInsets.symmetric(horizontal: width! * 0.05),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   _title(),
                  _loginForm(),
                  _loginBtn(),
                  _registerPage(),
                ],
              ),
            ),
          ),
      ),
    );
  }


  Widget _title(){
    return const Text(
      'F_instagram',
       style:TextStyle(
         fontSize: 25,
         color:Colors.black,
         fontWeight: FontWeight.w600,
       ),
    );
  }


  Widget _loginBtn(){

    return MaterialButton(
      onPressed: ()=> _loginUser(),
      minWidth: width! * 0.70,
      height: height! * 0.06,
      color: Colors.red,
      child: const Text(
          'Login',
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }


  Widget _loginForm(){
    return SizedBox(
      height: height! * 0.20,
      child: Form(
        key: _key,
        child:Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
              _emailText(),
             _passwordText(),
          ],
        ) ,
      ),
    );
  }

  Widget _emailText(){

    return TextFormField(
      decoration: const InputDecoration(
        hintText:'Email...',
      ),
      onSaved: (v){
        setState(() {
          email = v;
        });
      },
      validator:(v){
       bool valid = EmailValidator.validate(v!.trim());
       return valid?null:'please enter a valid email!';
      },
    );
  }

  Widget _passwordText(){

    return TextFormField(
      obscureText: true,
      decoration: const InputDecoration(
        hintText:'Password...',
      ),
      onSaved: (v){
        setState(() {
          password = v;
        });
      },
      validator:(v)=>v!.length > 5?null:'please enter a password greater then 6 characters!',
    );
  }

  Widget _registerPage(){
    return GestureDetector(
      onTap: ()=>Navigator.pushNamed(context, 'register'),
      child: const Text(
        "Don't have an account?",
        style: TextStyle(
          color: Colors.blue,
          fontSize: 15,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }


  void _loginUser() async {
    if(_key.currentState!.validate()){
      _key.currentState!.save();

      bool result = await fireBaseService!.login(email: email!.trim(), password: password!);
      if(result){
        Navigator.popAndPushNamed(context, 'home');
      }

    }

  }


}
