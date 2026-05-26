import 'package:flutter/material.dart';
import '../services/booking_service.dart';

class CaregiverHomeScreen extends StatefulWidget {

  const CaregiverHomeScreen({
    super.key,
  });

  @override
  State<CaregiverHomeScreen> createState() =>
      _CaregiverHomeScreenState();
}

class _CaregiverHomeScreenState
    extends State<CaregiverHomeScreen> {

  int _selectedIndex = 0;

  void _onItemTapped(int index) {

    setState(() {

      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    const primaryPurple =
        Color(0xFFAC7099);

    final screens = [

      _buildHomeContent(),

      const Center(
        child: Text(
          'Notificaciones',
        ),
      ),

      const Center(
        child: Text(
          'Agenda',
        ),
      ),

      const Center(
        child: Text(
          'Perfil cuidador',
        ),
      ),
    ];

    return Scaffold(

      bottomNavigationBar:
          BottomNavigationBar(

        currentIndex: _selectedIndex,

        onTap: _onItemTapped,

        type:
            BottomNavigationBarType.fixed,

        selectedItemColor:
            primaryPurple,

        unselectedItemColor:
            Colors.grey,

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notis',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Agenda',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),

      body: IndexedStack(

        index: _selectedIndex,

        children: screens,
      ),
    );
  }

  Widget _buildHomeContent() {

    return SafeArea(

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Padding(

            padding:
                const EdgeInsets.all(20),

            child: Row(

              children: [

                CircleAvatar(

                  radius: 25,

                  backgroundColor:
                      Colors.pink
                          .withOpacity(0.2),

                  child: const Icon(
                    Icons.person,
                    color: Colors.pink,
                  ),
                ),

                const Spacer(),

                const Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.end,

                  children: [

                    Text(

                      'Hola, María',

                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,

                        fontSize: 18,
                      ),
                    ),

                    Text(

                      'Solicitudes recibidas',

                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Padding(

            padding: EdgeInsets.only(
              left: 20,
              bottom: 15,
            ),

            child: Text(

              'Solicitudes pendientes',

              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(

            child:
                BookingService
                        .bookings
                        .isEmpty

                    ? const Center(

                        child: Text(
                          'No hay solicitudes aún',
                        ),
                      )

                    : ListView.builder(

                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),

                        itemCount:
                            BookingService
                                .bookings
                                .length,

                        itemBuilder:
                            (context, index) {

                          final booking =

                              BookingService
                                  .bookings[index];

                          return Container(

                            margin:
                                const EdgeInsets.only(
                              bottom: 15,
                            ),

                            padding:
                                const EdgeInsets.all(16),

                            decoration:
                                BoxDecoration(

                              color: Colors.white,

                              borderRadius:
                                  BorderRadius.circular(
                                20,
                              ),

                              boxShadow: [

                                BoxShadow(

                                  color: Colors.black
                                      .withOpacity(0.05),

                                  blurRadius: 10,

                                  offset:
                                      const Offset(
                                    0,
                                    5,
                                  ),
                                ),
                              ],
                            ),

                            child: Column(

                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [

                                Text(

                                  booking.caregiverName,

                                  style:
                                      const TextStyle(

                                    fontSize: 18,

                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(
                                  height: 10,
                                ),

                                Text(
                                  'Horario: ${booking.timeSlot}',
                                ),

                                Text(
                                  'Estado: ${booking.status}',
                                ),

                                const SizedBox(
                                  height: 10,
                                ),

                                Text(
                                  booking.notes.isEmpty

                                      ? 'Sin notas'

                                      : booking.notes,
                                ),
                              ],
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