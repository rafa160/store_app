class PatternAddress {
  String street;
  String number;
  String complement;
  String district;
  String zipCode;
  String state;
  String city;

  double latitude;
  double longitude;

  PatternAddress(
      {this.street,
      this.number,
      this.complement,
      this.district,
      this.zipCode,
      this.state,
      this.city,
      this.latitude,
      this.longitude});

  Map<String, dynamic> toMap() {
    return {
      'street': street,
      'number': number,
      'complement': complement,
      'district': district,
      'zipCode': zipCode,
      'state': state,
      'lat': latitude,
      'long': longitude,
      'city': city
    };
  }

  PatternAddress.fromMap(Map<String, dynamic> map) {
    street = map['street'] as String;
    number = map['number'] as String;
    complement = map['complement'] as String;
    district = map['district'] as String;
    zipCode = map['zipCode'] as String;
    state = map['state'] as String;
    latitude = map['lat'] as double;
    longitude = map['long'] as double;
    city = map['city'] as String;
  }

  @override
  String toString() {
    return 'PatternAddress{street: $street, number: $number, complement: $complement, district: $district, zipCode: $zipCode, state: $state, city: $city, latitude: $latitude, longitude: $longitude}';
  }
}
