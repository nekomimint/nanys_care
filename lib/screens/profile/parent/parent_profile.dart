import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import '../../../models/user_model.dart';

import '../../../widgets/profile_options/build_child_card.dart';
import '../../../widgets/profile_options/option_profile.dart';

import '../../../models/children_model.dart';

import '../../../services/children_service.dart';

class ParentProfile extends StatelessWidget {
  final UserModel user;
  const ParentProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(user.photoUrl)),
          const SizedBox(width: 12),
          Text(user.name),
          Text("Esto es de padres"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 12),
                OptionProfile(
                  user: user,
                  icon: Icons.location_on_outlined,
                  titleButton: 'Dirección',
                  onTap: () {},
                ),
                const SizedBox(height: 12),

                // Botón Tarifa por hora
                OptionProfile(
                  user: user,
                  icon: Icons.payments_outlined,
                  titleButton: 'Tarifa por hora',
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                FutureBuilder<List<ChildrenModel>>(
                  future: ChildrenService.getChildrenByTutor(user.uid),
                  builder: (context, snap) {
                    if (!snap.hasData)
                      return const SizedBox.shrink(); // cargando
                    if (snap.data!.isEmpty)
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'No hay niños registrados',
                          style: TextStyle(color: Colors.black45),
                        ),
                      );
                    return SizedBox(
                      height: 130,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 16,
                        ),
                        itemCount: snap.data!.length,
                        itemBuilder: (context, index) {
                          return BuildChildCard(child: snap.data![index]);
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
