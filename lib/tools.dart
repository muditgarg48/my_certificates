import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<dynamic> getLedger(String link) async {
  var file = await rootBundle.loadString(link);
  var data = jsonDecode(file);
  return data;
}

void homePage(PageController pageController, int firstPage, int lastPage) {
  pageController.animateToPage(firstPage,
      duration: const Duration(seconds: 1), curve: Curves.decelerate);
}

void previousPage(PageController pageController, int firstPage, int lastPage) {
  if (pageController.page == firstPage ||
      pageController.page == firstPage + 1) {
    pageController.animateToPage(
      lastPage,
      duration: const Duration(seconds: 1),
      curve: Curves.decelerate,
    );
  } else {
    pageController.previousPage(
      duration: const Duration(seconds: 1),
      curve: Curves.decelerate,
    );
  }
}

void nextPage(PageController pageController, int firstPage, int lastPage) {
  if (pageController.page == lastPage) {
    pageController.animateToPage(
      firstPage + 1,
      duration: const Duration(seconds: 1),
      curve: Curves.decelerate,
    );
  } else {
    pageController.nextPage(
      duration: const Duration(seconds: 1),
      curve: Curves.decelerate,
    );
  }
}
