import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CaregiverProfileViewModel extends ChangeNotifier {
  final experienceController = TextEditingController();
  final rateController = TextEditingController();

  final Map<String, List<String>> availability = {};

  final List<String> days = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];

  final List<String> timeSlots = [
    'Mañana',
    'Mediodía',
    'Tarde',
    'Noche',
  ];

  void toggleAvailability(String day, String slot) {
    if (!availability.containsKey(day)) {
      availability[day] = [];
    }

    if (availability[day]!.contains(slot)) {
      availability[day]!.remove(slot);
    } else {
      availability[day]!.add(slot);
    }

    notifyListeners();
  }

  bool isSelected(String day, String slot) {
    return availability[day]?.contains(slot) ?? false;
  }

  File? profileImage;

  final ImagePicker picker = ImagePicker();

  final nameController = TextEditingController(
    text: "Jotaro Kujo",
  );

  Future<void> showImageSourcePicker(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [

              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Galería'),
                onTap: () async {
                  Navigator.pop(context);

                  final pickedFile = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 50,
                  );

                  if (pickedFile != null) {
                    profileImage = File(pickedFile.path);
                    notifyListeners();
                  }
                },
              ),

              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Cámara'),
                onTap: () async {
                  Navigator.pop(context);

                  final pickedFile = await picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 50,
                  );

                  if (pickedFile != null) {
                    profileImage = File(pickedFile.path);
                    notifyListeners();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

