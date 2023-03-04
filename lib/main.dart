// ignore_for_file: prefer_final_locals, always_specify_types, duplicate_ignore

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool x = false;
  TextEditingController controller = TextEditingController();
  int input = 0;
  String? errorText;
  static Random ran = Random();
  int randomnr = ran.nextInt(100) + 1;
  String mesaj = '';

  void guess() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    int guess = int.parse(controller.text);
    if (guess > 100 || guess < 1) {
      mesaj = 'Numarul trebuie sa fie mai mare de 1 si mai mic de 100';
      controller.clear();
      return;
    }
    if (guess > randomnr) {
      mesaj = 'Tasteaza mai mici';
    } else if (guess < randomnr) {
      mesaj = 'Tasteaza mai mari';
    } else if (guess == randomnr) {
      mesaj = 'Bravo nr este $randomnr';
      randomnr = ran.nextInt(100) + 1;
    }
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guess Nr'),
        centerTitle: true,
        // ignore: always_specify_types
        actions: [
          Switch(
              value: x,
              onChanged: (bool y) {
                setState(() {
                  x = !x;
                });
              },),
        ],
      ),
      body: Column(
        children: <Widget>[
          Card(
            child: SizedBox(
              width: 4000,
              height: 200,
              child: DecoratedBox(
                decoration: const BoxDecoration(color: Colors.black12),
                child: Column(
                  children: [
                    const Center(
                      child: Text(
                        'Ghiceste Numarul',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                    TextField(
                      controller: controller,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (String value) {
                        setState(() {
                          final int? nr = int.tryParse(value);
                          if (nr == null) {
                            errorText = 'introdu doar nr';
                          } else {
                            errorText = null;
                          }
                        });
                      },
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              controller.clear();
                              input = 0;
                            });
                          },
                        ),
                        labelText: 'Scrie',
                        errorText: errorText,
                      ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(
                      '$input',
                      style: const TextStyle(color: Colors.black, fontSize: 25),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton(
              child: const Text(
                'Apasa',
                style: TextStyle(fontSize: 25),
              ),
              onPressed: () {
                guess();
                // ignore: inference_failure_on_function_invocation
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: const Text('Gresit'),
                          content: Text(mesaj),
                        ),);
              },)
        ],
      ),
    );
  }
}
