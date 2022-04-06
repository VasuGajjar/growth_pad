class Constant {
  // Collection names;
  static const cMember = 'member';
  static const cSecretary = 'secretary';
  static const cSociety = 'society';
  static const cTempUser = 'tempUser';

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

  // Shared Prefrences
  static const spType = 'userType';
  static const spUser = 'user';
}

enum UserType { member, secretary, temp }
