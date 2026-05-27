import 'package:flutter/material.dart';
import 'package:nanys_care/models/user_model.dart';

class OptionProfile extends StatefulWidget {
  final UserModel user;
  final VoidCallback onTap;
  final String titleButton;
  final IconData icon;
  final Color? color;
  final Color? backgroundColor;
  const OptionProfile({
    super.key,
    required this.user,
    required this.titleButton,
    required this.onTap,
    required this.icon,
    this.color,
    this.backgroundColor,
  });

  @override
  State<OptionProfile> createState() => _OptionProfile();
}

class _OptionProfile extends State<OptionProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        tileColor: Colors.transparent,
        leading: Icon(widget.icon, color: widget.color ?? Colors.black54),
        title: Text(
          widget.titleButton,

          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: widget.color ?? Colors.black54,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: widget.color ?? Colors.black54,
        ),
        onTap: widget.onTap,
      ),
    );
  }
}
