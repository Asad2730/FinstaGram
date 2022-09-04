import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:finstagram/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  double? height,width;
  final  _key = GlobalKey<FormState>();
  String? email,password,name;
  File? img;

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
                     profileImage(),
                  _registerForm(),
                  _registerBtn(),
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

  Widget _registerForm(){
    return SizedBox(
      height: height! * 0.30,
      child: Form(
        key: _key,
        child:Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _nameText(),
            _emailText(),
            _passwordText(),
          ],
        ) ,
      ),
    );
  }

  Widget _registerBtn(){

    return MaterialButton(
      onPressed: ()=>registerUser(),
      minWidth: width! * 0.50,
      height: height! * 0.05,
      color: Colors.red,
      child: const Text(
        'Register',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }




  Widget _nameText(){

    return TextFormField(
      obscureText: true,
      decoration: const InputDecoration(
        hintText:'Name...',
      ),
      onSaved: (v){
        setState(() {
          name = v;
        });
      },
      validator:(v)=>v!.isNotEmpty?null:'please enter a name!',
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


  Widget profileImage(){
   var imgProvider = img != null?FileImage(img!):const NetworkImage('https://i.pravatar.cc/300');
    return GestureDetector(
      onTap: (){
        FilePicker.platform.pickFiles(type: FileType.image)
            .then((value){
             setState(() { img = File(value!.files.first.path!); });
        },
        );
      },
      child: Container(
        height: height! * 0.15,
        width: height! * 0.15,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: imgProvider as ImageProvider,
          ),
        ),
      ),
    );
  }


  void registerUser() async {

    if(_key.currentState!.validate() && img != null){
      _key.currentState!.save();
      bool result = await fireBaseService!.registerUser(name: name!, email: email!, password: password!, image: img!);

      if(result){
         Navigator.pop(context);
      }

    }

  }




}
