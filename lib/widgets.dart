import 'package:flutter/material.dart';
import 'tools.dart';

Widget printImage(String name) {
  return Image.asset(name, fit: BoxFit.contain);
}

Widget homeSlide(BuildContext context) {
  return Container(
    color: Colors.transparent,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'You have a counter status:',
          ),
          Text(
            'Counter Disabled',
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
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
