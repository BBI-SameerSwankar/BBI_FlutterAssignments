import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:provider/provider.dart';

import 'package:todo_clean/features/todo/data/models/todo.dart';
import 'package:todo_clean/features/todo/presentation/provider/todo_provider.dart';

class TodoEditForm extends StatefulWidget {
  final Todo todo;

  const TodoEditForm({super.key, required this.todo});

  @override
  _TodoEditFormState createState() => _TodoEditFormState();
}

class _TodoEditFormState extends State<TodoEditForm> {
  final _formKey = GlobalKey<FormState>(); 

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.todo.title;
    _descriptionController.text = widget.todo.description;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final todoProvider = Provider.of<TodoProvider>(context, listen: false);
     final todoProvider = GetIt.I<TodoProvider>();

   
    void _saveTodo() {
      if (_formKey.currentState?.validate() ?? false) {
        final updatedTodo = Todo(
          id: widget.todo.id, 
          title: _titleController.text,
          description: _descriptionController.text,
        );

        todoProvider.updateTodo(updatedTodo);
        Navigator.pop(context); 

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Todo updated successfully!')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Todo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey, 
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Description Field
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

            
                ElevatedButton(
                  onPressed: _saveTodo, 
                  child: const Text("Save Changes"),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
