import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/children_model.dart';

class ChildrenService {
  static Future<List<ChildrenModel>> getChildrenByTutor(String tutorUid) async {
    final snap = await FirebaseFirestore.instance
        .collection('children')
        .where('uid_father', isEqualTo: tutorUid)
        .where('active', isEqualTo: true) // ← solo activos
        .get(const GetOptions(source: Source.server));

    return snap.docs
        .map((doc) => ChildrenModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  static Future<void> addChild(ChildrenModel child) async {
    await FirebaseFirestore.instance.collection('children').add({
      ...child.toFirestore(),
      'active': true,
    });
  }

  static Future<void> updateChild(ChildrenModel child) async {
    await FirebaseFirestore.instance
        .collection('children')
        .doc(child.uid)
        .update(child.toFirestore());
  }

  static Future<void> deactivateChild(String uid) async {
    await FirebaseFirestore.instance.collection('children').doc(uid).update({
      'active': false,
    });
  }
}
