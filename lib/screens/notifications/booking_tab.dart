import 'package:flutter/material.dart';
import '../../models/booking_model.dart';
import '../../widgets/booking_card.dart';
import '../../widgets/booking_card_expanded.dart';

class BookingTab extends StatefulWidget {
  final Future<List<BookingModel>> Function() futureBuilder;
  final bool isCaregiver;
  final String emptyMessage;
  final Widget Function(BookingModel, VoidCallback refresh)? actionBuilder;

  const BookingTab({
    super.key,
    required this.futureBuilder,
    required this.isCaregiver,
    required this.emptyMessage,
    this.actionBuilder,
  });

  @override
  State<BookingTab> createState() => _BookingTabState();
}

class _BookingTabState extends State<BookingTab> {
  late Future<List<BookingModel>> _future;
  @override
  void initState() {
    super.initState();
    _future = widget.futureBuilder(); // ← llama la función
  }

  void _refresh() {
    setState(() => _future = widget.futureBuilder()); // ← crea nuevo Future
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BookingModel>>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(child: Text('Error: ${snap.error}'));
        }
        if (!snap.hasData || snap.data!.isEmpty) {
          return Center(
            child: Text(
              widget.emptyMessage,
              style: const TextStyle(color: Colors.black45),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          itemCount: snap.data!.length,
          itemBuilder: (context, index) {
            final booking = snap.data![index];
            return BookingCardExpanded(
              // ← cambia BookingCard por esto
              booking: booking,
              isCaregiver: !widget.isCaregiver,
              trailing: widget.actionBuilder?.call(booking, _refresh),
            );
          },
        );
      },
    );
  }
}
