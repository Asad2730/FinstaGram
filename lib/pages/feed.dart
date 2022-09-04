import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/firebase_service.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {

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
    return SizedBox(
      height: height!,
      width: width!,
      child: _postListView(),
    );
  }


  Widget _postListView(){
     return StreamBuilder<QuerySnapshot>(
         stream: fireBaseService!.getLatestPosts(),
         builder: (BuildContext build,AsyncSnapshot snapshot){
           if(snapshot.hasData){
             var posts = snapshot.data.docs.map((i)=>i.data()).toList();
             //print(posts);
             return ListView.builder(
                 itemCount: posts.length,
                 itemBuilder: (BuildContext buildContext,int index){
                    Map post = posts[index];
                    return Container(
                      margin: EdgeInsets.symmetric(
                          vertical:height! * 0.01,
                          horizontal: width! * 0.05,
                      ),
                      height: height! * 0.30,
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
               child: CircularProgressIndicator(),
             );
           }
         },
     );

  }

}
