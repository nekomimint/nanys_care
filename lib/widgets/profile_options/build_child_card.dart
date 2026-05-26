import 'package:flutter/material.dart';
import 'package:nanys_care/models/children_model.dart';

class BuildChildCard extends StatefulWidget {
  final ChildrenModel child;

  const BuildChildCard({super.key, required this.child});

  @override
  State<BuildChildCard> createState() => _BuildChildCard();
}

class _BuildChildCard extends State<BuildChildCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.child.name,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
