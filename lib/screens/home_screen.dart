import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Función para manejar el cambio de pestañas abajo
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Color morado principal que estamos usando para la navegación
    const primaryPurple = Color(0xFFAC7099);

    return Scaffold(
      // 1. BARRA DE NAVEGACIÓN INFERIOR
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notis'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Agenda'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 2. PARTE SUPERIOR: TODO ALINEADO A LA DERECHA (SALUDO + FOTO)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  const Spacer(), // Empuja todo el contenido de la fila a la derecha
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.end, // Alinea el texto a la derecha
                    children: [
                      Text(
                        'Hola, Krystina', 
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        'Encuentra a tu cuidador ideal', 
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12), // Espacio entre el texto y la foto
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.pink.withOpacity(0.2),
                    child: const Icon(Icons.person, color: Colors.pink),
                  ),
                ],
              ),
            ),

            // 3. FILTROS (Botones en color Rosa bien visible)
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
                        backgroundColor: Colors.pink, // Cambiado a rosa llamativo
                        foregroundColor: Colors.white, // Texto en blanco para alto contraste
                        elevation: 3, // Sombra marcada para que resalten del fondo
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

            // 4. CATÁLOGO (Scroll Vertical con fotos de comida)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    height: 200,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ],
                      image: DecorationImage(
                        image: NetworkImage('https://source.unsplash.com/featured/?food,cooking&sig=$index'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                        ),
                      ),
                      padding: const EdgeInsets.all(15),
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Menú Especial $index',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}