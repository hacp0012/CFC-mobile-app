import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/views/layouts/empty_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = 'search';
  static const String routePath = 'search';

  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return EmptyLayout(
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            textInputAction: TextInputAction.go,
            decoration: const InputDecoration().copyWith(
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              suffixIcon: IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.search_circle)),
              hintText: "Chercher ...",
            ),
          ),
          actions: [IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.settings))],
        ),

        // --- Body :
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(CupertinoIcons.search, size: CConstants.GOLDEN_SIZE * 6),
              Text("Résultats", style: Theme.of(context).textTheme.titleMedium)
            ],
          ),
        ),
      ),
    );
  }
}
