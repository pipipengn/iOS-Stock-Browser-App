import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CustomSearchDelegate extends SearchDelegate {
  bool flag = true;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query != '') {
            query = '';
            return;
          }
          close(context, null);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query == '') {
      return const Center();
    }
    return FutureBuilder<List>(
      future: getData(query),
      builder: (context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(snapshot.data![index]),
              onTap: () {
                query = snapshot.data![index];
                close(context, query.split('|')[0].trim());
              },
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.purple[300],
            ),
          );
        }
      },
    );
  }

  Future<List> getData(String name) async {
    String apiKey = 'c9jq57qad3idg7p5frm0';
    var url =
        Uri.parse('https://finnhub.io/api/v1/search?q=$name&token=$apiKey');
    var response = await http.get(url);
    List suggestionResult = jsonDecode(response.body)['result'];

    List<String> result = [];

    for (int i = 0; i < suggestionResult.length; i++) {
      result.add(suggestionResult[i]['symbol'] +
          ' | ' +
          suggestionResult[i]['description']);
    }

    return result;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query == '') {
      return const Center(
        child: Text(
          'No suggestions found!',
          style: TextStyle(fontSize: 27),
        ),
      );
    }

    return FutureBuilder<List>(
      future: getData(query),
      builder: (context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(snapshot.data![index]),
              onTap: () {
                query = snapshot.data![index];
                close(context, query.split('|')[0].trim());
              },
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.purple[300],
            ),
          );
        }
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor:Colors.black,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        iconTheme: theme.primaryIconTheme.copyWith(
          color: Colors.grey,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white60),
        border: InputBorder.none,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.purple,
      ),
    );
  }
}


