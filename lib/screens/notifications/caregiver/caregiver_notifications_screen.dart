import 'package:flutter/material.dart';
import 'package:nanys_care/models/booking_model.dart';
import 'package:nanys_care/screens/notifications/booking_tab.dart';
import '../../../../models/user_model.dart';
import '../../../../services/booking_service.dart';
import '../../../../widgets/booking_card.dart';

class CaregiverNotificationsScreen extends StatelessWidget {
  final UserModel user;
  const CaregiverNotificationsScreen({super.key, required this.user});

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
            // Pendientes — esperando aceptar
            BookingTab(
              futureBuilder: () =>
                  BookingService.getPendingByCaregiver(user.uid),
              isCaregiver: true,
              emptyMessage: 'No tienes solicitudes pendientes',
              actionBuilder: (booking, refresh) => Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      onPressed: () async {
                        await BookingService.rejectBooking(
                          bookingUid: booking.uid,
                        );
                        refresh();
                      },
                      child: const Text('Rechazar'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFAC7099),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        await BookingService.confirmBooking(booking.uid);
                        refresh();
                      },
                      child: const Text('Aceptar'),
                    ),
                  ),
                ],
              ),
            ),

            // Próximas — confirmadas + en curso (incluye hoy)
            BookingTab(
              futureBuilder: () =>
                  BookingService.getUpcomingByCaregiver(user.uid),
              isCaregiver: true,
              emptyMessage: 'No tienes citas próximas',
              actionBuilder: (booking, refresh) => Row(
                children: [
                  Expanded(
                    child: _CancelButton(booking: booking, onDone: refresh),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _FinishButton(booking: booking, onDone: refresh),
                  ),
                ],
              ),
            ),

            // Historial
            BookingTab(
              futureBuilder: () =>
                  BookingService.getHistoryByCaregiver(user.uid),
              isCaregiver: true,
              emptyMessage: 'No tienes historial',
            ),
          ],
        ),
      ),
    );
  }
}

class _CancelButton extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onDone;

  const _CancelButton({required this.booking, required this.onDone});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
              title: const Text('Cancelar cita'),
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
              cancelledBy: 'caregiver',
              reason: reason,
            );
            onDone();
          }
        },
        child: const Text('Cancelar cita'),
      ),
    );
  }
}

class _FinishButton extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onDone;

  const _FinishButton({required this.booking, required this.onDone});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFAC7099),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () async {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Finalizar cita'),
              content: const Text('¿Confirmas que la cita ha concluido?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Finalizar'),
                ),
              ],
            ),
          );

          if (confirm == true) {
            await BookingService.completeBooking(booking.uid);
            onDone();
          }
        },
        child: const Text('Finalizar cita'),
      ),
    );
  }
}
