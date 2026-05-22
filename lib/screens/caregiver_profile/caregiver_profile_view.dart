import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/availability_selector.dart';
import 'caregiver_profile_viewmodel.dart';

class CaregiverProfileView extends StatefulWidget {
  const CaregiverProfileView({super.key});

  @override
  State<CaregiverProfileView> createState() => _CaregiverProfileViewState();
}

class _CaregiverProfileViewState extends State<CaregiverProfileView> {
  final viewModel = CaregiverProfileViewModel();

  @override
  void initState() {
    super.initState();

    viewModel.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil del Cuidador"),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () async {
                  await viewModel.showImageSourcePicker(context);
                  setState(() {});
                },
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.secondary,

                  backgroundImage: viewModel.profileImage != null
                      ? FileImage(viewModel.profileImage!) as ImageProvider
                      : null,

                  child: viewModel.profileImage == null
                      ? const Icon(
                          Icons.camera_alt,
                          size: 40,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: viewModel.nameController,
              textAlign: TextAlign.center,

              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),

              decoration: const InputDecoration(
                hintText: "Nombre",
                border: InputBorder.none,
              ),
            ),

            TextField(
              controller: viewModel.experienceController,
              decoration: InputDecoration(
                labelText: "experiencia",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: viewModel.rateController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Tarifa por hora",
                prefixText: "\$ ",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Disponibilidad",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            AvailabilitySelector(viewModel: viewModel),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  print(viewModel.availability);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Guardar Perfil",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
