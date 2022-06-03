import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/general.dart';
import 'package:flutter_mobile_client/helpers/auth/get_access_token.dart';
import 'package:flutter_mobile_client/models/auth/login.dart';
import 'package:flutter_mobile_client/provider/token.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  void initState() {
    super.initState();
  }

  Future autoAuth(BuildContext context) async {
    var token = await getAccessToken();
    if (token == null) {
      // no value
      print("ERROR!!!");
    } else {
      // working
      Provider.of<TokenModel>(context, listen: false).setAccessToken(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiProvider(
        providers: [ChangeNotifierProvider(create: (context) => TokenModel())],
        child: FutureBuilder(
          future: getAccessToken(), //  _processingData()
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            Widget child;
            if (snapshot.connectionState == ConnectionState.waiting) {
              child = const CupertinoActivityIndicator();
            } else if (!snapshot.hasData || snapshot.hasError) {
              child = const Text("Error");
            } else {
              child = Text("Token: ${context.read<TokenModel>().accessToken}");
            }
            return Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: child,
              ),
            );
          },
        ),
      ),
    );
  }
}


  // void createKey() async {
  //   print("here");
  //   const storage = FlutterSecureStorage();
  //   await storage.write(key: "refreshToken", value: "mytestvalue");
  //   var value = await storage.read(key: "refreshToken");
  //   setState(() {
  //     id = value ?? "FORCED NULL";
  //   });
  // }