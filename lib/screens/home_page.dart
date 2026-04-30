import 'package:flutter/material.dart';
import '../widgets/chat_bubble.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController input = TextEditingController();
  final List<Map<String, String>> messages = [];

  String botResponse(String msg) {
    msg = msg.toLowerCase();

    if (msg.contains("hola")) return "Hola 👋 ¿Qué deseas?";
    if (msg.contains("menu")) return "🍕 Pizza\n🍔 Hamburguesa\n🌭 Perro caliente";
    if (msg.contains("pizza")) return "🍕 Pizza desde $20.000";
    if (msg.contains("hamburguesa")) return "🍔 Hamburguesa desde $12.000";

    return "No entendí 😅";
  }

  void send() {
    final text = input.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({"type": "user", "text": text});
    });

    input.clear();

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        messages.add({
          "type": "bot",
          "text": botResponse(text),
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("FoodBot 🤖")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (_, i) {
                final msg = messages[i];
                return ChatBubble(
                  text: msg["text"]!,
                  isUser: msg["type"] == "user",
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: input,
                    decoration: const InputDecoration(
                      hintText: "Escribe...",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: send,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}