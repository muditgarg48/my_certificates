// ignore_for_file: invalid_use_of_protected_member
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'tools.dart';
import 'widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Certificates',
      theme: ThemeData(
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: MaterialStateProperty.all(Colors.black),
          trackColor: MaterialStateProperty.all(Colors.black.withOpacity(0.3)),
          interactive: true,
          crossAxisMargin: 10,
          mainAxisMargin: 10,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  late int firstPage;
  late int lastPage;
  PageController pageController = PageController();
  ScrollController pageScroll = ScrollController();
  var certificates = [];
  var opacity = 0.0;

  @override
  void initState() {
    firstPage = 0;
    getCertifications();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    pageScroll.dispose();
    super.dispose();
  }

  void getCertifications() async {
    var data = await getLedger("assets/certificate_ledger.json");
    setState(() {
      certificates = data;
      lastPage = certificates.length;
    });
  }

  Widget printDetails(Map certificate) {
    String title = certificate["title"];
    DateTime issueDate = DateTime.parse(certificate["issue_date"]);
    List issueCompanies = certificate["companies"];
    List companyColors = toColorWidget(certificate["companies_colors"]);
    String certificateID = certificate["certification_id"];
    String category = certificate["category"];
    String verifyLink = certificate["verify_link"];
    List topics = certificate["topics_covered"];
    return Container(
      margin: EdgeInsets.only(right: MediaQuery.of(context).size.width / 20),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
        border: Border.all(color: companyColors[0], width: 3),
        gradient: LinearGradient(
          stops: const [0.95, 0.95],
          colors: [
            Colors.white,
            companyColors[0],
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.title_rounded),
              const SizedBox(width: 10),
              SelectableText(
                title,
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.dashed,
                  color: Colors.transparent,
                  decorationColor: Colors.black,
                  shadows: [Shadow(color: Colors.black, offset: Offset(0, -5))],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: MediaQuery.of(context).size.width / 8),
              const Icon(Icons.calendar_month_rounded),
              const SizedBox(width: 10),
              SelectableText(DateFormat('yMMMMd').format(issueDate)),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < issueCompanies.length; i++)
                Container(
                  margin: const EdgeInsets.all(5),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      primary: companyColors[i],
                      onPrimary: Colors.white,
                    ),
                    child: SelectableText(issueCompanies[i]),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
            child: SelectableText(category),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.numbers),
              const SizedBox(width: 10),
              TextButton(
                child: Text("ID: $certificateID"),
                onPressed: () => launchURL(verifyLink),
              ),
              IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: certificateID));
                  var display =
                      const SnackBar(content: Text("Certificate ID copied"));
                  ScaffoldMessenger.of(context).showSnackBar(display);
                },
                icon: const Icon(Icons.copy_rounded),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.sort),
                  SizedBox(width: 20),
                  Text("Topics Covered:"),
                ],
              ),
              for (var topic in topics) Text("+ $topic")
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: MediaQuery.of(context).size.width / 6),
              TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: const BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
                onPressed: () => setState(() => opacity = 1 - opacity),
                child: Row(
                  children: const [
                    Text("Close"),
                    Icon(Icons.clear),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget printCertificate(Map certificate) {
    var printD = AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
      opacity: opacity,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: printDetails(certificate),
      ),
    );
    var printP = Widgets().printImage("assets/${certificate["file_name"]}");
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Center(
            child: MediaQuery.of(context).size.width < 900
                ? GestureDetector(
                    onTap: () => setState(() => opacity = 1),
                    child: printP,
                  )
                : MouseRegion(
                    onHover: (_) => setState(() => opacity = 1),
                    onExit: (_) => setState(() => opacity = 0),
                    child: printP,
                  ),
          ),
          MediaQuery.of(context).size.width < 900
              ? printD
              : MouseRegion(
                  onEnter: (_) => setState(() => opacity = 1),
                  child: printD,
                ),
        ],
      ),
    );
  }

  Widget theBody() {
    return Card(
      elevation: 20,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width / 15,
        vertical: MediaQuery.of(context).size.height / 15,
      ),
      child: Stack(
        children: [
          Scrollbar(
            controller: pageScroll,
            child: PageView(
              padEnds: true,
              onPageChanged: (_) => setState(() => opacity = 0),
              scrollDirection: Axis.vertical,
              controller: pageController,
              children: [
                Widgets().homeSlide(context),
                for (var certificate in certificates)
                  printCertificate(certificate),
                const Center(child: Text("\"Always keep learning\"")),
              ],
            ),
          ),
          MediaQuery.of(context).size.width > 900
              ? Widgets().controlPanel(
                  context,
                  () => nextPage(pageController, firstPage, lastPage),
                  () => previousPage(pageController, firstPage, lastPage),
                  () => homePage(pageController, firstPage, lastPage),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          "https://source.unsplash.com/random",
          fit: BoxFit.cover,
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: theBody(),
          floatingActionButton: MediaQuery.of(context).size.width < 900
              ? Widgets().floatingControlPanel(
                  context,
                  () => nextPage(pageController, firstPage, lastPage),
                  () => previousPage(pageController, firstPage, lastPage),
                  () => homePage(pageController, firstPage, lastPage),
                )
              : const SizedBox.shrink(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ),
      ],
    );
  }
}
