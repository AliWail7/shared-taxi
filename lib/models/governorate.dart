class Governorate {
  final String id;
  final String name;
  final String nameEn;
  final String? code;
  final double? latitude;
  final double? longitude;

  const Governorate({
    required this.id,
    required this.name,
    required this.nameEn,
    this.code,
    this.latitude,
    this.longitude,
  });

  factory Governorate.fromJson(Map<String, dynamic> json) {
    return Governorate(
      id: json['id'] as String,
      name: json['name'] as String,
      nameEn: json['nameEn'] as String,
      code: json['code'] as String?,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameEn': nameEn,
      'code': code,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Governorate && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Governorate(id: $id, name: $name, nameEn: $nameEn)';
  }

  // Static list of Iraqi governorates
  static const List<Governorate> iraqiGovernorates = [
    Governorate(
      id: '1', 
      name: 'بغداد', 
      nameEn: 'Baghdad',
      code: 'BGD',
      latitude: 33.3152,
      longitude: 44.3661,
    ),
    Governorate(
      id: '2', 
      name: 'البصرة', 
      nameEn: 'Basra',
      code: 'BSR',
      latitude: 30.5085,
      longitude: 47.7804,
    ),
    Governorate(
      id: '3', 
      name: 'أربيل', 
      nameEn: 'Erbil',
      code: 'EBL',
      latitude: 36.1911,
      longitude: 44.0094,
    ),
    Governorate(
      id: '4', 
      name: 'النجف', 
      nameEn: 'Najaf',
      code: 'NJF',
      latitude: 32.0000,
      longitude: 44.3167,
    ),
    Governorate(
      id: '5', 
      name: 'كربلاء', 
      nameEn: 'Karbala',
      code: 'KBL',
      latitude: 32.6160,
      longitude: 44.0242,
    ),
    Governorate(
      id: '6', 
      name: 'الموصل', 
      nameEn: 'Mosul',
      code: 'MSL',
      latitude: 36.3489,
      longitude: 43.1186,
    ),
    Governorate(
      id: '7', 
      name: 'السليمانية', 
      nameEn: 'Sulaymaniyah',
      code: 'SLM',
      latitude: 35.5556,
      longitude: 45.4330,
    ),
    Governorate(
      id: '8', 
      name: 'كركوك', 
      nameEn: 'Kirkuk',
      code: 'KRK',
      latitude: 35.4681,
      longitude: 44.3922,
    ),
    Governorate(
      id: '9', 
      name: 'الأنبار', 
      nameEn: 'Anbar',
      code: 'ANB',
      latitude: 33.4204,
      longitude: 43.2373,
    ),
    Governorate(
      id: '10', 
      name: 'ديالى', 
      nameEn: 'Diyala',
      code: 'DYL',
      latitude: 33.7630,
      longitude: 44.9300,
    ),
    Governorate(
      id: '11', 
      name: 'بابل', 
      nameEn: 'Babylon',
      code: 'BBL',
      latitude: 32.5429,
      longitude: 44.4199,
    ),
    Governorate(
      id: '12', 
      name: 'واسط', 
      nameEn: 'Wasit',
      code: 'WST',
      latitude: 32.4598,
      longitude: 45.8326,
    ),
    Governorate(
      id: '13', 
      name: 'صلاح الدين', 
      nameEn: 'Saladin',
      code: 'SLD',
      latitude: 34.1975,
      longitude: 43.6793,
    ),
    Governorate(
      id: '14', 
      name: 'القادسية', 
      nameEn: 'Al-Qādisiyyah',
      code: 'QAD',
      latitude: 31.9996,
      longitude: 45.0000,
    ),
    Governorate(
      id: '15', 
      name: 'ذي قار', 
      nameEn: 'Dhi Qar',
      code: 'DHQ',
      latitude: 31.0000,
      longitude: 46.2500,
    ),
    Governorate(
      id: '16', 
      name: 'المثنى', 
      nameEn: 'Al Muthanna',
      code: 'MTH',
      latitude: 29.7500,
      longitude: 45.7500,
    ),
    Governorate(
      id: '17', 
      name: 'ميسان', 
      nameEn: 'Maysan',
      code: 'MYS',
      latitude: 31.9256,
      longitude: 47.1500,
    ),
    Governorate(
      id: '18', 
      name: 'دهوك', 
      nameEn: 'Duhok',
      code: 'DHK',
      latitude: 36.8628,
      longitude: 42.9789,
    ),
  ];
}
