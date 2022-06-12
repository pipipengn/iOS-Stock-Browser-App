import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'PriceContent.dart';

class DetailContent extends StatelessWidget {
  DetailContent({Key? key, required this.content, required this.symbol})
      : super(key: key);
  Map? content;
  String symbol;

  Future<Map> getPrice(String symbol) async {
    String apiKey = 'c9jq57qad3idg7p5frm0';
    var url = Uri.parse(
        'https://finnhub.io/api/v1/quote?symbol=$symbol&token=$apiKey');
    var response = await http.get(url);
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 17),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Text(
                content!['ticker'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18),
                child: Text(
                  content!['name'],
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 25,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 17),
        FutureBuilder(
          future: getPrice(symbol),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data['error'] !=
                  "You don't have access to this resource.") {
                return PriceContent(content: snapshot.data);
              }
              Map<String, int> hashMap = {
                'c': 0, 'd': 0, 'o': 0, 'h': 0, 'l': 0, 'pc': 0,
              };

              return PriceContent(content: hashMap);
            } else {
              return Container();
            }
          },
        ),
        const SizedBox(height: 17),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: const [
              Text(
                'About',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Start date',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  content!['ipo'],
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Industry',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  content!['finnhubIndustry'],
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Website',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: InkWell(
                  child: Text(
                    content!['weburl'],
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                    ),
                  ),
                  onTap: () {
                    final Uri _url = Uri.parse(content!['weburl']);
                    void _launchUrl() async {
                      if (!await launchUrl(_url)) {
                        throw 'Could not launch $_url';
                      }
                    }

                    _launchUrl();
                  },
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Exchange',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  content!['exchange'],
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Market Cap',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  content!['marketCapitalization'].toString(),
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
