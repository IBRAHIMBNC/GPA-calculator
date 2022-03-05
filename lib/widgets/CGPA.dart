import 'package:flutter/material.dart';

class CGPA extends StatelessWidget {
  final double gpa;
  const CGPA({Key? key, required this.gpa}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.deepOrange.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.only(top: 10),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('CGPA',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          SizedBox(
            width: 30,
          ),
          Text(gpa.toStringAsFixed(2),
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white))
        ],
      ),
    );
  }
}
