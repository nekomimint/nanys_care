// lib/widgets/booking_card_expanded.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/booking_model.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class BookingCardExpanded extends StatelessWidget {
  final BookingModel booking;
  final bool isCaregiver;
  final Widget? trailing;

  const BookingCardExpanded({
    super.key,
    required this.booking,
    required this.isCaregiver,
    this.trailing,
  });

  static const _blockLabels = {
    'manana': 'Mañana',
    'mediodia': 'Mediodía',
    'tarde': 'Tarde',
    'noche': 'Noche',
  };

  static const _statusColors = {
    'pendiente': Colors.orange,
    'confirmada': Colors.green,
    'en_curso': Colors.blue,
    'completada': Colors.teal,
    'cancelada': Colors.red,
    'rechazada': Colors.red,
  };

  @override
  Widget build(BuildContext context) {
    // El uid a consultar depende de quién está viendo
    final uidToFetch = isCaregiver ? booking.tutorUid : booking.caregiverUid;
    final fallbackName = isCaregiver
        ? booking.tutorName
        : booking.caregiverName;
    final fallbackPhoto = isCaregiver ? '' : booking.caregiverPhoto;

    return FutureBuilder<UserModel?>(
      future: UserService.getUserById(uidToFetch),
      builder: (context, snap) {
        final photoUrl = snap.data?.photoUrl ?? fallbackPhoto;
        final name = snap.data?.name ?? fallbackName;
        final statusColor = _statusColors[booking.status] ?? Colors.grey;

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: photoUrl.isNotEmpty
                          ? NetworkImage(photoUrl)
                          : null,
                      onBackgroundImageError: photoUrl.isNotEmpty
                          ? (_, __) {}
                          : null,
                      child: photoUrl.isEmpty
                          ? Text(
                              name.isNotEmpty ? name[0].toUpperCase() : '?',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Muestra shimmer mientras carga
                          snap.connectionState == ConnectionState.waiting
                              ? Container(
                                  height: 16,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                )
                              : Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              booking.status,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.black45,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      DateFormat(
                        'EEEE d MMMM, yyyy',
                        'es_ES',
                      ).format(booking.date),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.black45,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _blockLabels[booking.timeBlock] ?? booking.timeBlock,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.payments_outlined,
                      size: 14,
                      color: Colors.black45,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '\$${booking.priceSnapshot}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
                if (booking.notes.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.note, size: 14, color: Colors.black45),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          booking.notes,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
                if (booking.cancellationReason != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 14,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          booking.cancellationReason!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                if (trailing != null) ...[
                  const SizedBox(height: 12),
                  trailing!,
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
