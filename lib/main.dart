import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const Newsapp(),
    );
  }
}

class Newsapp extends StatefulWidget {
  const Newsapp({super.key});
  @override
  State<StatefulWidget> createState() {
    return Newsdata();
  }
}

class Newsdata extends State<Newsapp> {
  String data = "";
  List<dynamic>? newsData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData("sports");
  }

  Future<void> getData(String category) async {
    setState(() {
      isLoading = true;
    });

    http.Response response = await http.get(
        Uri.parse("https://inshortsapi.vercel.app/news?category=$category"));
    if (response.statusCode == 200) {
      setState(() {
        data = response.body;
        newsData = jsonDecode(data)["data"];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      if (kDebugMode) {
        print("Failed to fetch data. Status code: ${response.statusCode}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 12,
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        appBar: AppBar(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Flutter'),
              Text(
                'News',
                style:
                TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          elevation: 0.0,
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            tabs: const [
              Tab(text: 'Top News'),
              Tab(text: 'National'),
              Tab(text: 'Business'),
              Tab(text: 'Sports'),
              Tab(text: 'World'),
              Tab(text: 'Politics'),
              Tab(text: 'Technology'),
              Tab(text: 'Startup'),
              Tab(text: 'Entertainment'),
              Tab(text: 'Miscellaneous'),
              Tab(text: 'Hatke'),
              Tab(text: 'Science'),
            ],
            onTap: (int index) {
              String? category;
              if (index == 0) {
                category = '';
              } else {
                category = [
                  '',
                  'national',
                  'business',
                  'sports',
                  'world',
                  'politics',
                  'technology',
                  'startup',
                  'entertainment',
                  'miscellaneous',
                  'hatke',
                  'science',
                  'Automobile',
                ][index];
              }
              getData(category);
            },
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
          children: List.generate(12, (index) {
            return buildNewsList(newsData);
          }),
        ),
      ),
    );
  }

  Widget buildNewsList(List<dynamic>? newsData) {
    if (newsData == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      itemCount: newsData.length,
      itemBuilder: (BuildContext context,int index) {
        return buildNewsCard(newsData[index]);
      },
    );
  }

  Widget buildNewsCard(dynamic news) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.only(top: 12.0, left: 5, bottom: 6.0, right: 5),
      child: Padding(
        padding: const EdgeInsets.only(top: 0, left: 0, bottom: 12.0, right: 0),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                  ),
                  child: Image.network(
                    news["imageUrl"],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 175,
                    alignment: Alignment.center,
                  ),
                ),
                Positioned(
                  bottom: 8.0,
                  left: 20.0,
                  child: Text(
                    news["author"],
                    style: const TextStyle(
                      color: Color(0xffffffff),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 0.0, top: 0, right: 5.0, bottom: 5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        50.0,
                      ),
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 7.5,
                            top: 3.0,
                            right: 7.5,
                            bottom: 3.0,
                          ),
                          child: Text(
                            news["date"],
                            style: const TextStyle(
                              color: Color(0xff000000),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ListTile(
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              title: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Text(
                  news["title"],
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 0, right: 10.0),
              child: Text(
                news["content"],
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 0, right: 0.0),
                child: Text(
                  news["time"],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

