import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  static const _authKey = 'isAuthenticated';

  const AuthRepository();

  static const List<String> municipalities = [
    'Tagum City',
    'Panabo City',
    'Island Garden City of Samal',
    'Carmen',
    'Sto. Tomas',
    'Asuncion',
    'Kapalong',
    'Talaingod',
    'New Corella',
    'San Isidro',
    'Braulio E. Dujali',
  ];

  static const Map<String, List<String>> barangaysByMunicipality = {
    'Tagum City': [
      'Mankilam',
      'Magugpo East',
      'Magugpo West',
      'Visayan Village',
      'Apokon',
      'Canocotan',
      'San Miguel',
      'Pandapan',
      'La Filipina',
    ],
    'Panabo City': [
      'San Francisco',
      'San Vicente',
      'Cagangohan',
      'Gredu',
      'New Pandan',
      'Salvacion',
    ],
    'Island Garden City of Samal': [
      'Penaplata',
      'Peñaplata Proper',
      'Babak',
      'Caliclic',
      'Kaputian',
      'Tambo',
    ],
    'Carmen': ['Alejal', 'Calasakan', 'Mabaus', 'Tubod'],
    'Sto. Tomas': ['Balagunan', 'Kimamon', 'Salaysay', 'Tomongon'],
    'Asuncion': ['Binancian', 'Cabaywa', 'Camansa', 'Canatan'],
    'Kapalong': ['Capungagan', 'Florida', 'Gupitan', 'Maniki'],
    'Talaingod': ['Dagohoy', 'Sto. Niño', 'Tibao'],
    'New Corella': ['Del Pilar', 'El Salvador', 'Mambing', 'Sta. Cruz'],
    'San Isidro': ['Dacudao', 'Datu Balong', 'Iba'],
    'Braulio E. Dujali': ['Cabayangan', 'Dangca-an', 'New Casay'],
  };

  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_authKey) ?? false;
  }

  Future<void> setAuthenticated(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_authKey, value);
  }
}
