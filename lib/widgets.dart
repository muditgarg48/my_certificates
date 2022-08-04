import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tools.dart';

Widget printImage(String name) {
  return Image.asset(name, fit: BoxFit.contain);
}

Widget homeSlide(BuildContext context) {
  var title = Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'My Certificates',
        style: GoogleFonts.shadowsIntoLight(
          fontSize: MediaQuery.of(context).size.shortestSide / 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Designed by ',
            style: GoogleFonts.shadowsIntoLight(
              fontSize: MediaQuery.of(context).size.shortestSide / 30,
            ),
          ),
          Text(
            'Flutter ',
            style: GoogleFonts.shadowsIntoLight(
              fontSize: MediaQuery.of(context).size.shortestSide / 30,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    ],
  );
  return Container(
    color: Colors.transparent,
    child: Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              "https://source.unsplash.com/random",
              fit: BoxFit.cover,
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: title,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget controlPanel(
  BuildContext context,
  VoidCallback nextPage,
  VoidCallback previousPage,
  VoidCallback homePage,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          SizedBox(width: MediaQuery.of(context).size.width / 25),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () => launchURL("https://muditgarg48.github.io"),
                icon: const Icon(Icons.language_rounded),
              ),
            ],
          ),
        ],
      ),
      Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: previousPage,
                icon: const Icon(Icons.keyboard_arrow_up_rounded),
              ),
              IconButton(
                onPressed: homePage,
                icon: const Icon(Icons.home_rounded),
              ),
              IconButton(
                onPressed: nextPage,
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
              ),
            ],
          ),
          SizedBox(width: MediaQuery.of(context).size.width / 25),
        ],
      ),
    ],
  );
}
