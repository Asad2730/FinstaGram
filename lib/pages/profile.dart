import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/firebase_service.dart';


class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  double? height,width;
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
    //cant be a scaffold
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: width! * 0.05,
          vertical: height! * 0.02,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
            _profileImage(),
            _postGridView(),
        ],
      ),
    );
  }

  Widget _profileImage(){
    return Container(
      margin: EdgeInsets.only(bottom: height! * 0.02),
      height: height! * 0.15,
      width: height! * 0.15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(fireBaseService!.currentUser!['image']),
        ),
      ),
    );

  }


  Widget _postGridView(){

    return Expanded(
        child: StreamBuilder<QuerySnapshot>(
          stream: fireBaseService!.getPostForUser(),
          builder: (context,AsyncSnapshot snapshot){
            if(snapshot.hasData){
              var posts = snapshot.data.docs.map((i)=>i.data()).toList();
              //print(posts);
               return GridView.builder(
                   //horizontal axis 2 pics in horizontal
                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                       crossAxisCount: 2,
                       mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                   ),
                   itemCount: posts.length,
                   itemBuilder: (BuildContext build,int index){
                      Map post = posts[index];
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(post['image']),
                          ),
                        ),
                      );
                   },
               );
            }else{
              return const Center(
                child: CircularProgressIndicator(color: Colors.red,),
              );
            }
          },
        ),
    );
  }


}


