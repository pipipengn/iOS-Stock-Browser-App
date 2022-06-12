import 'package:flutter/material.dart';

class PriceContent extends StatelessWidget {
  PriceContent({Key? key, required this.content}) : super(key: key);
  Map? content;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Text(
                content!['c'].toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  content!['d'] >= 0 ? '+' : '',
                  style: TextStyle(
                    color: content!['d'] >= 0 ? Colors.green : Colors.red,
                    fontSize: 25,
                  ),
                ),
              ),
              Text(
                content!['d'].toString(),
                style: TextStyle(
                  color: content!['d'] >= 0 ? Colors.green : Colors.red,
                  fontSize: 25,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 17),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: const [
              Text(
                'Stats',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 14),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Open',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        content!['o'].toString(),
                        style: const TextStyle(
                            color: Colors.white60, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'High',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        content!['h'].toString(),
                        style: const TextStyle(
                            color: Colors.white60, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 14),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Low',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        content!['l'].toString(),
                        style: const TextStyle(
                            color: Colors.white60, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Prev',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        content!['pc'].toString(),
                        style: const TextStyle(
                            color: Colors.white60, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
