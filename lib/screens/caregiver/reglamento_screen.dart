import 'package:flutter/material.dart';

class ReglamentoScreen extends StatelessWidget {
  const ReglamentoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reglamento de cuidadores'),
        backgroundColor: const Color(0xFFAC7099),
        foregroundColor: Colors.white,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Seccion(
              titulo: '1. Puntualidad',
              contenido:
                  'El cuidador debe presentarse a tiempo en el domicilio acordado. '
                  'En caso de retraso, debe notificar al tutor con al menos 30 minutos de anticipación.',
            ),
            _Seccion(
              titulo: '2. Trato hacia los niños',
              contenido:
                  'El cuidador debe tratar a los niños con respeto, paciencia y cariño en todo momento. '
                  'Queda estrictamente prohibido cualquier tipo de maltrato físico o verbal.',
            ),
            _Seccion(
              titulo: '3. Comunicación con el tutor',
              contenido:
                  'El cuidador debe mantener al tutor informado sobre cualquier incidente, '
                  'cambio de estado de salud del niño o situación relevante durante el cuidado.',
            ),
            _Seccion(
              titulo: '4. Uso del teléfono',
              contenido:
                  'El uso del teléfono personal debe limitarse a lo estrictamente necesario '
                  'durante las horas de cuidado activo.',
            ),
            _Seccion(
              titulo: '5. Confidencialidad',
              contenido:
                  'La información personal de las familias, sus domicilios y rutinas '
                  'es confidencial y no debe compartirse con terceros.',
            ),
            _Seccion(
              titulo: '6. Cancelaciones',
              contenido:
                  'Las cancelaciones deben notificarse con al menos 24 horas de anticipación. '
                  'Cancelaciones repetidas o de último momento pueden resultar en la suspensión del perfil.',
            ),
            _Seccion(
              titulo: '7. Perfil verídico',
              contenido:
                  'El cuidador se compromete a que toda la información en su perfil '
                  '(experiencia, disponibilidad, tarifas) sea verídica y esté actualizada.',
            ),
          ],
        ),
      ),
    );
  }
}

class _Seccion extends StatelessWidget {
  final String titulo;
  final String contenido;
  const _Seccion({required this.titulo, required this.contenido});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            contenido,
            style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
          ),
        ],
      ),
    );
  }
}