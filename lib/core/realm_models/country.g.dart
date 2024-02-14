// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Country extends _Country with RealmEntity, RealmObjectBase, RealmObject {
  Country(
    String phoneCode,
    String countryCode,
    String countryName,
    String example,
  ) {
    RealmObjectBase.set(this, 'phoneCode', phoneCode);
    RealmObjectBase.set(this, 'countryCode', countryCode);
    RealmObjectBase.set(this, 'countryName', countryName);
    RealmObjectBase.set(this, 'example', example);
  }

  Country._();

  @override
  String get phoneCode =>
      RealmObjectBase.get<String>(this, 'phoneCode') as String;
  @override
  set phoneCode(String value) => RealmObjectBase.set(this, 'phoneCode', value);

  @override
  String get countryCode =>
      RealmObjectBase.get<String>(this, 'countryCode') as String;
  @override
  set countryCode(String value) =>
      RealmObjectBase.set(this, 'countryCode', value);

  @override
  String get countryName =>
      RealmObjectBase.get<String>(this, 'countryName') as String;
  @override
  set countryName(String value) =>
      RealmObjectBase.set(this, 'countryName', value);

  @override
  String get example => RealmObjectBase.get<String>(this, 'example') as String;
  @override
  set example(String value) => RealmObjectBase.set(this, 'example', value);

  @override
  Stream<RealmObjectChanges<Country>> get changes =>
      RealmObjectBase.getChanges<Country>(this);

  @override
  Country freeze() => RealmObjectBase.freezeObject<Country>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Country._);
    return const SchemaObject(ObjectType.realmObject, Country, 'Country', [
      SchemaProperty('phoneCode', RealmPropertyType.string),
      SchemaProperty('countryCode', RealmPropertyType.string),
      SchemaProperty('countryName', RealmPropertyType.string),
      SchemaProperty('example', RealmPropertyType.string),
    ]);
  }
}
