import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CupertinoNav extends StatelessWidget {
  const CupertinoNav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: Colors.blue,
        activeColor: Colors.white,
        inactiveColor: Colors.lightBlueAccent,
        onTap: (index) {
          HapticFeedback.lightImpact();
          print("index: $index");
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.compass)),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.flame)),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.add)),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.search)),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.profile_circled)),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (context) => Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        color: Colors.redAccent,
                        height: MediaQuery.of(context).size.height * 0.7,
                        width: 100,
                      ),
                      const Text("tab 1"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              CupertinoPageRoute(builder: (context) => const DummyScreen()));
                        },
                        child: const Text("go to dummy"),
                      ),
                    ],
                  ),
                ),
              ),
            );
          case 1:
            return CupertinoTabView(
              builder: (context) => const Scaffold(
                body: Center(
                  child: Text("tab 2"),
                ),
              ),
            );
          case 2:
            return CupertinoTabView(
              builder: (context) => const Scaffold(
                body: Center(
                  child: Text("tab 3"),
                ),
              ),
            );
          case 3:
            return CupertinoTabView(
              builder: (context) => const Scaffold(
                body: Center(
                  child: Text("tab 4"),
                ),
              ),
            );
          case 4:
          default:
            return CupertinoTabView(
              builder: (context) => const Scaffold(
                body: Center(
                  child: Text("tab 5"),
                ),
              ),
            );
        }
      },
    );
  }
}

class DummyScreen extends StatefulWidget {
  const DummyScreen({Key? key}) : super(key: key);

  @override
  State<DummyScreen> createState() => _DummyScreenState();
}

class _DummyScreenState extends State<DummyScreen> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return true;
        },
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("dummy screen"),
                const TextField(),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("back"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
