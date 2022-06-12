import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'DetailContent.dart';

class StockDetailPage extends StatefulWidget {
  StockDetailPage({Key? key, required this.symbol}) : super(key: key);

  String symbol;

  @override
  _StockDetailPageState createState() => _StockDetailPageState();
}

class _StockDetailPageState extends State<StockDetailPage> {
  String name = 'c9jq57qad3idg7p5frm0';

  Future<Map> getDetail(String symbol) async {
    String apiKey = 'c9jq57qad3idg7p5frm0';
    var url = Uri.parse(
        'https://finnhub.io/api/v1/stock/profile2?symbol=$symbol&token=$apiKey');
    var response = await http.get(url);
    if (name == 'c9jq57qad3idg7p5frm0' && response.body != '{}') {
      setState(() {
        name = jsonDecode(response.body)['name'];
      });
    }
    return jsonDecode(response.body);
  }

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<int> isSaved;

  Future<void> _changePreference(String symbol) async {
    final SharedPreferences prefs = await _prefs;
    if (prefs.containsKey(symbol)) {
      setState(() {
        isSaved = prefs.remove(symbol).then((bool success) {
          return -1;
        });
      });
    } else {
      setState(() {
        isSaved =
            prefs.setString(symbol, symbol + '|' + name).then((bool success) {
          return 1;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    isSaved = _prefs.then((SharedPreferences prefs) {
      return prefs.containsKey(widget.symbol) ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('detail'),
        backgroundColor: Colors.grey[900],
        actions: [
          FutureBuilder<int>(
            future: isSaved,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              if (snapshot.hasData) {
                return IconButton(
                  onPressed: () {
                    _changePreference(widget.symbol);

                    String symbol = widget.symbol;
                    String action =
                        snapshot.data == 1 ? 'removed from' : 'added to';

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        '$symbol was $action watchlist',
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      duration: const Duration(seconds: 3),
                      backgroundColor: Colors.white,
                    ));
                  },
                  icon:
                      Icon(snapshot.data == 1 ? Icons.star : Icons.star_border),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<Map>(
        future: getDetail(widget.symbol),
        builder: (context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!['ticker'] == null) {
              return const Center(
                child: Text(
                  'Failed to fetch stock data',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              );
            }
            return DetailContent(
              content: snapshot.data,
              symbol: widget.symbol,
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
