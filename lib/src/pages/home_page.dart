import 'package:chatgpt/src/pages/chat_page.dart';
import 'package:chatgpt/src/pages/dalle_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Open Ai',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: Column(
        children: [
          buttonWidget('Dalle By OpenAi', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DallePage(),
              ),
            );
          }),
          buttonWidget('Chat GPT By OpenAi', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChatPage(),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget buttonWidget(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey.shade400,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 40,
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        child: Center(
          child: Text(
            text,
          ),
        ),
      ),
    );
  }
}
