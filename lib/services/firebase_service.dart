import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

const String collection = 'users',postCollections = 'posts';

class FireBaseService{

  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  Map? currentUser;

  FireBaseService();

  Future login({required String email,required String password}) async{
    try{
      UserCredential credential= await auth.signInWithEmailAndPassword(email: email, password: password);

      if(credential.user != null){
        currentUser = await getUserData(uid: credential.user!.uid);
        return true;
      }
      else{
        return false;
      }
    }catch(e){
      print('ex:$e');
      return false;
    }

  }


  Future getUserData({required String uid}) async{
    DocumentSnapshot doc = await db.collection(collection).doc(uid).get();
    return doc.data() as Map;
  }


  Future registerUser({required String name,required String email,
    required String password,required File image}) async{
    try{

      UserCredential credential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      String uid = credential.user!.uid;
      String fileName = Timestamp.now().millisecondsSinceEpoch.toString()+p.extension(image.path);
      UploadTask task  = storage.ref('images/$uid/$fileName').putFile(image);

      return task.then((snapshot) async {
        String downloadUrl = await snapshot.ref.getDownloadURL();

        //saving to collection
        await db.collection(collection).doc(uid).set({
          "name":name,
          "email":email,
          "image":downloadUrl,
        });

        return true;
      });

    }catch(e){
      print(e);
      return false;
    }
  }


  Future postImage(File _image) async{
    try{
      String fileName = Timestamp.now().millisecondsSinceEpoch.toString()+p.extension(_image.path);
      String uid = auth.currentUser!.uid;
      UploadTask task = storage.ref('images/$uid/$fileName').putFile(_image);

      return await task.then((p0) async{
        String downloadUrl = await p0.ref.getDownloadURL();
        await db.collection(postCollections).add({
          "userId":uid,
          "timeStamp":Timestamp.now(),
          "image":downloadUrl,
        });
        return true;
      });

    }catch(e){
      print(e);
      return false;
    }

  }


  Future logout() async{
    await auth.signOut();
  }


  getLatestPosts(){
     return db.collection(postCollections).orderBy('timeStamp',descending: true).snapshots();
  }


  getPostForUser(){
      String uid = auth.currentUser!.uid;
      return db.collection(postCollections).where('userId',isEqualTo: uid).snapshots();
  }



}