import 'package:flutter/material.dart';

import 'package:dartea/dartea.dart';

void main() {
  final program = Program<Model, Message, Null>(
    init,
    update,
    view,
    subscription: null,
  );
  runApp(MyApp(program));
}

class MyApp extends StatelessWidget {
  final Program program;

  MyApp(this.program);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Elm Todo Example',
      theme: ThemeData.dark(),
      home: program.build(),
    );
  }
}

// Model

class Model {
  final String todo;
  final List<String> todos;

  Model(this.todo, this.todos);

  Model copyWith({String todo, List<String> todos}) =>
      Model(todo ?? this.todo, todos ?? this.todos);
}

// update

abstract class Message {}

class AddTodo implements Message {
  final String todo;

  AddTodo(this.todo);
}

class RemoveTodo implements Message {
  final int index;

  RemoveTodo(this.index);
}

class ClearTodos implements Message {}

Upd<Model, Message> init() => Upd(Model("", []));

Upd<Model, Message> update(Message msg, Model model) {
  if (msg is AddTodo) {
    return Upd(model.copyWith(
      todo: msg.todo,
      todos: model.todos..add(msg.todo),
    ));
  } else if (msg is RemoveTodo) {
    return Upd(model.copyWith(
      todos: model.todos..removeAt(msg.index),
    ));
  } else if (msg is ClearTodos) {
    return Upd(model.copyWith(
      todo: "",
      todos: model.todos..clear(),
    ));
  }
  return Upd(model);
}

//view

Widget view(BuildContext context, Dispatch<Message> dispatch, Model model) {
  final TextEditingController controller = TextEditingController();

  return Scaffold(
    appBar: AppBar(
      title: Text('Dartea Todo App'),
    ),
    body: Center(
        child: Column(
      children: <Widget>[
        Center(
            child: TextFormField(
          controller: controller,
        )),
        Row(
          children: <Widget>[
            RaisedButton(
              child: Text("Add Todo"),
              onPressed: () => dispatch(AddTodo(controller.text)),
            ),
            RaisedButton(
              child: Text('Clear Todos'),
              onPressed: () => dispatch(ClearTodos()),
            ),
          ],
        ),
        Flexible(
          child: ListView.builder(
            itemCount: model.todos.length,
            itemBuilder: (context, index) => Center(
                    child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text(model.todos[index]),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => dispatch(RemoveTodo(index)),
                    )
                  ],
                )),
          ),
        )
      ],
    )),
  );
}
