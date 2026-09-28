import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_app_abbas/models/event_mode.dart';
import 'package:evently_app_abbas/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  static Future<UserCredential> createAccount({
    required String email,
    required String password,
  }) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return userCredential;
  }

  static Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    var userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential;
  }

 static Future<void> logOut(){
    return FirebaseAuth.instance.signOut();
  }

  static CollectionReference<UserModel> _getUsersCollection() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference<UserModel> usersCollection = db
        .collection("Users")
        .withConverter<UserModel>(
          fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
          toFirestore: (user, _) => user.toJson(),
        );
    return usersCollection;
  }

  static Future<void> addUserToFireStore(UserModel user) {
    CollectionReference<UserModel> usersCollection = _getUsersCollection();
    DocumentReference<UserModel> userDocument = usersCollection.doc(user.id);
    return userDocument.set(user);
  }

  static Future<UserModel> getUserFromFireStore(String uid) async {
    CollectionReference<UserModel> usersCollection = _getUsersCollection();
    DocumentReference<UserModel> userDocument = usersCollection.doc(uid);
    DocumentSnapshot<UserModel> docSnapShot = await userDocument.get();
    return docSnapShot.data()!;
  }

 static CollectionReference<EventModel> _getEventsCollection(){
    FirebaseFirestore db = FirebaseFirestore.instance;
 CollectionReference<EventModel> eventsCollection =    db.collection("Events").withConverter<EventModel>(
        fromFirestore: (docSnapshot, _)=> EventModel.fromFireStore(docSnapshot.data()!),
        toFirestore: (event, _)=> event.toJson());
 return eventsCollection;
  }

 static Future<void>addEventToFireStore(EventModel event){
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference<EventModel> eventsCollection = _getEventsCollection();
    DocumentReference<EventModel> eventDocument = eventsCollection.doc();
    event.id = eventDocument.id;
   return  eventDocument.set(event);
  }
}
