import 'package:flutter/material.dart';

Widget chapterCourse(String courseName, String instructorName, String imageURL) {
  return Container(
    width: 350,
    height: 80,
    decoration: BoxDecoration(
      color: Color(0xFFFEF7FF),

      border: Border(
        left: BorderSide(width: 1, color: Color(0xFFCAC4D0)),
        right: BorderSide(width: 1, color: Color(0xFFCAC4D0)),
        top: BorderSide(width: 1, color: Color(0xFFCAC4D0)),
        bottom: BorderSide(width: 1, color: Color(0xFFCAC4D0)),
      ),
    ),

    child: Row(
      children: [
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imageURL),
              fit: BoxFit.fitHeight, // Adjusted fit
              //alignment: Alignment.topCenter,
            ),
          ),
        ),
        Expanded( // Added Expanded widget to take remaining width
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  courseName,
                  style: TextStyle(
                    color: Color(0xFF1D1B20),
                    fontSize: 20,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                    letterSpacing: 0.15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  instructorName,
                  style: TextStyle(
                    color: Color(0xFF1D1B20),
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                    letterSpacing: 0.25,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
