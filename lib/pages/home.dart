import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:finstagram/pages/feed.dart';
import 'package:finstagram/pages/profile.dart';
import 'package:finstagram/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int currentPage = 0;
  List<Widget> pages =  [
    const Feed(),
    const Profile(),
  ];

  FireBaseService? fireBaseService;

  @override
  void initState() {
    super.initState();
    fireBaseService = GetIt.instance.get<FireBaseService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: const Text('F-instagram'),
        actions: [
          GestureDetector(
            onTap:_postImage,
            child: const Icon(Icons.add_a_photo),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0,right: 8.0),
            child: GestureDetector(
              onTap: () async {
                fireBaseService!.logout();
                Navigator.popAndPushNamed(context, 'login');
              },
              child: const Icon(Icons.logout),
            ),
          ),
        ],
      ),

      bottomNavigationBar: bottomNav(),
      body: pages[currentPage],
    );
  }


  Widget bottomNav(){

    return BottomNavigationBar(
      currentIndex: currentPage,
        onTap:(i){
          setState(() {
            currentPage = i;
          });
        } ,
        items:const [
          BottomNavigationBarItem(
            label: 'Feed',
              icon: Icon(Icons.feed),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.account_box),
          ),

        ],
    );
  }


  void _postImage() async{
    FilePickerResult? _result = await FilePicker.platform.pickFiles(type: FileType.image);
    File _image =  File(_result!.files.first.path!);
    await fireBaseService!.postImage(_image);
  }
}