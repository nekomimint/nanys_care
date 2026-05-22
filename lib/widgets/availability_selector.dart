import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../screens/caregiver_profile/caregiver_profile_viewmodel.dart';

class AvailabilitySelector extends StatelessWidget {
  final CaregiverProfileViewModel viewModel;

  const AvailabilitySelector({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: viewModel.days.map((day) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: viewModel.timeSlots.map((slot) {
                    final selected = viewModel.isSelected(day, slot);

                    return FilterChip(
                      label: Text(slot),
                      selected: selected,
                      selectedColor: AppColors.primary,
                      onSelected: (_) {
                        viewModel.toggleAvailability(day, slot);
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
