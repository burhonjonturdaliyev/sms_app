import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late TextEditingController _controllerPeople, _controllerMessage;
  String? _message, body;
  String _canSendSMSMessage = 'Check is not run.';
  List<String> people = [
    // "+998885811055",
    // "+998916038300",
    // "+998972330708",
    // "+998905261063",
    // "+998902181522",
    // "+998936310130",
    // "+998914751115",
    // "+998916068480",
    // "+998905451006",
    // "+998916042922",
    // "+998914777027",
    // "+998911737037",
    // "+998979914443",
    // "+998934280418",
    // "+998905470078",
    // "+998914823809",
    // "+998905487018",
    // "+998914911831",
    // "+998916045318",
    // "+998993031117",
    // "+998937810101",
    // "+998979982161",
    // "+998916077170",
    // "+998907630555",
    // "+998916200059",
    // "+998902201215",
    // "+998979973888",
    // "+998914857100",
    // "+998999097474",
    // "+998902569425",
    // "+998902164034",
    // "+998914806675",
    // "+998905255447",
    // "+998902101299",
    // "+998916092764",
    // "+998902166688",
    // "+998914837678",
    // "+998999300554",
    // "+998999140238",
    // "+998902112717",
    // "+998888370705",
    // "+998999041110",
    // "+998979999007",
    // "+998934100047",
    // "+998902544468",
    // "+998901458884"
  ];
  bool sendDirect = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    _controllerPeople = TextEditingController();
    _controllerMessage = TextEditingController();
  }

  Future<void> _sendSMS(List<String> recipients) async {
    try {
      String result = await sendSMS(
        message: _controllerMessage.text,
        recipients: recipients,
        sendDirect: sendDirect,
      );
      setState(() => _message = result);
    } catch (error) {
      setState(() => _message = error.toString());
    }
  }

  Future<bool> _canSendSMS() async {
    bool result = await canSendSMS();
    setState(() => _canSendSMSMessage =
        result ? 'This unit can send SMS' : 'This unit cannot send SMS');
    return result;
  }

  Widget _phoneTile(String name) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Container(
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(color: Colors.grey.shade300),
            top: BorderSide(color: Colors.grey.shade300),
            left: BorderSide(color: Colors.grey.shade300),
            right: BorderSide(color: Colors.grey.shade300),
          )),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(() => people.remove(name)),
                ),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Text(
                    name,
                    style: const TextStyle(fontSize: 12),
                  ),
                )
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SMS/MMS Example'),
        ),
        body: ListView(
          children: <Widget>[
            if (people.isEmpty)
              const SizedBox(height: 0)
            else
              SizedBox(
                height: 90,
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List<Widget>.generate(people.length, (int index) {
                      return _phoneTile(people[index]);
                    }),
                  ),
                ),
              ),
            ListTile(
              leading: const Icon(Icons.people),
              title: TextField(
                controller: _controllerPeople,
                decoration:
                    const InputDecoration(labelText: 'Add Phone Number'),
                keyboardType: TextInputType.number,
                onChanged: (String value) => setState(() {}),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.add),
                onPressed: _controllerPeople.text.isEmpty
                    ? null
                    : () => setState(() {
                          people.add(_controllerPeople.text.toString());
                          _controllerPeople.clear();
                        }),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.message),
              title: TextField(
                decoration: const InputDecoration(labelText: 'Add Message'),
                controller: _controllerMessage,
                onChanged: (String value) => setState(() {}),
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Can send SMS'),
              subtitle: Text(_canSendSMSMessage),
              trailing: IconButton(
                padding: const EdgeInsets.symmetric(vertical: 16),
                icon: const Icon(Icons.check),
                onPressed: () {
                  _canSendSMS();
                },
              ),
            ),
            SwitchListTile(
                title: const Text('Send Direct'),
                subtitle: const Text(
                    'Should we skip the additional dialog? (Android only)'),
                value: sendDirect,
                onChanged: (bool newValue) {
                  setState(() {
                    sendDirect = newValue;
                  });
                }),
            Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith(
                      (states) => Theme.of(context).colorScheme.secondary),
                  padding: WidgetStateProperty.resolveWith(
                      (states) => const EdgeInsets.symmetric(vertical: 16)),
                ),
                onPressed: () {
                  _send();
                },
                child: Text(
                  'SEND',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
            ),
            Visibility(
              visible: _message != null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        _message ?? 'No Data',
                        maxLines: null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _send() {
    if (people.isEmpty) {
      setState(() => _message = 'At Least 1 Person or Message Required');
    } else {
      _sendSMS(people);
    }
  }
}
