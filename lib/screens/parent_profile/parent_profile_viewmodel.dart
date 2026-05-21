import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/child_model.dart';

class ParentProfileViewModel extends ChangeNotifier {

  final nameController = TextEditingController(
    text: "Dio Brando",
  );

  List<ChildModel> children = [
    ChildModel(),
  ];

  File? profileImage;

  final ImagePicker picker = ImagePicker();

  void addChild() {

    children.add(
      ChildModel(),
    );

    notifyListeners();
  }

  void removeChild(int index) {

    if (children.length > 1) {

      children.removeAt(index);

      notifyListeners();
    }
  }

  Future<void> showImageSourcePicker(
      BuildContext context) async {

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

                  final pickedFile =
                      await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 50,
                  );

                  if (pickedFile != null) {

                    profileImage =
                        File(pickedFile.path);

                    notifyListeners();
                  }
                },
              ),

              ListTile(
                leading:
                    const Icon(Icons.camera_alt),

                title: const Text('Cámara'),

                onTap: () async {

                  Navigator.pop(context);

                  final pickedFile =
                      await picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 50,
                  );

                  if (pickedFile != null) {

                    profileImage =
                        File(pickedFile.path);

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