import 'package:flutter/material.dart';

class ReglamentoScreen extends StatelessWidget {
  const ReglamentoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Normas')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Text(
          'Aquí van las normas...', // ← tu compañero pone el contenido
        ),
      ),
    );
  }
}
