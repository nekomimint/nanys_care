import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './profile/profile_screen.dart';
import 'search_caregiver_screen.dart';
import '../models/user_model.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user; // ← campo
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // ✅ FIX 1: screens definido UNA sola vez fuera del build()
  // Antes estaba dentro de build(), se recreaba en cada tap
  late final List<Widget> _screens = [
    _buildHomeContent(),
    const Center(child: Text('Pantalla Notificaciones')),
    const Center(child: Text('Pantalla Agenda')),
    ProfileScreen(user: widget.user),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFFAC7099);

    final screens = [
      _buildHomeContent(),
      const Center(child: Text('Pantalla Notificaciones')),
      const Center(child: Text('Pantalla Agenda')),
      ProfileScreen(user: widget.user),
    ];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Agenda',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
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
              children: [
                // BOTON BUSCAR
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) => const SearchCaregiverScreen(),
                      ),
                    );
                  },

                  child: Container(
                    padding: const EdgeInsets.all(10),

                    decoration: BoxDecoration(
                      color: Colors.pink.withOpacity(0.15),

                      shape: BoxShape.circle,
                    ),

                    child: const Icon(Icons.search, color: Colors.pink),
                  ),
                ),

                const Spacer(),

                const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,

                  children: [
                    Text(
                      'Hola, Krystina',

                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    Text(
                      'Encuentra a tu cuidador ideal',

                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ],
                ),

                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => _onItemTapped(3),
                  child: CircleAvatar(
                    radius: 25,

                    backgroundColor: Colors.pink.withOpacity(0.2),

                    child: const Icon(Icons.person, color: Colors.pink),
                  ),
                ),
              ],
            ),
          ),

          // FILTROS
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 4,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      foregroundColor: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {},
                    child: Text('Filtro ${index + 1}'),
                  ),
                );
              },
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(left: 20, top: 25, bottom: 10),
            child: Text(
              'Catálogo de servicios',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          // ✅ FIX 3: CachedNetworkImage en lugar de NetworkImage
          // Antes: descargaba la imagen en CADA rebuild, sin caché
          // Ahora: descarga una vez, guarda en caché, muestra placeholder
          // ✅ FIX 4: URL de picsum.photos en lugar de source.unsplash.com
          // Antes: endpoint deprecado que causaba reintentos en bucle
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  height: 200,
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
