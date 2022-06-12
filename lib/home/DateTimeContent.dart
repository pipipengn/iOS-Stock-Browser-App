import 'package:flutter/material.dart';

class DateTimeContent extends StatefulWidget {
  const DateTimeContent({Key? key}) : super(key: key);

  @override
  _DateContentState createState() => _DateContentState();
}

class _DateContentState extends State<DateTimeContent> {
  late String month;
  late String day;

  void getDateTime() {
    DateTime dateTime = DateTime.now();
    day = dateTime.day.toString();
    var dict = {
      1: 'January',
      2: 'February',
      3: 'March',
      4: 'April',
      5: 'May',
      6: 'June',
      7: 'July',
      8: 'Augest',
      9: 'September',
      10: 'October',
      11: 'November',
      12: 'December',
    };
    month = dict[dateTime.month].toString();
  }

  @override
  void initState() {
    super.initState();
    getDateTime();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 12, 16, 0),
              child: Text(
                'STOCK WATCH',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Text(
                month,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                day,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
        Row(
          children: const [
            Padding(
              padding: EdgeInsets.only(left: 12),
              child: Text(
                'Favorites',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 22,
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(13, 0, 18, 6),
          color: Colors.white,
          height: 2,
        ),
      ],
    );
  }
}