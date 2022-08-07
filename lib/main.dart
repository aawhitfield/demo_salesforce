import 'dart:convert';

import 'package:demo_salesforce/sales_force_api.dart';
import 'package:demo_salesforce/sales_force_contact.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? accessToken;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: (accessToken == null)
              ? WebView(
                  initialUrl:
                      'https://login.salesforce.com/services/oauth2/authorize?response_type=code&client_id=3MVG9riCAn8HHkYUeNXLeHjXdlT_o2_oQovOEmRcJqrMBmJ3SCwAhOiRbi1JuZNB5v5OGqpGko2wLr7scZtq9&redirect_uri=https://www.mywebserver.com',
                  javascriptMode: JavascriptMode.unrestricted,
                  navigationDelegate: (NavigationRequest request) async {
                    if (request.url.startsWith('https://www.mywebserver.com')) {
                      print('blocking navigation to $request');
                      var url = Uri.parse(request.url);
                      String? code = url.queryParameters["code"];
                      print('code: $code');
                      if (code != null) {
                        final response = await http.post(Uri.parse(
                            'https://login.salesforce.com/services/oauth2/token?grant_type=authorization_code&redirect_uri=https://www.mywebserver.com&client_id=3MVG9riCAn8HHkYUeNXLeHjXdlT_o2_oQovOEmRcJqrMBmJ3SCwAhOiRbi1JuZNB5v5OGqpGko2wLr7scZtq9&client_secret=08AEF67ACB13EDBF21B045286050B267936B04CE9E69DF753F686A61E487817B&code=$code'));

                        Map<String, dynamic> data = json.decode(response.body);
                        if (data.containsKey('access_token')) {
                          setState(() {
                            accessToken = data['access_token'];
                          });
                        }
                      }
                      return NavigationDecision.prevent;
                    } else {
                      print('allowing navigation to $request');
                      return NavigationDecision.navigate;
                    }
                  },
                )
              : FutureBuilder<List<SalesForceContact>>(
                  future: SalesForceAPI.getContacts(accessToken!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(height: 8),
                          Text('Downloading Salesforce Contacts...')
                        ],
                      );
                    }
                    else {
                      if(!snapshot.hasData) {
                        return const Text('No Contacts Found');
                      }
                      else {
                        List<SalesForceContact> contacts = List.from(snapshot.data!);
                        return ListView.builder(
                            itemCount: contacts.length,
                            itemBuilder: (context, index) {
                              SalesForceContact contact = snapshot.data![index];
                              String name = '${contact.firstName} ${contact.lastName}';
                              String address = '${contact.mailingStreet}\n${contact.mailingCity}, ${contact.mailingState} ${contact.mailingPostalCode}';
                              return ListTile(
                                title: Text(name),
                                subtitle: Text(address),
                              );
                            });
                      }
                    }
                  }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
