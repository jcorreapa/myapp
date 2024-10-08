import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'presentation/create_post.dart';
import 'presentation/publicaciones_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const PrimerWidget(
          titulo: 'Primer Widget',
        ),
      ),
    );
  }
}

class PrimerWidget extends StatefulWidget {
  final String titulo;

  const PrimerWidget({super.key, required this.titulo});

  @override
  State<PrimerWidget> createState() => _PrimerWidgetState();
}

// ignore: must_be_immutable
class _PrimerWidgetState extends State<PrimerWidget> {
  int variable = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const PublicacionesListPage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreatePost(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
