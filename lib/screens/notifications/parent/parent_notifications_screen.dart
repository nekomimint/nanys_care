import 'package:flutter/material.dart';
import 'package:nanys_care/screens/notifications/booking_tab.dart';
import '../../../../models/user_model.dart';
import '../../../../models/booking_model.dart';
import '../../../../services/booking_service.dart';

class ParentNotificationsScreen extends StatelessWidget {
  final UserModel user;
  const ParentNotificationsScreen({super.key, required this.user});

  static const _purple = Color(0xFFAC7099);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5EDE8),
        appBar: AppBar(
          backgroundColor: _purple,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(
            'Mis citas',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            tabs: [
              Tab(text: 'Pendientes'),
              Tab(text: 'Próximas'),
              Tab(text: 'Historial'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BookingTab(
              futureBuilder: () => BookingService.getPendingByTutor(user.uid),
              isCaregiver: false,
              emptyMessage: 'No tienes solicitudes pendientes',
              actionBuilder: (booking, refresh) => SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final reasonController = TextEditingController();
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Cancelar solicitud'),
                        content: TextField(
                          controller: reasonController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: 'Motivo (opcional)...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Volver'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text(
                              'Confirmar',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      final reason = reasonController.text.trim().isEmpty
                          ? 'No se especificó el motivo'
                          : reasonController.text.trim();
                      await BookingService.cancelBooking(
                        bookingUid: booking.uid,
                        cancelledBy: 'tutor',
                        reason: reason,
                      );
                      refresh();
                    }
                  },
                  child: const Text('Cancelar solicitud'),
                ),
              ),
            ),
            BookingTab(
              futureBuilder: () => BookingService.getUpcomingByTutor(user.uid),
              isCaregiver: false,
              emptyMessage: 'No tienes citas próximas',
            ),
            BookingTab(
              futureBuilder: () => BookingService.getHistoryByTutor(user.uid),
              isCaregiver: false,
              emptyMessage: 'No tienes citas pasadas',
            ),
          ],
        ),
      ),
    );
  }
}
