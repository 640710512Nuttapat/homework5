import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('ร้านกาแฟ'),centerTitle: true,
        ),
        body: Center(
          child: MyHomePage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List _posts = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('https://api.sampleapis.com/coffee/hot'));

    if (response.statusCode == 200) {
      setState(() {
        _posts = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
Widget build(BuildContext context) {
  return ListView.builder(
    itemCount: _posts.length,
    itemBuilder: (context, index) {
      return Card( // Wrapping with Card for better UI
        child: Column(
          children: [
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                 
                    return AlertDialog(
                      title: Text(_posts[index]['title'],textAlign: TextAlign.center,),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image.network(
                            _posts[index]['image'],
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),SizedBox(height: 50,),
                          Text(_posts[index]['description'],style: TextStyle(fontSize: 20)), 
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('CLOSE'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              
              child: Image.network(
                _posts[index]['image'],
                width: 200, 
                height: 200, 
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                _posts[index]['title'],
                style: TextStyle(
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    },
  );
}
}