import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confesi/core/results/successes.dart';
import 'package:confesi/core/services/api_client/api.dart';
import 'package:confesi/core/services/user_auth/user_auth_service.dart';
import 'package:confesi/models/chat.dart';
import 'package:confesi/models/room.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

class RoomsService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Map<String, Room> _rooms = {};
  final UserAuthService _userAuthService;
  StreamSubscription? _roomSubscription;
  final Api _msgApi;
  final Api _roomNameChangeApi;
  final Api _deleteChatApi;
  bool roomsError = false;
  bool chatsError = false;

  DocumentSnapshot? _lastDocument;
  bool _hasMoreData = true;

  Map<String, Room> get rooms => _rooms;
  bool get hasMoreData => _hasMoreData;

  RoomsService(this._userAuthService, this._msgApi, this._roomNameChangeApi, this._deleteChatApi) {
    loadRooms().then((_) {
      startListenerForRooms();
    });
  }

  Future<Either<ApiSuccess, String>> updateRoomName(String roomId, String name) async {
    try {
      _roomNameChangeApi.cancelCurrReq();
      String oldRoomName = _rooms[roomId]!.name;
      _rooms[roomId] = _rooms[roomId]!.copyWith(name: name);
      notifyListeners();
      return (await _roomNameChangeApi.req(Verb.put, true, "/api/v1/dms/chat", {
        "room_id": roomId,
        "new_name": name,
      }))
          .fold(
        (failureWithMsg) {
          _rooms[roomId] = _rooms[roomId]!.copyWith(name: oldRoomName);
          return Right(failureWithMsg.msg());
        },
        (response) {
          if (response.statusCode.toString()[0] == "2") {
            return Left(ApiSuccess());
          } else {
            _rooms[roomId] = _rooms[roomId]!.copyWith(name: oldRoomName);
            notifyListeners();
            return const Right("todo: error");
          }
        },
      );
    } catch (e) {
      roomsError = true;
      notifyListeners();
      return const Right('Failed to update room name due to an unexpected error.');
    }
  }

  Future<Either<ApiSuccess, String>> deleteChat(String chatId) async {
    try {
      _deleteChatApi.cancelCurrReq();
      Chat oldChat = _rooms.values
          .firstWhere((room) => room.chats.any((chat) => chat.id == chatId))
          .chats
          .firstWhere((chat) => chat.id == chatId);
      // eagerly remove
      String roomId = _rooms.values.firstWhere((room) => room.chats.any((chat) => chat.id == chatId)).roomId;
      _rooms[roomId] =
          _rooms[roomId]!.copyWith(chats: _rooms[roomId]!.chats.where((chat) => chat.id != chatId).toList());
      notifyListeners();
      return (await _deleteChatApi.req(Verb.delete, true, "/api/v1/chat/$chatId", {})).fold(
        (failureWithMsg) {
          print("GOT HERE 1");
          _rooms[roomId] = _rooms[roomId]!.copyWith(chats: [..._rooms[roomId]!.chats, oldChat]);
          return Right(failureWithMsg.msg());
        },
        (response) {
          print("GOT HERE 2");
          if (response.statusCode.toString()[0] == "2") {
            return Left(ApiSuccess());
          } else {
            _rooms[roomId] = _rooms[roomId]!.copyWith(chats: [..._rooms[roomId]!.chats, oldChat]);
            notifyListeners();
            return const Right("todo: error");
          }
        },
      );
    } catch (e) {
      print(e);
      chatsError = true;
      notifyListeners();
      return const Right('Failed to delete chat due to an unexpected error.');
    }
  }

  Future<Either<ApiSuccess, String>> addChat(String roomId, String msg) async {
    try {
      _msgApi.cancelCurrReq();
      return (await _msgApi.req(Verb.post, true, "/api/v1/dms/chat", {
        "room_id": roomId,
        "msg": msg,
      }))
          .fold(
        (failureWithMsg) => Right(failureWithMsg.msg()),
        (response) {
          if (response.statusCode.toString()[0] == "2") {
            return Left(ApiSuccess());
          } else {
            return const Right("todo: error");
          }
        },
      );
    } catch (e) {
      chatsError = true;
      notifyListeners();
      return const Right('Unknown error');
    }
  }

  Future<void> addRoomAndLoadChat(Room room) async {
    try {
      _rooms[room.roomId] = room;
      await loadRecentChatForRoom(room.roomId);
      notifyListeners();
    } catch (e) {
      roomsError = true;
      notifyListeners();
      print('Failed to add room and load chat: $e');
    }
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

  Future<void> loadRecentChatForRoom(String roomId) async {
    try {
      QuerySnapshot chatSnapshot = await _firestore
          .collection('chats')
          .where('room_id', isEqualTo: roomId)
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      List<Chat> chats = chatSnapshot.docs
          .map((chatDoc) => Chat.fromJson({...chatDoc.data() as Map<String, dynamic>, "id": chatDoc.id}))
          .toList();

      if (chats.isNotEmpty) {
        _rooms[roomId] = _rooms[roomId]!.copyWith(chats: chats);
      }
      notifyListeners();
    } catch (e) {
      chatsError = true;
      notifyListeners();
      print('Failed to load recent chat for room: $e');
    }
  }

  Future<void> _processRoomDocument(DocumentSnapshot roomDoc) async {
    try {
      Room room = Room.fromJson({...roomDoc.data() as Map<String, dynamic>, "id": roomDoc.id});

      QuerySnapshot chatSnapshot = await _firestore
          .collection('chats')
          .where('room_id', isEqualTo: room.roomId)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      List<Chat> chats = chatSnapshot.docs
          .map((chatDoc) => Chat.fromJson({...chatDoc.data() as Map<String, dynamic>, "id": chatDoc.id}))
          .toList();

      room = room.copyWith(chats: chats);

      _rooms[room.roomId] = room;
      notifyListeners();
    } catch (e) {
      roomsError = true;
      notifyListeners();
      print('Failed to process room document: $e');
    }
  }

  Stream<QuerySnapshot> fetchRoomsStream() {
    try {
      return _firestore
          .collection('rooms')
          .where('user_id', isEqualTo: _userAuthService.uid)
          .orderBy('last_msg', descending: true)
          .snapshots();
    } catch (e) {
      roomsError = true;
      notifyListeners();
      print('Failed to fetch room stream: $e');
      return Stream.empty();
    }
  }

  Future<void> loadRooms() async {
    try {
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
        for (DocumentSnapshot roomDoc in roomSnapshot.docs) {
          await _processRoomDocument(roomDoc);
        }
      }
    } catch (e) {
      roomsError = true;
      notifyListeners();
      print('Failed to load rooms: $e');
    }
  }

  @override
  void dispose() {
    _roomSubscription?.cancel();
    super.dispose();
  }
}
