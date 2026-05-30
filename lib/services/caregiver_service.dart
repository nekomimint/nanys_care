import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/caregiver_model.dart';

class CaregiverService {
  static Future<List<CaregiverModel>> getTopCaregivers({int limit = 10}) async {
    final snap = await FirebaseFirestore.instance
        .collection('caregivers')
        .orderBy('rating', descending: true)
        .limit(limit)
        .get();

    // Trae los users en paralelo para obtener las fotos
    final caregivers = await Future.wait(
      snap.docs.map((doc) async {
        final data = doc.data();
        final uid = data['uid'] ?? '';

        // Consulta el user para obtener photoUrl
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();

        final photoUrl = userDoc.data()?['photoUrl'] ?? '';
        return CaregiverModel.fromFirestore({...data, 'imageUrl': photoUrl});
      }),
    );

    return caregivers;
  }

  static Future<List<CaregiverModel>> getCaregiversByPrice({
    required int minPrice,
    required int maxPrice,
  }) async {
    print('Buscando caregivers entre \$$minPrice y \$$maxPrice');
    final snap = await FirebaseFirestore.instance
        .collection('caregivers')
        .where('price', isGreaterThanOrEqualTo: minPrice)
        .where('price', isLessThanOrEqualTo: maxPrice)
        .get(const GetOptions(source: Source.server));
    print('Caregivers encontrados: ${snap.docs.length}');
    // Cruza con users para obtener fotos
    final caregivers = await Future.wait(
      snap.docs.map((doc) async {
        final data = doc.data();
        final uid = data['uid'] ?? '';
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();
        final photoUrl = userDoc.data()?['photoUrl'] ?? '';
        return CaregiverModel.fromFirestore({...data, 'imageUrl': photoUrl});
      }),
    );

    return caregivers;
  }
}
