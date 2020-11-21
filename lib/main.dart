import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:swipedo/item.dart';

void main() async {
  Hive.registerAdapter(ItemAdapter());
  await Hive.initFlutter();
  await Hive.openBox('items');
  return runApp(MyApp());
}

class _MyAppState extends State<MyApp> {
  TextEditingController addFieldController;
  FocusNode addFieldFocusNode;

  @override
  void initState() {
    super.initState();
    addFieldController = TextEditingController();
    addFieldFocusNode = FocusNode();
  }

  @override
  void dispose() {
    addFieldController.dispose();
    addFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box('items').listenable(),
        builder: (context, box, widget) {
          return MaterialApp(
            title: 'Welcome to Flutter',
            home: Scaffold(
              appBar: AppBar(
                title: Text('Swipedo'),
              ),
              body: Container(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                    Expanded(child: TodoList()),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: addFieldController,
                        focusNode: addFieldFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Add item',
                        ),
                        onSubmitted: (String str) {
                          box.add(Item()..text = str);
                          addFieldController.clear();
                          FocusScope.of(context)
                              .requestFocus(addFieldFocusNode);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  Widget _buildRow(item, box) {
    return Dismissible(
        key: Key(item.uuid),
        onDismissed: (direction) {
          item.delete();
        },
        child: Container(
          child: Text(item.text),
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
          margin: EdgeInsets.symmetric(vertical: 4.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(width: 2, color: Colors.black12),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box('items').listenable(),
        builder: (context, box, widget) {
          return ListView.builder(
              itemCount: box.values.length,
              padding: EdgeInsets.all(16.0),
              itemBuilder: (context, i) {
                var values = box.values.toList();
                values.sort((a, b) =>
                    (b.timestamp as int).compareTo(a.timestamp as int));
                return _buildRow(values[i], box);
              });
        });
  }
}
