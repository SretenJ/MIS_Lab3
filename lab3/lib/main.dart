import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lab3/models/ispit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '191279 Lab3',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Lab3'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _ime = TextEditingController();
  final TextEditingController _date = TextEditingController();
  final TextEditingController _vreme = TextEditingController();

  final List<Ispit> _ispiti = [
    Ispit(
        ime: "Mobilni Platformi i Programiranje",
        datum: DateTime.now(),
        vreme: TimeOfDay.now()),
    Ispit(
        ime: "Mobilni Informaciski Sistemi",
        datum: DateTime.now(),
        vreme: TimeOfDay.now()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _createAppBar(),
      body: _createBody(),
    );
  }

  PreferredSizeWidget _createAppBar() {
    return AppBar(
        // The title text which will be shown on the action bar
        title: const Text("Lab3"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _addItemFunction(context),
          )
        ]);
  }

  void _addListItemFunction(Ispit toAdd) {
    setState(() {
      _ispiti.add(toAdd);
    });
  }

  void _deleteItem(String ime) {
    setState(() {
      _ispiti.removeWhere((elem) => elem.ime == ime);
    });
  }

  Widget _createBody() {
    return Center(
      child: _ispiti.isEmpty
          ? const Text("Empty List")
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 10,
                  ),
                  child: ListTile(
                    title: Text(_ispiti[index].ime,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    // ignore: prefer_interpolation_to_compose_strings
                    subtitle: Text(
                        DateFormat.yMMMEd().format(_ispiti[index].datum) +
                            ' ' +
                            _ispiti[index].vreme.format(context)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteItem(_ispiti[index].ime),
                    ),
                  ),
                );
              },
              itemCount: _ispiti.length,
            ),
    );
  }

  void _addItemFunction(BuildContext ct) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _ime,
                      decoration: const InputDecoration(
                        labelText: "Ime na ispit",
                        icon: Icon(Icons.add_card),
                      ),
                    ),
                    TextField(
                      controller: _date,
                      decoration: const InputDecoration(
                        labelText: "Datum na ispit",
                        icon: Icon(Icons.calendar_today_rounded),
                      ),
                      onTap: () async {
                        DateTime? pickeddate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100));

                        if (pickeddate != null) {
                          setState(() {
                            _date.text =
                                DateFormat("yyyy-MM-dd").format(pickeddate);
                          });
                        }
                      },
                    ),
                    TextField(
                      controller: _vreme,
                      decoration: const InputDecoration(
                        labelText: "Vreme na ispit",
                        icon: Icon(Icons.lock_clock),
                      ),
                      onTap: () async {
                        TimeOfDay? pickedtime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                          initialEntryMode: TimePickerEntryMode.dial,
                        );

                        if (pickedtime != null) {
                          setState(() {
                            _vreme.text = pickedtime.format(context);
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Otkazi")),
              ElevatedButton(
                  child: const Text("Dodadi termin"),
                  onPressed: () {
                    final format = DateFormat.Hm();
                    print(_vreme.text);
                    _addListItemFunction(Ispit(
                        ime: _ime.text,
                        datum: DateTime.parse(_date.text),
                        vreme:
                            TimeOfDay.fromDateTime(format.parse(_vreme.text))));
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }
}
