import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'details.dart';
import 'newdata.dart';
import 'package:intl/intl.dart'; // Pastikan untuk mengimpor paket ini

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List> getData() async {
    var url = Uri.parse('http://192.168.18.5/restapi2/list.php'); //Api Link
    final response = await http.post(url);
    return jsonDecode(response.body);
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Data Karyawan"),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(
                  context, 'login'); // kembali ke halaman login
            },
          ),
        ],
      ),
      drawer: buildDrawer(context), // Tambahkan Drawer di sini
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => NewData(),
          ),
        ),
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List>(
        future: getData(),
        builder: (ctx, ss) {
          if (ss.hasError) {
            print("error");
          }
          if (ss.hasData) {
            return Items(list: ss.data!);
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Center(
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          ListTile(
            title: Text('Menu 1'),
            onTap: () {
              // Implementasi logika untuk menu 1
            },
          ),
          ListTile(
            title: Text('Menu 2'),
            onTap: () {
              // Implementasi logika untuk menu 2
            },
          ),
          // Tambahkan menu lain sesuai kebutuhan
        ],
      ),
    );
  }
}

class Items extends StatelessWidget {
  final List list;
  Items({Key? key, required this.list}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (ctx, i) {
        return ListTile(
          leading: const Icon(Icons.text_snippet_outlined),
          title: Text(list[i]['nama']),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(list[i]['alamat']),
              Text(
                NumberFormat.currency(
                  locale: 'id_ID',
                  symbol: 'Rp',
                  decimalDigits: 0,
                ).format(double.parse(list[i]['salary'])),
              ),
            ],
          ),
          trailing: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    Details(list: list, index: i),
              ));
            },
            child: Text("Details"),
          ),
        );
      },
    );
  }
}
