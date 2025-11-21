class WaitingPoint {
  final String id;
  final String name;
  final String governorateId;
  final double? latitude;
  final double? longitude;

  const WaitingPoint({
    required this.id,
    required this.name,
    required this.governorateId,
    this.latitude,
    this.longitude,
  });

  // نقاط الانتظار لكل محافظة
  static const Map<String, List<WaitingPoint>> waitingPointsByGovernorate = {
    // بغداد
    '1': [
      WaitingPoint(id: '1-1', name: 'ساحة الطيران', governorateId: '1', latitude: 33.3152, longitude: 44.3661),
      WaitingPoint(id: '1-2', name: 'ساحة النسور', governorateId: '1', latitude: 33.3400, longitude: 44.4009),
      WaitingPoint(id: '1-3', name: 'الباب الشرقي', governorateId: '1', latitude: 33.3406, longitude: 44.4212),
      WaitingPoint(id: '1-4', name: 'باب المعظم', governorateId: '1', latitude: 33.3450, longitude: 44.4100),
      WaitingPoint(id: '1-5', name: 'الكرادة', governorateId: '1', latitude: 33.3119, longitude: 44.4022),
      WaitingPoint(id: '1-6', name: 'المنصور', governorateId: '1', latitude: 33.3031, longitude: 44.3444),
      WaitingPoint(id: '1-7', name: 'الجادرية', governorateId: '1', latitude: 33.2854, longitude: 44.3831),
    ],
    
    // البصرة
    '2': [
      WaitingPoint(id: '2-1', name: 'الكراج الكبير', governorateId: '2', latitude: 30.5085, longitude: 47.7804),
      WaitingPoint(id: '2-2', name: 'العشار', governorateId: '2', latitude: 30.5030, longitude: 47.8169),
      WaitingPoint(id: '2-3', name: 'الزبير', governorateId: '2', latitude: 30.3858, longitude: 47.7053),
      WaitingPoint(id: '2-4', name: 'شارع الجامعة', governorateId: '2', latitude: 30.5150, longitude: 47.8200),
      WaitingPoint(id: '2-5', name: 'البرجسية', governorateId: '2', latitude: 30.4750, longitude: 47.8500),
    ],
    
    // أربيل
    '3': [
      WaitingPoint(id: '3-1', name: 'القلعة', governorateId: '3', latitude: 36.1911, longitude: 44.0094),
      WaitingPoint(id: '3-2', name: 'شارع 100 متر', governorateId: '3', latitude: 36.1800, longitude: 44.0200),
      WaitingPoint(id: '3-3', name: 'إيمباير', governorateId: '3', latitude: 36.1750, longitude: 44.0150),
      WaitingPoint(id: '3-4', name: 'الكراج الدولي', governorateId: '3', latitude: 36.2000, longitude: 44.0300),
    ],
    
    // النجف
    '4': [
      WaitingPoint(id: '4-1', name: 'ثورة العشرين', governorateId: '4', latitude: 32.0000, longitude: 44.3167),
      WaitingPoint(id: '4-2', name: 'شارع الكفعات', governorateId: '4', latitude: 31.9950, longitude: 44.3200),
      WaitingPoint(id: '4-3', name: 'أمام الكراج الجنوبي', governorateId: '4', latitude: 31.9850, longitude: 44.3100),
      WaitingPoint(id: '4-4', name: 'أمام الكراج الشمالي', governorateId: '4', latitude: 32.0100, longitude: 44.3250),
      WaitingPoint(id: '4-5', name: 'منطقة الأمير', governorateId: '4', latitude: 32.0050, longitude: 44.3180),
      WaitingPoint(id: '4-6', name: 'الصحن الشريف', governorateId: '4', latitude: 32.0033, longitude: 44.3194),
    ],
    
    // كربلاء
    '5': [
      WaitingPoint(id: '5-1', name: 'باب الخان', governorateId: '5', latitude: 32.6160, longitude: 44.0242),
      WaitingPoint(id: '5-2', name: 'شارع الإمام الحسين', governorateId: '5', latitude: 32.6150, longitude: 44.0300),
      WaitingPoint(id: '5-3', name: 'منطقة المخيم', governorateId: '5', latitude: 32.6100, longitude: 44.0200),
      WaitingPoint(id: '5-4', name: 'الكراج الجديد', governorateId: '5', latitude: 32.6200, longitude: 44.0350),
      WaitingPoint(id: '5-5', name: 'الحر', governorateId: '5', latitude: 32.6050, longitude: 44.0150),
    ],
    
    // الموصل
    '6': [
      WaitingPoint(id: '6-1', name: 'الموصل الجديدة', governorateId: '6', latitude: 36.3350, longitude: 43.1189),
      WaitingPoint(id: '6-2', name: 'الساعة', governorateId: '6', latitude: 36.3400, longitude: 43.1250),
      WaitingPoint(id: '6-3', name: 'الجامعة', governorateId: '6', latitude: 36.3500, longitude: 43.1300),
      WaitingPoint(id: '6-4', name: 'باب الطوب', governorateId: '6', latitude: 36.3450, longitude: 43.1200),
    ],
    
    // السليمانية
    '7': [
      WaitingPoint(id: '7-1', name: 'سيتي سنتر', governorateId: '7', latitude: 35.5608, longitude: 45.4383),
      WaitingPoint(id: '7-2', name: 'سراي', governorateId: '7', latitude: 35.5650, longitude: 45.4400),
      WaitingPoint(id: '7-3', name: 'الكراج الدولي', governorateId: '7', latitude: 35.5550, longitude: 45.4450),
    ],
    
    // ديالى
    '8': [
      WaitingPoint(id: '8-1', name: 'ساحة الأحرار', governorateId: '8', latitude: 33.7500, longitude: 44.8667),
      WaitingPoint(id: '8-2', name: 'شارع 20', governorateId: '8', latitude: 33.7550, longitude: 44.8700),
      WaitingPoint(id: '8-3', name: 'الكراج الكبير', governorateId: '8', latitude: 33.7450, longitude: 44.8600),
    ],
    
    // الأنبار
    '9': [
      WaitingPoint(id: '9-1', name: 'الكراج العام', governorateId: '9', latitude: 33.4258, longitude: 43.3078),
      WaitingPoint(id: '9-2', name: 'شارع القادسية', governorateId: '9', latitude: 33.4300, longitude: 43.3100),
      WaitingPoint(id: '9-3', name: 'الجامعة', governorateId: '9', latitude: 33.4200, longitude: 43.3000),
    ],
    
    // بابل
    '10': [
      WaitingPoint(id: '10-1', name: 'ساحة الجمهورية', governorateId: '10', latitude: 32.4647, longitude: 44.4206),
      WaitingPoint(id: '10-2', name: 'شارع 40', governorateId: '10', latitude: 32.4700, longitude: 44.4250),
      WaitingPoint(id: '10-3', name: 'الكراج الكبير', governorateId: '10', latitude: 32.4600, longitude: 44.4150),
      WaitingPoint(id: '10-4', name: 'المجمع التجاري', governorateId: '10', latitude: 32.4650, longitude: 44.4200),
    ],
    
    // ذي قار
    '11': [
      WaitingPoint(id: '11-1', name: 'ساحة الحبوبي', governorateId: '11', latitude: 31.0500, longitude: 46.2667),
      WaitingPoint(id: '11-2', name: 'شارع الجامعة', governorateId: '11', latitude: 31.0550, longitude: 46.2700),
      WaitingPoint(id: '11-3', name: 'الكراج الكبير', governorateId: '11', latitude: 31.0450, longitude: 46.2600),
    ],
    
    // ميسان
    '12': [
      WaitingPoint(id: '12-1', name: 'ساحة الشهداء', governorateId: '12', latitude: 31.8333, longitude: 47.1333),
      WaitingPoint(id: '12-2', name: 'شارع الحرية', governorateId: '12', latitude: 31.8350, longitude: 47.1350),
      WaitingPoint(id: '12-3', name: 'الكراج العام', governorateId: '12', latitude: 31.8300, longitude: 47.1300),
    ],
    
    // القادسية
    '13': [
      WaitingPoint(id: '13-1', name: 'ساحة الساعة', governorateId: '13', latitude: 31.9931, longitude: 45.2608),
      WaitingPoint(id: '13-2', name: 'شارع النصر', governorateId: '13', latitude: 31.9950, longitude: 45.2650),
      WaitingPoint(id: '13-3', name: 'الكراج الرئيسي', governorateId: '13', latitude: 31.9900, longitude: 45.2550),
    ],
    
    // المثنى
    '14': [
      WaitingPoint(id: '14-1', name: 'ساحة الوثبة', governorateId: '14', latitude: 29.9700, longitude: 45.3000),
      WaitingPoint(id: '14-2', name: 'شارع الجمهورية', governorateId: '14', latitude: 29.9750, longitude: 45.3050),
      WaitingPoint(id: '14-3', name: 'الكراج العام', governorateId: '14', latitude: 29.9650, longitude: 45.2950),
    ],
    
    // واسط
    '15': [
      WaitingPoint(id: '15-1', name: 'ساحة الأحرار', governorateId: '15', latitude: 32.5008, longitude: 45.7630),
      WaitingPoint(id: '15-2', name: 'شارع الكورنيش', governorateId: '15', latitude: 32.5050, longitude: 45.7650),
      WaitingPoint(id: '15-3', name: 'الكراج الكبير', governorateId: '15', latitude: 32.4950, longitude: 45.7600),
    ],
    
    // صلاح الدين
    '16': [
      WaitingPoint(id: '16-1', name: 'ساحة القلعة', governorateId: '16', latitude: 34.6089, longitude: 43.6750),
      WaitingPoint(id: '16-2', name: 'شارع العروبة', governorateId: '16', latitude: 34.6100, longitude: 43.6800),
      WaitingPoint(id: '16-3', name: 'الكراج الرئيسي', governorateId: '16', latitude: 34.6050, longitude: 43.6700),
    ],
    
    // كركوك
    '17': [
      WaitingPoint(id: '17-1', name: 'القلعة', governorateId: '17', latitude: 35.4681, longitude: 44.3922),
      WaitingPoint(id: '17-2', name: 'شارع الجمهورية', governorateId: '17', latitude: 35.4700, longitude: 44.3950),
      WaitingPoint(id: '17-3', name: 'الكراج الدولي', governorateId: '17', latitude: 35.4650, longitude: 44.3900),
    ],
    
    // دهوك
    '18': [
      WaitingPoint(id: '18-1', name: 'دريم سيتي', governorateId: '18', latitude: 36.8600, longitude: 42.9900),
      WaitingPoint(id: '18-2', name: 'شارع زاخو', governorateId: '18', latitude: 36.8650, longitude: 42.9950),
      WaitingPoint(id: '18-3', name: 'الكراج الدولي', governorateId: '18', latitude: 36.8550, longitude: 42.9850),
    ],
  };

  // الحصول على نقاط الانتظار حسب المحافظة
  static List<WaitingPoint> getPointsByGovernorate(String governorateId) {
    return waitingPointsByGovernorate[governorateId] ?? [];
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WaitingPoint && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => name;
}
