import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:spell_checker_in_chat_app/message_class.dart';
import 'package:string_similarity/string_similarity.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Chat App'),
        ),
        body: const ChatScreen(),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> messages = [
    Message(
        text: 'Hello',
        date: DateTime.now().subtract(const Duration(minutes: 1)),
        isSentByMe: false),
    Message(
        text: 'World',
        date: DateTime.now().subtract(const Duration(minutes: 1)),
        isSentByMe: true),
    Message(
        text: 'Helloooo',
        date: DateTime.now().subtract(const Duration(minutes: 1)),
        isSentByMe: false),
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GroupedListView<Message, DateTime>(
            elements: messages,
            groupBy: (message) => DateTime(2023),
            groupSeparatorBuilder: (message) => const SizedBox(),
            itemBuilder: (context, message) => Align(
              alignment: message.isSentByMe
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Card(
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(message.text),
                ),
              ),
            ),
            reverse: true,
            order: GroupedListOrder.DESC,
          ),
        ),
        Container(
          color: Colors.grey[300],
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Type a message',
              contentPadding: EdgeInsets.all(10),
              border: InputBorder.none,
            ),
            onSubmitted: (text) {
              setState(() {
                messages.add(Message(
                    text: spellCheck(text),
                    date: DateTime.now(),
                    isSentByMe: true));
              });
            },
          ),
        ),
      ],
    );
  }
}

List<String> dictionary = ["hello", "world"];

String spellCheck(String input) {
  late String closestWord;
  double closestDistance = double.maxFinite;
  for (var word in dictionary) {
    final distance = StringSimilarity.compareTwoStrings(input, word);
    if (distance < closestDistance) {
      closestDistance = distance;
      closestWord = word;
    }
  }

  return closestWord;
}
