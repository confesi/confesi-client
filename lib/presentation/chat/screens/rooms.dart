import 'package:confesi/core/router/go_router.dart';
import 'package:confesi/core/services/rooms/rooms_service.dart';
import 'package:confesi/models/room.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_opacity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({Key? key}) : super(key: key);

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<RoomsService>(context, listen: false).loadRooms();
    Provider.of<RoomsService>(context, listen: false).startListenerForRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Icon(Icons.add),
      appBar: AppBar(
        title: Text("Rooms"),
        // Refresh button might not be needed with real-time updates
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => setState(() {}), // Placeholder action
          ),
        ],
      ),
      body: Consumer<RoomsService>(
        builder: (context, roomsService, child) {
          List<Room> rooms = roomsService.getRooms();
          return ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              Room room = rooms[index];
              return TouchableOpacity(
                onTap: () => router.push("/home/rooms/chat", extra: ChatProps(room.roomId)),
                child: Container(
                  height: 100,
                  color: Colors.red,
                  margin: const EdgeInsets.all(10),
                  child: Center(child: Text(room.name)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
