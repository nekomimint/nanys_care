import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import '../../../models/user_model.dart';

import '../../../widgets/profile_options/build_child_card.dart';
import '../../../widgets/profile_options/option_profile.dart';

import '../../../models/children_model.dart';

import '../../../services/children_service.dart';

import './add_child_sheet.dart';
import './edit_child_sheet.dart';
import './edit_profile_sheet.dart';

class ParentProfile extends StatefulWidget {
  final UserModel user;
  const ParentProfile({super.key, required this.user});

  @override
  State<ParentProfile> createState() => _ParentProfileState();
}

class _ParentProfileState extends State<ParentProfile> {
  late Future<List<ChildrenModel>> _childrenFuture;

  @override
  void initState() {
    super.initState();
    _childrenFuture = ChildrenService.getChildrenByTutor(widget.user.uid);
  }

  int _refreshKey = 0;
  void _openAddChild() async {
    final result = await showModalBottomSheet<bool>(
      // ← tipo bool
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: AddChildSheet(tutorUid: widget.user.uid),
      ),
    );

    if (result == true) {
      setState(() {
        _refreshKey++; // ← incrementar fuerza rebuild completo
        _childrenFuture = ChildrenService.getChildrenByTutor(widget.user.uid);
      });
    }
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
          Text(
            'Tutor',
            style: const TextStyle(fontSize: 28, color: Colors.black45),
          ),
          CircleAvatar(
            backgroundImage: NetworkImage(widget.user.photoUrl),
            radius: 96,
          ),
          const SizedBox(width: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 12),

                OptionProfile(
                  user: widget.user,
                  icon: Icons.edit,
                  titleButton: 'Editar perfil',
                  onTap: () async {
                    final result = await showModalBottomSheet<bool>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        child: EditProfileSheet(user: widget.user),
                      ),
                    );
                    if (result == true) setState(() {}); // refresca el perfil
                  },
                ),

                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: OptionProfile(
                    user: widget.user,
                    icon: Icons.add,
                    titleButton: 'Agregar niño',
                    onTap: _openAddChild,
                  ),
                ),
                const SizedBox(height: 12),
                FutureBuilder<List<ChildrenModel>>(
                  key: ValueKey(_refreshKey),
                  future: _childrenFuture,
                  builder: (context, snap) {
                    print(
                      'FutureBuilder state: ${snap.connectionState} - datos: ${snap.data?.length}',
                    ); // ←
                    if (snap.hasError) return Text('Error: ${snap.error}');
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
                          // ← reemplaza desde aquí
                          return BuildChildCard(
                            child: snap.data![index],
                            onTap: () async {
                              final result = await showModalBottomSheet<bool>(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  child: EditChildSheet(
                                    child: snap.data![index],
                                  ),
                                ),
                              );
                              if (result == true) {
                                setState(() {
                                  _refreshKey++;
                                  _childrenFuture =
                                      ChildrenService.getChildrenByTutor(
                                        widget.user.uid,
                                      );
                                });
                              }
                            },
                          );
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
