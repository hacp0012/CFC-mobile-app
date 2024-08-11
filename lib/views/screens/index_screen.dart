import 'package:cfc_christ/views/layouts/default_layout.dart';
import 'package:flutter/material.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key});

  static const String routeName = 'index';
  static const String routePath = 'index';

  @override
  createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: const Text("My custom title"),
      child: Center(
        child: ElevatedButton(
          onPressed: () {},
          child: const Text('in layout'),
        ),
      ),
    );
  }
}
