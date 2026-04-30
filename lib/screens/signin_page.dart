import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home_page.dart';
import 'register_page.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final email = TextEditingController();
  final password = TextEditingController();

  bool loading = false;
  bool obscure = true;

  Future<void> login() async {
    if (email.text.isEmpty || password.text.isEmpty) return;

    setState(() => loading = true);

    try {
      final res = await http.post(
        Uri.parse("http://10.0.2.2:3000/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email.text.trim(),
          "password": password.text.trim(),
        }),
      );

      if (res.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Credenciales incorrectas")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error de conexión")),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("FoodBot IA 🤖",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),

              TextField(
                controller: email,
                decoration: const InputDecoration(hintText: "Email"),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: password,
                obscureText: obscure,
                decoration: InputDecoration(
                  hintText: "Contraseña",
                  suffixIcon: IconButton(
                    icon: Icon(obscure
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() => obscure = !obscure);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: loading ? null : login,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Iniciar sesión"),
              ),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const RegisterPage()),
                  );
                },
                child: const Text("Crear cuenta"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}