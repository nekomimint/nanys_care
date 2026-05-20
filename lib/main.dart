import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // la vista del login

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Auth Demo',
      theme: ThemeData(
        // Cambiado a light ya que la paleta de la imagen es clara
        brightness: Brightness.light,
        // Fondo rosa muy claro/pastel de la imagen
        scaffoldBackgroundColor: const Color(0xFFFFF2EC),  
        // Color lila/morado principal de los botones y textos destacados
        primaryColor: const Color(0xFFAC7099), 

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          // Fondo blanco para los inputs, común en diseños claros
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            // Borde lila al seleccionar el input
            borderSide: const BorderSide(color: Color(0xFFAC7099), width: 2), 
          ),
          // Texto de etiqueta en gris oscuro para que contraste con el fondo blanco
          labelStyle: const TextStyle(color: Colors.black54),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            // Botón principal con el color lila de la UI
            backgroundColor: const Color(0xFFAC7099),
            // Texto del botón en blanco para buena legibilidad
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}