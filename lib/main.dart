// ignore_for_file: invalid_use_of_protected_member
import 'dart:ui';

import 'package:flutter/material.dart';
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
          trackColor: MaterialStateProperty.all(Colors.transparent),
          crossAxisMargin: 10,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    String issueCompany = certificate["company"];
    Color companyColor = Color(int.parse(certificate["company_color"]));
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
        gradient: LinearGradient(
          stops: const [0.95, 0.95],
          colors: [
            Colors.white,
            companyColor,
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
              SizedBox(width: MediaQuery.of(context).size.width / 6),
              TextButton(
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
          const SizedBox(height: 20),
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
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              primary: companyColor,
              onPrimary: Colors.white,
            ),
            child: SelectableText(issueCompany),
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
                  onPressed: () => launchURL(verifyLink)),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
              for (var topic in topics) Text(topic)
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 8),
        ],
      ),
    );
  }

  Widget printCertificates(Map certificate) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Center(
            child: printImage("assets/${certificate["file_name"]}"),
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
            opacity: opacity,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: printDetails(certificate),
            ),
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
              onPageChanged: (_) => setState(() => opacity = 0),
              scrollDirection: Axis.vertical,
              controller: pageController,
              children: [
                homeSlide(context),
                for (var certificate in certificates)
                  printCertificates(certificate),
              ],
            ),
          ),
          controlPanel(
            context,
            () => nextPage(pageController, firstPage, lastPage),
            () => previousPage(pageController, firstPage, lastPage),
            () => homePage(pageController, firstPage, lastPage),
          ),
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
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => setState(() => opacity = 1 - opacity),
            backgroundColor: Colors.transparent.withOpacity(0.2),
            label: Row(
              children: const [
                Icon(Icons.sort),
                Text("Toggle details"),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
