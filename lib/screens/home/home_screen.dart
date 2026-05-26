import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../profile/profile_screen.dart';
import 'caregiver/search_caregiver_screen.dart';
import '../../models/user_model.dart';
import '../../widgets/search_button.dart';
import '../../widgets/greetin_header.dart';
import '../agenda/agenda_screen.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/screens_by_role_.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user; // ← campo
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFFAC7099);
    print('ROL DEL USUARIO: ${widget.user.role}'); // ← esto

    final screens = ScreensByRole.get(
      user: widget.user,
      homeContent: _buildHomeContent(),
    );
    return Scaffold(
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        role: widget.user.role,
      ),
      body: IndexedStack(index: _selectedIndex, children: screens),
    );
  }

  Widget _buildHomeContent() {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ENCABEZADO
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // ← separa los hijos
              children: [
                //* Logica de si es cuidador o no, porque el cuidador no va a buscar otros cuidadores
                if (widget.user.role == 'parent')
                  SearchButton(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SearchCaregiverScreen(),
                      ),
                    ),
                  ),
                // ← sin Spacer
                GreetingHeader(
                  // ← sin Flexible
                  name: widget.user.name,
                  photoUrl: widget.user.photoUrl,
                  onPhotoTap: () => _onItemTapped(3),
                ),
              ],
            ),
          ),
          Text(widget.user.role),

          // FILTROS
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 25, bottom: 10),
            child: Text(
              'Catálogo de servicios',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  height: 200,
                  width: 110,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Imagen con caché
                        CachedNetworkImage(
                          imageUrl: 'https://picsum.photos/seed/$index/400/200',
                          fit: BoxFit.cover,
                          // Mientras carga
                          placeholder: (context, url) => Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          // Si falla la carga
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.broken_image,
                              color: Colors.grey,
                            ),
                          ),
                        ),

                        // Gradiente encima de la imagen
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.7),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),

                        // Texto encima del gradiente
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'Menú Especial $index',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
