import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/children_model.dart';

class ChildrenService {
  static Future<List<ChildrenModel>> getChildrenByTutor(String tutorUid) async {
    final snap = await FirebaseFirestore.instance
        .collection('children')
        .where('uid_father', isEqualTo: tutorUid)
        .get();

    return snap.docs
        .map((doc) => ChildrenModel.fromFirestore(doc.data()))
        .toList();
  }
}
