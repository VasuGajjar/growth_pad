import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../helper/log.dart';
import '../../util/constants.dart';
import '../model/member.dart';
import '../model/secretary.dart';
import '../model/society.dart';

class AuthRepository {
  final SharedPreferences preferences;
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final FirebaseDatabase database;

  AuthRepository({
    required this.preferences,
    required this.firebaseAuth,
    required this.firestore,
    required this.database,
  });

  Future<void> memberLogin({
    required String email,
    required String password,
    required void Function(Member user, bool isVerified) onSuccess,
    required void Function(String message) onFailure,
  }) async {
    try {
      var user = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      if (user.user != null) {
        var userId = user.user!.uid;
        var snapshot = await firestore.collection(Constant.cMember).where(Constant.fsId, isEqualTo: userId).get();
        if (snapshot.docs.isNotEmpty) {
          Member user = Member.fromMap(snapshot.docs.first.data());
          onSuccess(user, true);
        } else {
          var tempSnapshot = await firestore.collection(Constant.cTempUser).where(Constant.fsId, isEqualTo: userId).get();
          if (tempSnapshot.docs.isNotEmpty) {
            Member user = Member.fromMap(tempSnapshot.docs.first.data());
            onSuccess(user, false);
          } else {
            onFailure('No user found');
          }
        }
      } else {
        onFailure('No user found');
      }
    } on FirebaseAuthException catch (e) {
      Log.console('FirebaseAuthException.code: ${e.code}');
      Log.console('FirebaseAuthException.message: ${e.message}');

      switch (e.code) {
        case 'invalid-email':
          onFailure('Invalid Email');
          break;
        case 'user-disabled':
          onFailure('User Disabled');
          break;
        case 'user-not-found':
          onFailure('User not found');
          break;
        case 'wrong-password':
          onFailure('Wrong Password');
          break;
        default:
          onFailure(e.code);
      }
    } catch (e) {
      Log.console('AuthRepository.memberLogin.error: $e');
      onFailure('Something went wrong');
    }
  }

  Future<void> secretaryLogin({
    required String email,
    required String password,
    required void Function(Secretary user) onSuccess,
    required void Function(String message) onFailure,
  }) async {
    try {
      var user = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      if (user.user != null) {
        var userId = user.user!.uid;
        var snapshot = await firestore.collection(Constant.cSecretary).where(Constant.fsId, isEqualTo: userId).get();
        if (snapshot.docs.isNotEmpty) {
          Secretary user = Secretary.fromMap(snapshot.docs.first.data());
          onSuccess(user);
        } else {
          onFailure('No user found');
        }
      } else {
        onFailure('No user found');
      }
    } on FirebaseAuthException catch (e) {
      Log.console('FirebaseAuthException.code: ${e.code}');
      Log.console('FirebaseAuthException.message: ${e.message}');

      switch (e.code) {
        case 'invalid-email':
          onFailure('Invalid Email');
          break;
        case 'user-disabled':
          onFailure('User Disabled');
          break;
        case 'user-not-found':
          onFailure('User not found');
          break;
        case 'wrong-password':
          onFailure('Wrong Password');
          break;
        default:
          onFailure(e.code);
      }
    } catch (e) {
      Log.console('AuthRepository.secretaryLogin.error: $e');
      onFailure('Something went wrong');
    }
  }

  Future<void> secretaryRegisteration({
    required String email,
    required String password,
    required String name,
    required String societyName,
    required String address,
    required String totalHouses,
    required void Function(Secretary user, Society society) onSuccess,
    required void Function(String message) onFailure,
  }) async {
    try {
      var auth = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      if (auth.user != null) {
        var userId = auth.user!.uid;
        var societyId = const Uuid().v1();

        var user = Secretary(id: userId, name: name, email: email, sid: societyId);
        var society = Society(id: societyId, name: societyName, address: address, totalHouses: totalHouses, searchName: societyName.toLowerCase());

        await firestore.collection(Constant.cSecretary).add(user.toMap());
        await firestore.collection(Constant.cSociety).add(society.toMap());

        onSuccess(user, society);
      } else {
        onFailure('Unable to register');
      }
    } on FirebaseAuthException catch (e) {
      Log.console('FirebaseAuthException.code: ${e.code}');
      Log.console('FirebaseAuthException.message: ${e.message}');

      switch (e.code) {
        case 'email-already-in-use':
          onFailure('Email already taken');
          break;
        case 'operation-not-allowed':
          onFailure('Email login is not enabled');
          break;
        case 'invalid-email':
          onFailure('Invalid Email');
          break;
        case 'weak-password':
          onFailure('Weak Password');
          break;
        default:
          onFailure(e.code);
      }
    } catch (e) {
      Log.console('AuthRepository.secretaryRegisteration.error: $e');
      onFailure('Something went wrong');
    }
  }

  Future<void> memberRegisteration({
    required String email,
    required String password,
    required String name,
    required String societyId,
    required String block,
    required String houseNo,
    required void Function(Member user) onSuccess,
    required void Function(String message) onFailure,
  }) async {
    try {
      var auth = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      if (auth.user != null) {
        var userId = auth.user!.uid;
        var user = Member(id: userId, name: name, email: email, sid: societyId, block: block, houseNo: houseNo);
        await firestore.collection(Constant.cTempUser).add(user.toMap());
        onSuccess(user);
      } else {
        onFailure('Unable to register');
      }
    } on FirebaseAuthException catch (e) {
      Log.console('FirebaseAuthException.code: ${e.code}');
      Log.console('FirebaseAuthException.message: ${e.message}');

      switch (e.code) {
        case 'email-already-in-use':
          onFailure('Email already taken');
          break;
        case 'operation-not-allowed':
          onFailure('Email login is not enabled');
          break;
        case 'invalid-email':
          onFailure('Invalid Email');
          break;
        case 'weak-password':
          onFailure('Weak Password');
          break;
        default:
          onFailure(e.code);
      }
    } catch (e) {
      Log.console('AuthRepository.memberRegisteration.error: $e');
      onFailure('Something went wrong');
    }
  }

  Future<List<Society>> fetchSocieties(String query) async {
    List<Society> societies = [];

    try {
      if (query.isEmpty) {
        var snapshots = await firestore.collection(Constant.cSociety).get();

        for (var i = 0; i < snapshots.docs.length; i++) {
          var map = snapshots.docs[i].data();
          societies.add(Society.fromMap(map));
        }
      } else {
        var snapshots = await firestore
            .collection(Constant.cSociety)
            .where(Constant.fsSearchName, isGreaterThanOrEqualTo: query)
            .where(Constant.fsSearchName, isLessThan: query + 'z')
            .get();

        for (var i = 0; i < snapshots.docs.length; i++) {
          var map = snapshots.docs[i].data();
          societies.add(Society.fromMap(map));
        }
      }
    } catch (e) {
      Log.console('AuthRepository.fetchSocieties.error: $e');
    }

    return societies;
  }

  Future<Member?> searchMember(String uuid) async {
    Member? user;

    try {
      var snapshot = await firestore.collection(Constant.cMember).where(Constant.fsId, isEqualTo: uuid).get();
      if (snapshot.docs.isNotEmpty) {
        user = Member.fromMap(snapshot.docs.first.data());
      }
    } catch (e) {
      Log.console('AuthRepository.searchMember.error: $e');
    }

    return user;
  }
}
