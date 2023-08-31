import 'package:confesi/core/router/go_router.dart';
import 'package:confesi/models/encrypted_id.dart';
import 'package:confesi/models/room.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_opacity.dart';
import 'package:flutter/material.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({Key? key}) : super(key: key);

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  List<Room> rooms = [
    Room(
      id: EncryptedId(uid: "abcDEF", mid: "123456"),
      userCreator: 'userA',
      userOther: 'userB',
      name: 'Room 1',
      lastMsg: DateTime(2023, 8, 29, 14, 30),
    ),
    Room(
      id: EncryptedId(uid: "ghijKL", mid: "789012"),
      userCreator: 'userA',
      userOther: 'userC',
      name: 'Room 2',
      lastMsg: DateTime(2023, 8, 28, 16, 15),
    ),
    Room(
      id: EncryptedId(uid: "mnopQR", mid: "345678"),
      userCreator: 'userB',
      userOther: 'userC',
      name: 'Room 3',
      lastMsg: DateTime(2023, 8, 27, 19, 10),
    ),
    Room(
      id: EncryptedId(uid: "stuvWX", mid: "901234"),
      userCreator: 'userA',
      userOther: 'userD',
      name: 'Room 4',
      lastMsg: DateTime(2023, 8, 26, 11, 5),
    ),
    Room(
      id: EncryptedId(uid: "yzABCD", mid: "567890"),
      userCreator: 'userC',
      userOther: 'userD',
      name: 'Room 5',
      lastMsg: DateTime(2023, 8, 25, 9, 50),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: rooms.map((room) {
          return TouchableOpacity(
            onTap: () => router.push("/home/rooms/chat"),
            child: Container(
              height: 100,
              color: Colors.red,
              margin: const EdgeInsets.all(10),
              child: Center(child: Text(room.name)),
            ),
          );
        }).toList(),
      ),
    );
  }
}
