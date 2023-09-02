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

  RoomsService(this._userAuthService);

  void clear() {
    _rooms.clear();
    _lastDocument = null;
    _hasMoreData = true;
  }

  // a route to return all the rooms
  List<Room> getRooms() {
    return _rooms.values.toList();
  }

  void startListenerForRooms() {
    _roomSubscription?.cancel();
    _roomSubscription = _firestore
        .collection('rooms')
        .where('user_id', isEqualTo: _userAuthService.uid)
        .orderBy('last_msg', descending: true)
        .snapshots()
        .listen((snapshot) {
      for (var change in snapshot.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            _processRoomDocument(change.doc, fetchChats: true);
            break;
          case DocumentChangeType.modified:
            _processRoomDocument(change.doc, fetchChats: true);
            break;
          case DocumentChangeType.removed:
            _rooms.remove(change.doc.id);
            break;
        }
      }
      notifyListeners();
    });
  }

  Future<void> _processRoomDocument(DocumentSnapshot roomDoc, {bool fetchChats = true}) async {
    Room room = Room.fromJson({...roomDoc.data() as Map<String, dynamic>, "id": roomDoc.id});
    print(room);

    if (fetchChats) {
      QuerySnapshot chatSnapshot = await _firestore.collection('chats').where('room_id', isEqualTo: room.roomId).get();
      List<Chat> chats = chatSnapshot.docs
          .map((chatDoc) => Chat.fromJson({...chatDoc.data() as Map<String, dynamic>, "id": chatDoc.id}))
          .toList();
      room = room.copyWith(chats: chats);
      print(room);
    }

    _rooms[room.roomId] = room;
    notifyListeners();
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
    }
    notifyListeners();
  }

  void addNewRoom(Room room) {
    if (!_rooms.containsKey(room.roomId)) {
      _rooms[room.roomId] = room;
      notifyListeners();
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
