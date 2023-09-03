import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confesi/core/services/user_auth/user_auth_service.dart';
import 'package:confesi/models/chat.dart';
import 'package:confesi/models/room.dart';
import 'package:flutter/material.dart';

class RoomsService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Map<String, Room> _rooms = {};
  final UserAuthService _userAuthService;
  StreamSubscription? _roomSubscription;

  DocumentSnapshot? _lastDocument;
  bool _hasMoreData = true;

  Map<String, Room> get rooms => _rooms;
  bool get hasMoreData => _hasMoreData;

  RoomsService(this._userAuthService) {
    loadRooms().then((_) {
      startListenerForRooms();
    });
  }

  void clear() {
    _rooms.clear();
    _lastDocument = null;
    _hasMoreData = true;
  }

  List<Room> getRooms() {
    return _rooms.values.toList();
  }

  void startListenerForRooms() {
    _roomSubscription?.cancel();
    _roomSubscription = fetchRoomsStream().listen((snapshot) {
      for (var change in snapshot.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            if (!_rooms.containsKey(change.doc.id)) {
              _processRoomDocument(change.doc);
            }
            break;
          case DocumentChangeType.modified:
            _processRoomDocument(change.doc);
            break;
          case DocumentChangeType.removed:
            _rooms.remove(change.doc.id);
            break;
        }
      }
      notifyListeners();
    });
  }

  void updateRooms(List<Room> rooms) {
    for (Room room in rooms) {
      if (!_rooms.containsKey(room.roomId)) {
        _rooms[room.roomId] = room;
      }
    }
  }

  Future<void> addRoomAndLoadChat(Room room) async {
    _rooms[room.roomId] = room;
    await loadRecentChatForRoom(room.roomId);
  }

  Future<void> loadRecentChatForRoom(String roomId) async {
    print("CALLED!");
    QuerySnapshot chatSnapshot = await _firestore
        .collection('chats')
        .where('room_id', isEqualTo: roomId)
        .orderBy('date', descending: true)
        .limit(1)
        .get();

    List<Chat> chats = chatSnapshot.docs
        .map((chatDoc) => Chat.fromJson({...chatDoc.data() as Map<String, dynamic>, "id": chatDoc.id}))
        .toList();

    print("results: " + chats.toString());

    if (chats.isNotEmpty) {
      _rooms[roomId] = _rooms[roomId]!.copyWith(chats: chats);
    }
    notifyListeners();
  }

  Future<void> _processRoomDocument(DocumentSnapshot roomDoc) async {
    print("HERE!!!");
    Room room = Room.fromJson({...roomDoc.data() as Map<String, dynamic>, "id": roomDoc.id});

    // Fetch the latest chat for the room
    QuerySnapshot chatSnapshot = await _firestore
        .collection('chats')
        .where('room_id', isEqualTo: room.roomId)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    print("FETCHIGN>>>>>>");

    List<Chat> chats = chatSnapshot.docs
        .map((chatDoc) => Chat.fromJson({...chatDoc.data() as Map<String, dynamic>, "id": chatDoc.id}))
        .toList();

    print(chats);
    // Add the fetched chat to the room
    room = room.copyWith(chats: chats);

    _rooms[room.roomId] = room;
    notifyListeners();
  }

  Stream<QuerySnapshot> fetchRoomsStream() {
    return _firestore
        .collection('rooms')
        .where('user_id', isEqualTo: _userAuthService.uid)
        .orderBy('last_msg', descending: true)
        .snapshots();
  }

  Future<void> addRoomsFromSnapshot(List<Room> rooms) async {
    for (Room room in rooms) {
      _rooms[room.roomId] = room;
    }
  }

  Future<void> loadRooms() async {
    if (!_hasMoreData) return;

    Query query = _firestore
        .collection('rooms')
        .where('user_id', isEqualTo: _userAuthService.uid)
        .orderBy('last_msg', descending: true)
        .limit(5);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    QuerySnapshot roomSnapshot = await query.get();

    if (roomSnapshot.docs.length < 5) {
      _hasMoreData = false;
    }

    if (roomSnapshot.docs.isNotEmpty) {
      _lastDocument = roomSnapshot.docs.last;
      for (QueryDocumentSnapshot roomDoc in roomSnapshot.docs) {
        await _processRoomDocument(roomDoc);
      }
    }
    notifyListeners();
  }

  void addChatToRoom(String roomId, Chat chat) {
    if (_rooms.containsKey(roomId)) {
      _rooms[roomId]!.chats.add(chat);
      notifyListeners();
    }
  }

  void addNewRoom(Room room) {
    if (!_rooms.containsKey(room.roomId)) {
      _rooms[room.roomId] = room;
    }
  }

  void removeRoom(String roomId) {
    _rooms.remove(roomId);
    notifyListeners();
  }

  @override
  void dispose() {
    _roomSubscription?.cancel();
    super.dispose();
  }
}
