import 'package:flutter/material.dart';

class CalificarDialog {
  static void mostrar(BuildContext context, String nombreNinera) {
    // Colores basados en tu línea de diseño
    const primaryRed = Color(0xFFC93B3B); // El color del botón "Calificar"
    const inputBgColor = Color(0xFFF3F8F7); // Fondo menta muy claro para el textfield

    int estrellasSeleccionadas = 0;
    final TextEditingController comentarioController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24), // Bordes muy redondeados como tus tarjetas
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Hace que el diálogo se ajuste al contenido
              children: [
                // 1. TÍTULO PRINCIPAL
                Text(
                  'Calificar a',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  nombreNinera,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),

                // 2. FILA DE 5 ESTRELLAS INTERACTIVAS
                // Usamos StatefulBuilder para que solo muten las estrellas al hacer click
                StatefulBuilder(
                  builder: (context, setStateBuilder) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () {
                            setStateBuilder(() {
                              estrellasSeleccionadas = index + 1;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Icon(
                              index < estrellasSeleccionadas
                                  ? Icons.star
                                  : Icons.star_border,
                              color: index < estrellasSeleccionadas
                                  ? Colors.amber
                                  : Colors.grey.shade400,
                              size: 36, // Tamaño cómodo para tocar con el dedo
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // 3. CAJA DE TEXTO (TEXTFIELD) PARA COMENTARIO
                TextField(
                  controller: comentarioController,
                  maxLines: 4, // Permite escribir un párrafo cómodo de 4 líneas
                  decoration: InputDecoration(
                    hintText: 'Escribe un comentario sobre el servicio...',
                    hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                    fillColor: inputBgColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none, // Quita el borde tosco por defecto
                    ),
                    contentPadding: const EdgeInsets.all(14),
                  ),
                ),
                const SizedBox(height: 24),

                // 4. BOTÓN CÁPSULA "ENVIAR"
                SizedBox(
                  width: double.infinity, // Ocupa todo el ancho disponible del diálogo
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryRed,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14), // Estilo píldora/cápsula
                      ),
                    ),
                    onPressed: () {
                      // Aquí obtienes los datos listos para tu backend:
                      final nota = estrellasSeleccionadas;
                      final comentario = comentarioController.text;

                      print('Estrellas: $nota, Comentario: $comentario');

                      // Cierra la ventana emergente
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Enviar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}