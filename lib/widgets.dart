// ignore_for_file: use_key_in_widget_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tools.dart';

class Widgets extends StatelessWidget {
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

  Widget printImage(String name) {
    return Image.asset(name, fit: BoxFit.contain);
  }

  Widget floatingControlPanel(
    BuildContext context,
    VoidCallback nextPage,
    VoidCallback previousPage,
    VoidCallback homePage,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FloatingActionButton.extended(
          isExtended: false,
          hoverElevation: 20,
          backgroundColor: Colors.black,
          label: const Text("My Portfolio"),
          onPressed: () => launchURL("https://muditgarg48.github.io"),
          icon: const Icon(Icons.language_rounded),
        ),
        FloatingActionButton.extended(
          isExtended: false,
          backgroundColor: Colors.black,
          label: const Text("Previous Page"),
          onPressed: previousPage,
          icon: const Icon(Icons.keyboard_arrow_up_rounded),
        ),
        FloatingActionButton.extended(
          isExtended: false,
          backgroundColor: Colors.black,
          label: const Text("Next Page"),
          onPressed: nextPage,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
        ),
        FloatingActionButton.extended(
          isExtended: false,
          backgroundColor: Colors.black,
          label: const Text("Back to Top"),
          onPressed: homePage,
          icon: const Icon(Icons.home_rounded),
        ),
      ],
    );
  }

  Widget controlPanel(
    BuildContext context,
    VoidCallback nextPage,
    VoidCallback previousPage,
    VoidCallback homePage,
  ) {
    var beExtended = MediaQuery.of(context).size.width > 1400 ? true : false;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(width: MediaQuery.of(context).size.width / 35),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton.extended(
                  hoverElevation: 20,
                  isExtended: beExtended,
                  backgroundColor: Colors.black,
                  label: const Text("My Portfolio"),
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
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton.extended(
                  isExtended: beExtended,
                  backgroundColor: Colors.black,
                  label: const Text("Previous Page"),
                  onPressed: previousPage,
                  icon: const Icon(Icons.keyboard_arrow_up_rounded),
                ),
                FloatingActionButton.extended(
                  isExtended: beExtended,
                  backgroundColor: Colors.black,
                  label: const Text("Back to Top"),
                  onPressed: homePage,
                  icon: const Icon(Icons.home_rounded),
                ),
                FloatingActionButton.extended(
                  isExtended: beExtended,
                  backgroundColor: Colors.black,
                  label: const Text("Next Page"),
                  onPressed: nextPage,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                ),
              ],
            ),
            SizedBox(width: MediaQuery.of(context).size.width / 35),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
