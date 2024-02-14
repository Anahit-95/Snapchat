// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_m.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class UserM extends _UserM with RealmEntity, RealmObjectBase, RealmObject {
  UserM(
    String? username, {
    String? firstName,
    String? lastName,
    String? birthday,
    String? email,
    String? countryCode,
    String? phoneCode,
    String? phoneNumber,
    String? password,
  }) {
    RealmObjectBase.set(this, 'username', username);
    RealmObjectBase.set(this, 'firstName', firstName);
    RealmObjectBase.set(this, 'lastName', lastName);
    RealmObjectBase.set(this, 'birthday', birthday);
    RealmObjectBase.set(this, 'email', email);
    RealmObjectBase.set(this, 'countryCode', countryCode);
    RealmObjectBase.set(this, 'phoneCode', phoneCode);
    RealmObjectBase.set(this, 'phoneNumber', phoneNumber);
    RealmObjectBase.set(this, 'password', password);
  }

  UserM._();

  @override
  String? get username =>
      RealmObjectBase.get<String>(this, 'username') as String?;
  @override
  set username(String? value) => RealmObjectBase.set(this, 'username', value);

  @override
  String? get firstName =>
      RealmObjectBase.get<String>(this, 'firstName') as String?;
  @override
  set firstName(String? value) => RealmObjectBase.set(this, 'firstName', value);

  @override
  String? get lastName =>
      RealmObjectBase.get<String>(this, 'lastName') as String?;
  @override
  set lastName(String? value) => RealmObjectBase.set(this, 'lastName', value);

  @override
  String? get birthday =>
      RealmObjectBase.get<String>(this, 'birthday') as String?;
  @override
  set birthday(String? value) => RealmObjectBase.set(this, 'birthday', value);

  @override
  String? get email => RealmObjectBase.get<String>(this, 'email') as String?;
  @override
  set email(String? value) => RealmObjectBase.set(this, 'email', value);

  @override
  String? get countryCode =>
      RealmObjectBase.get<String>(this, 'countryCode') as String?;
  @override
  set countryCode(String? value) =>
      RealmObjectBase.set(this, 'countryCode', value);

  @override
  String? get phoneCode =>
      RealmObjectBase.get<String>(this, 'phoneCode') as String?;
  @override
  set phoneCode(String? value) => RealmObjectBase.set(this, 'phoneCode', value);

  @override
  String? get phoneNumber =>
      RealmObjectBase.get<String>(this, 'phoneNumber') as String?;
  @override
  set phoneNumber(String? value) =>
      RealmObjectBase.set(this, 'phoneNumber', value);

  @override
  String? get password =>
      RealmObjectBase.get<String>(this, 'password') as String?;
  @override
  set password(String? value) => RealmObjectBase.set(this, 'password', value);

  @override
  Stream<RealmObjectChanges<UserM>> get changes =>
      RealmObjectBase.getChanges<UserM>(this);

  @override
  UserM freeze() => RealmObjectBase.freezeObject<UserM>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(UserM._);
    return const SchemaObject(ObjectType.realmObject, UserM, 'UserM', [
      SchemaProperty('username', RealmPropertyType.string,
          optional: true, primaryKey: true),
      SchemaProperty('firstName', RealmPropertyType.string, optional: true),
      SchemaProperty('lastName', RealmPropertyType.string, optional: true),
      SchemaProperty('birthday', RealmPropertyType.string, optional: true),
      SchemaProperty('email', RealmPropertyType.string, optional: true),
      SchemaProperty('countryCode', RealmPropertyType.string, optional: true),
      SchemaProperty('phoneCode', RealmPropertyType.string, optional: true),
      SchemaProperty('phoneNumber', RealmPropertyType.string, optional: true),
      SchemaProperty('password', RealmPropertyType.string, optional: true),
    ]);
  }
}
