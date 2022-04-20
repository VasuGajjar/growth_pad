class Constant {
  // Collection names;
  static const cMember = 'member';
  static const cSecretary = 'secretary';
  static const cSociety = 'society';
  static const cTempUser = 'tempUser';
  static const cMaintenance = 'maintenance';
  static const cPayment = 'payment';
  static const cNotice = 'notice';

  // Field names
  static const fsId = 'id';
  static const fsName = 'name';
  static const fsEmail = 'email';
  static const fsSocietyId = 'societyId';
  static const fsBlock = 'block';
  static const fsHouseNumber = 'houseNumber';
  static const fsAddress = 'address';
  static const fsTotalHouses = 'totalHouses';
  static const fsSearchName = 'searchName';
  static const fsAccount = 'account';
  static const fsIfsc = 'ifsc';
  static const fsMonth = 'month';
  static const fsYear = 'year';
  static const fsAmount = 'amount';
  static const fsPenalty = 'penalty';
  static const fsDeadLine = 'deadLine';
  static const fsCreateDate = 'createDate';
  static const fsUserId = 'userId';
  static const fsMaintenanceId = 'maintenanceId';
  static const fsPaymentTime = 'paymentTime';
  static const fsTitle = 'title';
  static const fsDescription = 'description';

  // Shared Preferences
  static const spType = 'userType';
  static const spUser = 'user';
  static const spUidTopic = 'userId';
  static const spSidTopic = 'societyId';
}

enum UserType { member, secretary, temp }
