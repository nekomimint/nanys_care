import 'package:flutter/material.dart';
import '../../../models/user_model.dart';
import '../../../models/caregiver_model.dart';
import '../../../services/caregiver_service.dart';
import '../../../widgets/caregiver_card.dart';
import '../../../widgets/search_button.dart';
import '../../../widgets/greetin_header.dart';
import '../../../widgets/caregiver_profile_screen.dart';
import '../caregiver/search_caregiver_screen.dart';

class ParentHomeScreen extends StatelessWidget {
  final UserModel user;
  final VoidCallback onProfileTap;

  const ParentHomeScreen({
    super.key,
    required this.user,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SearchButton(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SearchCaregiverScreen(user: user),
                    ),
                  ),
                ),
                GreetingHeader(
                  name: user.name,
                  photoUrl: user.photoUrl,
                  onPhotoTap: onProfileTap,
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20, bottom: 12),
            child: Text(
              'Mejores cuidadores',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<CaregiverModel>>(
              future: CaregiverService.getTopCaregivers(),
              builder: (context, snap) {
                if (snap.hasError)
                  return Center(child: Text('Error: ${snap.error}'));
                if (!snap.hasData)
                  return const Center(child: CircularProgressIndicator());
                if (snap.data!.isEmpty)
                  return const Center(
                    child: Text('No hay cuidadores disponibles'),
                  );
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: snap.data!.length,
                  itemBuilder: (context, index) {
                    return CaregiverCard(
                      caregiver: snap.data![index],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CaregiverProfileScreen(
                            caregiver: snap.data![index],
                            tutor: user,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
