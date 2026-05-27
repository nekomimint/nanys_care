import 'package:flutter/material.dart';
import '../../../models/children_model.dart';
import '../../../services/children_service.dart';

class EditChildSheet extends StatefulWidget {
  final ChildrenModel child;
  const EditChildSheet({super.key, required this.child});

  @override
  State<EditChildSheet> createState() => _EditChildSheetState();
}

class _EditChildSheetState extends State<EditChildSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _descController;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    // Precarga los valores actuales
    _nameController = TextEditingController(text: widget.child.name);
    _ageController = TextEditingController(text: widget.child.age.toString());
    _descController = TextEditingController(text: widget.child.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameController.text.isEmpty || _ageController.text.isEmpty) return;
    setState(() => _loading = true);

    final updated = ChildrenModel(
      uid: widget.child.uid,
      uidFather: widget.child.uidFather,
      name: _nameController.text.trim(),
      age: int.tryParse(_ageController.text) ?? widget.child.age,
      description: _descController.text.trim(),
      active: true,
    );

    await ChildrenService.updateChild(updated);
    if (mounted) Navigator.of(context).pop(true);
  }

  Future<void> _deactivate() async {
    // Confirmación antes de desactivar
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Desactivar niño'),
        content: Text(
          '¿Desactivar a ${widget.child.name}? '
          'No aparecerá en nuevas citas pero el historial se conserva.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Desactivar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _loading = true);
      await ChildrenService.deactivateChild(widget.child.uid);
      if (mounted) Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Editar niño',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                icon: const Icon(Icons.block, color: Colors.red, size: 16),
                label: const Text(
                  'Desactivar',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: _loading ? null : _deactivate,
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Nombre'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Edad'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descController,
            maxLines: 2,
            decoration: const InputDecoration(labelText: 'Descripción / notas'),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _loading ? null : _save,
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Guardar cambios'),
            ),
          ),
        ],
      ),
    );
  }
}
