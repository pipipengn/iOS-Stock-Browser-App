import 'package:flutter/material.dart';
import 'package:hw4b571/search/searchpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../detail/StockDetailPage.dart';
import 'DateTimeContent.dart';

final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
late Future<List<String?>> favorites;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void refreshPage() {
    setState(() {
      favorites = prefs.then((SharedPreferences prefs) {
        List<String> favoriteKeys = prefs.getKeys().toList();
        List<String?> favoriteKeyValue = [];
        for (int i = 0; i < favoriteKeys.length; i++) {
          favoriteKeyValue.add(prefs.getString(favoriteKeys[i]));
        }
        return favoriteKeyValue;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    refreshPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              String selectedSymbol = await showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return StockDetailPage(
                      symbol: selectedSymbol,
                    );
                  },
                ),
              ).then((value) {
                refreshPage();
              });
            },
          ),
        ],
        backgroundColor: Colors.purple,
      ),
      backgroundColor: Colors.black,
      body: HomePageContent(refreshFather: refreshPage),
    );
  }
}

// =========================HomePageContent=======================

class HomePageContent extends StatefulWidget {
  HomePageContent({Key? key, this.refreshFather}) : super(key: key);

  final refreshFather;

  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  void deleteFromSharedPreference(String symbol) {
    prefs.then((SharedPreferences prefs) {
      return prefs.remove(symbol);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const DateTimeContent(),
        FutureBuilder<List<String?>>(
          future: favorites,
          builder:
              (BuildContext context, AsyncSnapshot<List<String?>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data?.length == 0) {
                return Column(
                  children: const [
                    Text(
                      'Empty',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              }

              return Expanded(
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.fromLTRB(13, 6, 18, 6),
                      color: Colors.white,
                      height: 2,
                    );
                  },
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    final item = snapshot.data![index];
                    String symbol = item?.split('|')[0] ?? '';
                    return Dismissible(
                      key: Key(item ?? ''),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        setState(() {
                          snapshot.data?.removeAt(index);
                        });
                        deleteFromSharedPreference(symbol);

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            '$symbol was removed from watchlist',
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          duration: const Duration(seconds: 3),
                          backgroundColor: Colors.white,
                        ));
                      },
                      confirmDismiss: (DismissDirection direction) async {
                        return await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Colors.grey[800],
                              title: const Text(
                                "Delete Confirmation",
                                style: TextStyle(color: Colors.white),
                              ),
                              content: const Text(
                                "Are you sure you want to delete this item?",
                                style: TextStyle(color: Colors.white),
                              ),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      background: Padding(
                        padding: const EdgeInsets.fromLTRB(13, 0, 18, 0),
                        child: Container(
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                          alignment: Alignment.centerRight,
                        ),
                      ),
                      child: FavoriteContent(
                        data: item,
                        refreshGrandFather: widget.refreshFather,
                      ),
                    );
                  },
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }
}

// =========================FavoriteContent=======================

class FavoriteContent extends StatefulWidget {
  FavoriteContent({Key? key, required this.data, this.refreshGrandFather}) : super(key: key);

  String? data;
  final refreshGrandFather;

  @override
  _FavoriteContentState createState() => _FavoriteContentState();
}

class _FavoriteContentState extends State<FavoriteContent> {
  late String symbol;
  late String name;

  @override
  void initState() {
    super.initState();
    List<String>? dataList = widget.data?.split('|');
    symbol = dataList![0];
    name = dataList[1];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return StockDetailPage(
                symbol: symbol,
              );
            },
          ),
        ).then((value) {
          widget.refreshGrandFather();
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Text(
              symbol,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 0, 0, 0),
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
