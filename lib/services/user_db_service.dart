import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon/models/user.dart';

const String USER_COLLECTION_REF = "users";

class UserDbService {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _usersRef;
  UserDbService() {
    initializeUserCollection();
  }

  void initializeUserCollection() {
    // call when signing up an user
    _usersRef = _firestore.collection(USER_COLLECTION_REF).withConverter<User>(
        fromFirestore: (snapshots, _) => User.fromJson(snapshots.data()!),
        toFirestore: (user, _) => user.toJson());
  }

  void createUser(User user) async {
    await _usersRef.doc(user.userId).set(user);
  }

  Future<User?> getSpecificUser(String userId) async {
    try {
      final userDoc =
          await _firestore.collection(USER_COLLECTION_REF).doc(userId).get();
      return User.fromJson(userDoc.data()!);
    } catch (e) {
      print("KULLANICI BULUNAMADI: $e");
    }
    return null;
  }

  Future<void> updateUser(User user) async {
    await _usersRef.doc(user.userId).update(user.toJson());
  }
}