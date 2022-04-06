import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:growthpad/data/model/member.dart';
import 'package:growthpad/util/constants.dart';

class RequestRepository {
  final FirebaseFirestore firestore;

  RequestRepository({required this.firestore});

  Future<List<Member>> getRequestingMembers(String societyId) async {
    List<Member> members = [];

    var query = await firestore.collection(Constant.cTempUser).where(Constant.fsSocietyId, isEqualTo: societyId).get();
    members.addAll(query.docs.map((e) => Member.fromMap(e.data())));

    return members;
  }

  Future<void> acceptUser(Member user) async {
    await firestore.collection(Constant.cMember).add(user.toMap());
    var query = await firestore.collection(Constant.cTempUser).where(Constant.fsId, isEqualTo: user.id).get();
    var documentSnapshot = query.docs.first;
    await firestore.collection(Constant.cTempUser).doc(documentSnapshot.id).delete();
  }

  Future<void> rejectUser(Member user) async {
    var query = await firestore.collection(Constant.cTempUser).where(Constant.fsId, isEqualTo: user.id).get();
    var documentSnapshot = query.docs.first;
    await firestore.collection(Constant.cTempUser).doc(documentSnapshot.id).delete();
  }
}
