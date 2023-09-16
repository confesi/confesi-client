import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confesi/core/results/successes.dart';
import 'package:confesi/core/services/api_client/api.dart';
import 'package:confesi/core/services/user_auth/user_auth_service.dart';
import 'package:confesi/models/chat.dart';
import 'package:confesi/models/room.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:ordered_set/ordered_set.dart';

import '../../../constants/shared/constants.dart';
import '../../../init.dart';

extension MyIterable<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;

  T? firstWhereOrNull(bool Function(T element) test) {
    final list = where(test);
    return list.isEmpty ? null : list.first;
  }
}

class RoomsService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Map<String, Room> _rooms = {};
  StreamSubscription? _roomSubscription;
  final Api _msgApi;
  final Api _roomNameChangeApi;
  final Api _deleteChatApi; // todo: implement
  bool roomsError = false;
  bool chatsError = false;
  DocumentSnapshot? _lastDocument;
  bool _hasMoreData = true;
  final Map<String, StreamSubscription> _chatSubscriptions = {};

  Map<String, Room> get rooms => _rooms;
  bool get hasMoreData => _hasMoreData;

  // getter for _userAuthService
  UserAuthService get userAuthService =>
      sl.get<UserAuthService>()..uid = "kco5wCBnv7SOAaBFnHBHr7C3lsr1"; // todo: DONT HARD CODE

  RoomsService(this._msgApi, this._roomNameChangeApi, this._deleteChatApi) {
    loadRooms();
    startListenerForRooms();
  }

  Future<Either<ApiSuccess, String>> updateRoomName(String roomId, String name) async {
    print("UPDATE ROOM NAME");
    try {
      _roomNameChangeApi.cancelCurrReq();
      final oldRoom = _rooms[roomId];
      if (oldRoom != null) {
        final updatedRoom = oldRoom.copyWith(name: name);
        _rooms[roomId] = updatedRoom;
        notifyListeners();

        final response = await _roomNameChangeApi.req(Verb.put, true, "/api/v1/dms/chat", {
          "room_id": roomId,
          "new_name": name,
        });

        return response.fold(
          (failureWithMsg) {
            _rooms[roomId] = oldRoom;
            notifyListeners();
            return Right(failureWithMsg.msg());
          },
          (response) {
            if (response.statusCode.toString()[0] == "2") {
              return Left(ApiSuccess());
            } else {
              _rooms[roomId] = oldRoom;
              notifyListeners();
              return Right("todo: error");
            }
          },
        );
      } else {
        return Right("Room not found");
      }
    } catch (e) {
      roomsError = true;
      notifyListeners();
      return Right('Failed to update room name due to an unexpected error.');
    }
  }

  Future<void> addRoomAndLoadChat(Room room) async {
    print("ADD ROOM AND LOAD CHAT");
    try {
      if (!_rooms.containsKey(room.roomId)) {
        _rooms[room.roomId] = room;
        await loadRecentChatForRoom(room.roomId);
        notifyListeners();
      } else {
        print("Room already exists, not adding it again");
      }
    } catch (e) {
      roomsError = true;
      notifyListeners();
    }
  }

  Future<Either<ApiSuccess, String>> addChat(String roomId, String msg) async {
    print("ADD CHAT");
    try {
      _msgApi.cancelCurrReq();
      final response = await _msgApi.req(Verb.post, true, "/api/v1/dms/chat", {
        "room_id": roomId,
        "msg": msg,
      });
      return response.fold(
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

  void startListenerForRooms() {
    print("START LISTENER FOR ROOMS2");

    _roomSubscription?.cancel();
    print("this user's uid: ${userAuthService.uid}");
    _roomSubscription = _firestore
        .collection('rooms')
        .where('user_id', isEqualTo: userAuthService.uid)
        .orderBy('last_msg', descending: true)
        .snapshots()
        .listen(
      (QuerySnapshot snapshot) {
        print('Snapshot size: ${snapshot.size}');
        if (snapshot.size == 0) {
          print('No documents found');
        }

        for (var change in snapshot.docChanges) {
          print("CHANGE!!!!!");
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
      },
    );
  }

  Future<void> loadRecentChatForRoom(String roomId) async {
    print("LOAD RECENT CHAT FOR ROOM");
    try {
      final chatCollection = _firestore.collection('chats');

      // Retrieve the initial snapshot
      final initialSnapshot = await chatCollection
          .where('room_id', isEqualTo: roomId)
          .orderBy('date', descending: true)
          .limit(chatPageSize)
          .get();

      // Map the initial snapshot to Chat objects
      List<Chat> currentChats =
          initialSnapshot.docs.map((chatDoc) => Chat.fromJson({...chatDoc.data(), "id": chatDoc.id})).toList();

      // Set the most recent chat to the room
      if (_rooms.containsKey(roomId) && currentChats.isNotEmpty) {
        _rooms[roomId] = _rooms[roomId]!.copyWith(recentChat: currentChats.first);
        notifyListeners();
      }

      // Set up a stream subscription to listen for new chats
      final chatStream =
          chatCollection.where('room_id', isEqualTo: roomId).orderBy('date', descending: true).limit(1).snapshots();

      _chatSubscriptions[roomId]?.cancel();
      _chatSubscriptions[roomId] = chatStream.listen((querySnapshot) {
        final newChatDocs = querySnapshot.docChanges
            .where((docChange) => docChange.type == DocumentChangeType.added)
            .map(
                (docChange) => Chat.fromJson({...docChange.doc.data() as Map<String, dynamic>, "id": docChange.doc.id}))
            .toList();

        if (newChatDocs.isNotEmpty) {
          // Update the recent chat of the room
          if (_rooms.containsKey(roomId)) {
            _rooms[roomId] = _rooms[roomId]!.copyWith(recentChat: newChatDocs.first);
            notifyListeners();
          }
        }
      });
    } catch (e) {
      chatsError = true;
      notifyListeners();
    }
  }

  Future<void> _processRoomDocument(DocumentSnapshot roomDoc) async {
    print("PROCESS ROOM DOCUMENT");
    try {
      Room room = Room.fromJson({...roomDoc.data() as Map<String, dynamic>, "id": roomDoc.id});
      if (_rooms[room.roomId] == null) return;
      _rooms[room.roomId] = _rooms[room.roomId]!.copyWith(
        name: room.name,
        lastMsg: room.lastMsg,
        userNumber: room.userNumber,
      );

      notifyListeners();
    } catch (e) {
      roomsError = true;
      notifyListeners();
    }
  }

  Future<void> loadRooms() async {
    print("LOAD ROOMS");
    try {
      if (!_hasMoreData) return;

      Query query = _firestore
          .collection('rooms')
          .where('user_id', isEqualTo: userAuthService.uid)
          .orderBy('last_msg', descending: true)
          .limit(chatPageSize);

      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      QuerySnapshot roomSnapshot = await query.get();

      if (roomSnapshot.docs.length < chatPageSize) {
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
    print("dispose");
    for (var subscription in _chatSubscriptions.values) {
      subscription.cancel();
    }
    _roomSubscription?.cancel();
    super.dispose();
  }
}
