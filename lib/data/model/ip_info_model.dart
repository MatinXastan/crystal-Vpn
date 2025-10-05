class IpInfoModel {
  final int? asNumber;
  final String? ispName;
  final String? countryCode;
  final String? countryName;
  final String? regionCode;
  final String? regionName;
  final String? continentCode;
  final String? continentName;
  final String? cityName;
  final String? postalCode;
  final int? postalConfidence;
  final double? latitude;
  final double? longitude;
  final int? accuracyRadius;
  final String? timeZone;
  final String? metroCode;
  final String? level;
  final int? cache;
  final String? ip;
  final String? reverse;
  final String? queryText;
  final String? queryType;
  final int? queryDate;

  IpInfoModel({
    this.asNumber,
    this.ispName,
    this.countryCode,
    this.countryName,
    this.regionCode,
    this.regionName,
    this.continentCode,
    this.continentName,
    this.cityName,
    this.postalCode,
    this.postalConfidence,
    this.latitude,
    this.longitude,
    this.accuracyRadius,
    this.timeZone,
    this.metroCode,
    this.level,
    this.cache,
    this.ip,
    this.reverse,
    this.queryText,
    this.queryType,
    this.queryDate,
  });

  factory IpInfoModel.fromJson(Map<String, dynamic> json) => IpInfoModel(
    asNumber: json['as_number'] as int?,
    ispName: json['isp_name'] as String?,
    countryCode: json['country_code'] as String?,
    countryName: json['country_name'] as String?,
    regionCode: json['region_code'] as String?,
    regionName: json['region_name'] as String?,
    continentCode: json['continent_code'] as String?,
    continentName: json['continent_name'] as String?,
    cityName: json['city_name'] as String?,
    postalCode: json['postal_code'] as String?,
    postalConfidence: json['postal_confidence'] is int
        ? json['postal_confidence'] as int?
        : (json['postal_confidence'] == null
              ? null
              : int.tryParse(json['postal_confidence'].toString())),
    latitude: (json['latitude'] != null)
        ? (json['latitude'] as num).toDouble()
        : null,
    longitude: (json['longitude'] != null)
        ? (json['longitude'] as num).toDouble()
        : null,
    accuracyRadius: json['accuracy_radius'] is int
        ? json['accuracy_radius'] as int?
        : (json['accuracy_radius'] == null
              ? null
              : int.tryParse(json['accuracy_radius'].toString())),
    timeZone: json['time_zone'] as String?,
    metroCode: json['metro_code'] as String?,
    level: json['level'] as String?,
    cache: json['cache'] is int
        ? json['cache'] as int?
        : (json['cache'] == null
              ? null
              : int.tryParse(json['cache'].toString())),
    ip: json['ip'] as String?,
    reverse: json['reverse'] as String?,
    queryText: json['query_text'] as String?,
    queryType: json['query_type'] as String?,
    queryDate: json['query_date'] is int
        ? json['query_date'] as int?
        : (json['query_date'] == null
              ? null
              : int.tryParse(json['query_date'].toString())),
  );

  Map<String, dynamic> toJson() => {
    'as_number': asNumber,
    'isp_name': ispName,
    'country_code': countryCode,
    'country_name': countryName,
    'region_code': regionCode,
    'region_name': regionName,
    'continent_code': continentCode,
    'continent_name': continentName,
    'city_name': cityName,
    'postal_code': postalCode,
    'postal_confidence': postalConfidence,
    'latitude': latitude,
    'longitude': longitude,
    'accuracy_radius': accuracyRadius,
    'time_zone': timeZone,
    'metro_code': metroCode,
    'level': level,
    'cache': cache,
    'ip': ip,
    'reverse': reverse,
    'query_text': queryText,
    'query_type': queryType,
    'query_date': queryDate,
  };

  IpInfoModel copyWith({
    int? asNumber,
    String? ispName,
    String? countryCode,
    String? countryName,
    String? regionCode,
    String? regionName,
    String? continentCode,
    String? continentName,
    String? cityName,
    String? postalCode,
    int? postalConfidence,
    double? latitude,
    double? longitude,
    int? accuracyRadius,
    String? timeZone,
    String? metroCode,
    String? level,
    int? cache,
    String? ip,
    String? reverse,
    String? queryText,
    String? queryType,
    int? queryDate,
  }) {
    return IpInfoModel(
      asNumber: asNumber ?? this.asNumber,
      ispName: ispName ?? this.ispName,
      countryCode: countryCode ?? this.countryCode,
      countryName: countryName ?? this.countryName,
      regionCode: regionCode ?? this.regionCode,
      regionName: regionName ?? this.regionName,
      continentCode: continentCode ?? this.continentCode,
      continentName: continentName ?? this.continentName,
      cityName: cityName ?? this.cityName,
      postalCode: postalCode ?? this.postalCode,
      postalConfidence: postalConfidence ?? this.postalConfidence,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracyRadius: accuracyRadius ?? this.accuracyRadius,
      timeZone: timeZone ?? this.timeZone,
      metroCode: metroCode ?? this.metroCode,
      level: level ?? this.level,
      cache: cache ?? this.cache,
      ip: ip ?? this.ip,
      reverse: reverse ?? this.reverse,
      queryText: queryText ?? this.queryText,
      queryType: queryType ?? this.queryType,
      queryDate: queryDate ?? this.queryDate,
    );
  }

  @override
  String toString() {
    return 'IpInfo(ip: $ip, country: $countryName, city: $cityName, isp: $ispName, latitude: $latitude, longitude: $longitude)';
  }
}
