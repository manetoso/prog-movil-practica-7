import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:intl/intl.dart';
import 'package:practica_7/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chatbot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.pink,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final messageController = TextEditingController();
  List<Map> messages = [];

  void response(query) async {
    AuthGoogle authGoogle = await AuthGoogle(
      fileJson: 'assets/credential.json'
    ).build();
    Dialogflow dialogFlow = Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse aiResponse = await dialogFlow.detectIntent(query);
    setState(() {
      messages.insert(0, {
        'data': 0,
        'message': aiResponse.getListMessage()[0]['text']['text'][0].toString(),
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emmanuel Chatbot'),
      ),
      // ignore: avoid_unnecessary_containers
      body: Container(
        child: Column(
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.only(top: 15, bottom: 10),
                child: Text(
                  'Today, ${DateFormat("Hm").format(DateTime.now())}',
                  style: const TextStyle(
                    fontSize: 20.0
                  ),
                ),
              ),
            ),

            Flexible(
              child: ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) => chat(
                  messages[index]['message'].toString(),
                  messages[index]['data']
                )),
            ),

            const Divider(
              height: 5,
              color: kPink,
            ),
            Container(
              child: ListTile(
                leading: IconButton(
                  icon: Container(),
                  color: kPink,
                  iconSize: 35,
                  onPressed: (){},
                ),
                title: Container(
                  height: 35,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Color.fromRGBO(220, 220, 220, 1)
                  ),
                  padding: const EdgeInsets.only(left: 15),
                  child: TextFormField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Hello!',
                      hintStyle: TextStyle(
                        color: Colors.black26
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black
                    ),
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.send),
                  iconSize: 30,
                  color: kPink,
                  onPressed: () {
                    if (messageController.text.isEmpty) {
                      print('no message');
                    } else {
                      setState(() {
                        messages.insert(0, {"data": 1, "message": messageController.text});
                      });
                      response(messageController.text);
                      messageController.clear();
                    }
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chat(String message, int data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: data == 1 ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          data == 0
          ? Container(
              height: 60,
              width: 60,
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/robot.png'),
              ),
            )
          : Container(),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Bubble(
              radius: const Radius.circular(15),
              color: data == 0 ? kBlue : kPink,
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 10),
                    Flexible(child: Container(
                      constraints: const BoxConstraints(minWidth: 100, maxWidth: 200),
                      child: Text(
                        message,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ))
                  ],
                ),
              ),
            ),
          ),
          data == 1 ? Container(
              height: 60,
              width: 60,
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/default.png'),
              ),
            ) : Container()
        ],
      ),
    );
  }
}
