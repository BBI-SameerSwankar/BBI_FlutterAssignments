import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'package:todo_clean/features/todo/presentation/provider/todo_provider.dart';

class TodoInsertForm extends StatefulWidget {
  const TodoInsertForm({super.key});

  @override
  State<TodoInsertForm> createState() => _TodoInsertFormState();
}

class _TodoInsertFormState extends State<TodoInsertForm> {
  final _formKey = GlobalKey<FormState>();

  String _title = "";
  String _description = "";

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descpController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    // final todoProvider = Provider.of<TodoProvider>(context, listen: true);
     final todoProvider = GetIt.I<TodoProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
   
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
          
                TextFormField(
                  controller: _titleController,
                  onChanged: (value) {
                    setState(() {
                      _title = value;
                    });
                  },
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
                  controller: _descpController,
                  onChanged: (value) {
                    setState(() {
                      _description = value;
                    });
                  },
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

                // Submit Button
                ElevatedButton(
                  onPressed: () {
                  
                    if (_formKey.currentState?.validate() ?? false) {

                      todoProvider.addTodo(_title, _description);

                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Submitting Todo')),
                      );
                    }
                  },
                  child: const Text("Submit"),
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
