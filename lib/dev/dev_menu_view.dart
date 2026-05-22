import 'package:flutter/material.dart';

import '../screens/caregiver_profile/caregiver_profile_view.dart';
import '../screens/parent_profile/parent_profile_view.dart';

class DevMenuView extends StatelessWidget {
  const DevMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dev Menu")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CaregiverProfileView(),
                    ),
                  );
                },

                child: const Text("Perfil Cuidador"),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ParentProfileView(),
                    ),
                  );
                },

                child: const Text("Perfil Tutor"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
