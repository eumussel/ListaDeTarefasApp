import 'package:flutter/material.dart';

void main() {
  runApp(ListaDeTarefasApp());
}

class ListaDeTarefasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> _tasks = [
    Task(title: 'Estudar DART/Flutter.'),
    Task(title: 'Desenvolver três aplicações diferentes.'),
    Task(title: 'Publicar no GitHub e enviar para o Elias.'),
    Task(title: 'Torcer para não ser reprovado!'),
  ];

  TextEditingController _taskController = TextEditingController();
  bool _isEditing = false;
  int _editingIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Text(
              'Lista de Tarefas',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Row(
              children: [
                Checkbox(
                  value: _tasks[index].isCompleted,
                  onChanged: (value) {
                    setState(() {
                      _tasks[index].isCompleted = value!;
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    _tasks[index].title,
                    style: TextStyle(
                      decoration: _tasks[index].isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: _tasks[index].isCompleted
                          ? Colors.grey[400]
                          : Colors.black,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _tasks.removeAt(index);
                    });
                  },
                ),
              ],
            ),
            onTap: () {
              setState(() {
                _taskController.text = _tasks[index].title;
                _isEditing = true;
                _editingIndex = index;
              });
              _showEditTaskDialog();
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _isEditing = false;
          _taskController.clear();
          _showEditTaskDialog();
        },
        backgroundColor:
            Colors.green[900]!, // Cor de fundo do botão de adicionar tarefa
        child: Icon(Icons.add,
            color: Colors.white), // Cor do ícone de adicionar tarefa
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black, // Cor de fundo do rodapé
        child: Container(
          height: 50.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Desenvolvido por Vinícius Mussel',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 4),
              Text(
                'Treinamento de DART/Flutter com o Prof. Elias Santos.',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12), // Tamanho do texto ajustado para 12
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditTaskDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_isEditing ? 'Editar Tarefa:' : 'Adicionar Tarefa:'),
          content: TextField(
            controller: _taskController,
            onChanged: (value) {
              _taskController.value = _taskController.value.copyWith(
                text: value,
                selection: TextSelection.collapsed(offset: value.length),
              );
            },
            decoration: InputDecoration(
              hintText: 'Digite o título da tarefa.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (_isEditing) {
                    _tasks[_editingIndex].title = _taskController.text;
                  } else {
                    _tasks.add(Task(title: _taskController.text));
                  }
                  _taskController.clear();
                });
                Navigator.pop(context);
              },
              child: Text(
                _isEditing ? 'Salvar' : 'Adicionar',
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.green[900]!),
              ),
            ),
          ],
        );
      },
    );
  }
}

class Task {
  String title;
  bool isCompleted;

  Task({required this.title, this.isCompleted = false});
}
