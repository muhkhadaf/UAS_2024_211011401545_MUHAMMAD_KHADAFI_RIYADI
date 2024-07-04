import 'package:crypto_prices/service/data_service.dart';
import 'package:flutter/material.dart';
import 'package:crypto_prices/models/crypto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'cubit/crypto_cubit.dart';

void main() {
  runApp(
      MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: BlocProvider<CryptoCubit>(
            create: (context) => CryptoCubit()..getCrypto(), child: HomePage())
      )
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Crypto> _cryptoList = <Crypto>[];
  final service = DataService();

  @override
  void initState()  {
    super.initState();
    getCrypto();
  }

  void getCrypto() async {
    _cryptoList = await service.fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("UAS MUHAMMAD KHADAFI RIYADI-21101141545"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              getCrypto();
              context.read<CryptoCubit>().getCrypto();
            },
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Harga Crypto Hari ini",
                    style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      print("Sort");
                    },
                    icon: Icon(Icons.sort, size: 18, color: Colors.black,),
                    label: Text(
                      "",
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<CryptoCubit, List<Crypto>>(
                builder: (context, snapshot) {
                  if (snapshot.isNotEmpty) {
                    return ListView.builder(
                        itemCount: snapshot.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListTile(
                                subtitle: Text(
                                  "Last updated: ${snapshot.elementAt(index).lastUpdated}",
                                  style: TextStyle(fontSize: 12),
                                ),
                                leading: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Image(
                                      alignment: Alignment.center,
                                      height: 30,
                                      width: 30,
                                      image: NetworkImage(snapshot.elementAt(index).image!),
                                    ),
                                  ),
                                ),
                                trailing: Text(
                                  "\$${snapshot.elementAt(index).currentPrice}",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                title: Text(
                                  "${snapshot.elementAt(index).name}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17
                                  ),
                                )
                              ),
                            ),
                          );
                        }
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Trends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
