import 'package:equatable/equatable.dart';

class CountryModel extends Equatable {
  const CountryModel({
    required this.phoneCode,
    required this.countryCode,
    required this.countryName,
    required this.example,
  });

  factory CountryModel.fromMap(Map<String, dynamic> map) {
    return CountryModel(
      phoneCode: map['e164_cc'] as String,
      countryCode: map['iso2_cc'] as String,
      countryName: map['name'] as String,
      example: map['example'] as String,
    );
  }

  factory CountryModel.fromMapDB(Map<String, dynamic> map) {
    return CountryModel(
      phoneCode: map['phoneCode'] as String,
      countryCode: map['countryCode'] as String,
      countryName: map['countryName'] as String,
      example: map['example'] as String,
    );
  }

  final String phoneCode;
  final String countryCode;
  final String countryName;
  final String example;

  CountryModel copyWith({
    String? phoneCode,
    String? countryCode,
    int? level,
    String? countryName,
    String? example,
  }) {
    return CountryModel(
      phoneCode: phoneCode ?? this.phoneCode,
      countryCode: countryCode ?? this.countryCode,
      countryName: countryName ?? this.countryName,
      example: example ?? this.example,
    );
  }

  String get getFlagEmoji {
    final flag = countryCode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
    return flag;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'phoneCode': phoneCode,
      'countryCode': countryCode,
      'countryName': countryName,
      'example': example,
    };
  }

  @override
  List<Object> get props {
    return [
      phoneCode,
      countryCode,
      countryName,
    ];
  }
}
