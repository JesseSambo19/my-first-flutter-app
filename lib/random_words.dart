import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _randomWordPairs = <WordPair>[];
  final _savedWordPairs = <WordPair>{};

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, item) {
        if (item.isOdd) {
          return const Divider();
        }

        final index =
            item ~/ 2; // we want this to basically calculate the number of
        // word pairs that are in the listView minus the divider widgets (we don't want the dividers included here)

        if (index >= _randomWordPairs.length) {
          _randomWordPairs.addAll(generateWordPairs().take(10));
        }

        return _buildRow(_randomWordPairs[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _savedWordPairs.contains(pair);
    return ListTile(
      title: Text(pair.asPascalCase, style: const TextStyle(fontSize: 18.0)),
      trailing: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _savedWordPairs.remove(pair);
          } else {
            _savedWordPairs.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      final Iterable<ListTile> tiles = _savedWordPairs.map((WordPair pair) {
        return ListTile(
            title: Text(pair.asPascalCase,
                style: const TextStyle(fontSize: 16.0)));
      });

      final List<Widget> divided =
          ListTile.divideTiles(context: context, tiles: tiles).toList();

      return Scaffold(
          appBar: AppBar(
            title: const Center(child: Text("Saved WordPairs")),
            // backgroundColor: Colors.purple[900],
          ),
          body: ListView(children: divided));
    }));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("WordPair Generator")),
        // backgroundColor: Colors.purple[900],
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: _buildList(),
    );
  }
}
