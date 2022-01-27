import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget(
      {Key? key,
      required this.whatTextController,
      required this.whereTextController})
      : super(key: key);

  final TextEditingController whereTextController;
  final TextEditingController whatTextController;

  @override
  State<StatefulWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  TextEditingController get whereTextController => widget.whereTextController;

  TextEditingController get whatTextController => widget.whatTextController;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const SizedBox(height: 60.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.search),
                Container(
                  height: 20,
                  width: 200,
                  child: TextField(
                    controller: whatTextController,
                    decoration: const InputDecoration(hintText: 'What?'),
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black54,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const Icon(Icons.settings),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.search),
                Container(
                  width: 200,
                  height: 20,
                  child: TextField(
                    controller: whereTextController,
                    decoration: const InputDecoration(hintText: 'Where?'),
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black54,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const Icon(Icons.settings),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
