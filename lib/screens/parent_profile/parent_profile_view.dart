import 'package:flutter/material.dart';

import '../../models/child_model.dart';
import 'parent_profile_viewmodel.dart';

class ParentProfileView extends StatefulWidget {
  const ParentProfileView({super.key});

  @override
  State<ParentProfileView> createState() =>
      _ParentProfileViewState();
}

class _ParentProfileViewState
    extends State<ParentProfileView> {

  final viewModel = ParentProfileViewModel();

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
        title: const Text("Perfil del Tutor"),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            // FOTO PERFIL
            MouseRegion(
              cursor: SystemMouseCursors.click,

              child: GestureDetector(

                onTap: () async {

                  await viewModel
                      .showImageSourcePicker(context);

                  setState(() {});
                },

                child: CircleAvatar(
                  radius: 60,

                  backgroundImage:
                      viewModel.profileImage != null
                          ? FileImage(
                              viewModel.profileImage!,
                            ) as ImageProvider
                          : null,

                  child: viewModel.profileImage == null
                      ? const Icon(
                          Icons.camera_alt,
                          size: 40,
                        )
                      : null,
                ),
              ),
            ),

            const SizedBox(height: 15),

            // NOMBRE DEL TUTOR
            TextField(
              controller: viewModel.nameController,
              textAlign: TextAlign.center,

              decoration: const InputDecoration(
                hintText: "Nombre del tutor",
                border: InputBorder.none,
              ),

              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            // NIÑOS DINAMICOS
            ...viewModel.children
                .asMap()
                .entries
                .map((entry) {

              int index = entry.key;

              ChildModel child = entry.value;

              return Card(

                margin: const EdgeInsets.only(
                  bottom: 20,
                ),

                child: Padding(
                  padding: const EdgeInsets.all(16),

                  child: Column(
                    children: [

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,

                        children: [

                            Text(
                              "Niño ${index + 1}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                          TextButton.icon(
                            onPressed: () {
                              viewModel.removeChild(index);
                            },

                            icon: const Icon(
                              Icons.close,
                              size: 18,
                              color: Colors.red,
                            ),

                            label: const Text(
                              "Borrar niño",
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      TextField(
                        decoration: const InputDecoration(
                          labelText: "Nombre del niño",
                          border: OutlineInputBorder(),
                        ),

                        onChanged: (value) {
                          child.name = value;
                        },
                      ),

                      const SizedBox(height: 15),

                      TextField(
                        decoration: const InputDecoration(
                          labelText: "Edad",
                          border: OutlineInputBorder(),
                        ),

                        onChanged: (value) {
                          child.age = value;
                        },
                      ),

                      const SizedBox(height: 15),

                      TextField(
                        maxLines: 3,

                        decoration: const InputDecoration(
                          labelText:
                              "Necesidades especiales",

                          border: OutlineInputBorder(),
                        ),

                        onChanged: (value) {
                          child.specialNeeds = value;
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),

            // BOTON AGREGAR NIÑO
            ElevatedButton.icon(

              onPressed: () {
                viewModel.addChild();
              },

              icon: const Icon(Icons.add),

              label: const Text(
                "Agregar niño",
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(

                onPressed: () {

                  print(viewModel.children);

                },

                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                  ),
                ),

                child: const Text(
                  "Guardar Perfil",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}