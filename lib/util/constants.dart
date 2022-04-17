class Constant {
  // Collection names;
  static const cMember = 'member';
  static const cSecretary = 'secretary';
  static const cSociety = 'society';
  static const cTempUser = 'tempUser';
  static const cMaintenance = 'maintenance';
  static const cPayment = 'payment';

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
  static const fsMonth = 'month';
  static const fsYear = 'year';
  static const fsAmount = 'amount';
  static const fsPenalty = 'penalty';
  static const fsDeadLine = 'deadLine';
  static const fsCreateDate = 'createDate';
  static const fsUserId = 'userId';
  static const fsMaintenanceId = 'maintenanceId';
  static const fsPaymentTime = 'paymentTime';

  // Shared Preferences
  static const spType = 'userType';
  static const spUser = 'user';
}

enum UserType { member, secretary, temp }

enum Months { January, February, March, April, May, June, July, August, September, November, December }
