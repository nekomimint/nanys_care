import 'package:flutter/material.dart';
import '../../../models/user_model.dart';
import '../../../models/caregiver_model.dart';
import '../../../widgets/profile_options/option_profile.dart';
import './edit_caregiver_sheet.dart';

class CaregiverProfile extends StatefulWidget {
  final UserModel user;
  final CaregiverModel caregiver;

  const CaregiverProfile({
    super.key,
    required this.user,
    required this.caregiver,
  });

  @override
  State<CaregiverProfile> createState() => _CaregiverProfileState();
}

class _CaregiverProfileState extends State<CaregiverProfile> {
  void _openEditProfile() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: EditCaregiverSheet(
          user: widget.user,
          caregiver: widget.caregiver,
        ),
      ),
    );

    if (result == true) setState(() {}); // refresca el perfil
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            widget.user.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const Text(
            'Cuidador',
            style: TextStyle(fontSize: 28, color: Colors.black45),
          ),
          CircleAvatar(
            backgroundImage: widget.user.photoUrl.isNotEmpty
                ? NetworkImage(widget.user.photoUrl)
                : null,
            child: widget.user.photoUrl.isEmpty
                ? const Icon(Icons.person, size: 45)
                : null,
            radius: 96,
          ),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info del caregiver
                Text(
                  'Experiencia: ${widget.caregiver.experience}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Precio/hora: \$${widget.caregiver.price}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rating: ${widget.caregiver.rating}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),

                OptionProfile(
                  user: widget.user,
                  icon: Icons.edit,
                  titleButton: 'Editar perfil',
                  onTap: _openEditProfile,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
