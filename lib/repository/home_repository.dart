import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/home_model.dart';

class HomeRepository {
  static const homesPrefsString = 'homes';

  void setHomes(List<HomeModel> homes) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove(homesPrefsString);
      prefs.setStringList(homesPrefsString, [
        ...homes.map(
          (home) => json.encode(home),
        ),
      ]);
    });
  }

  Future<List<HomeModel>> fetchHomes() async {
    final List<HomeModel> homes = [];
    final prefs = await SharedPreferences.getInstance();

    try {
      final stringList = prefs.getStringList(homesPrefsString);

      if (stringList != null) {
        for (var element in stringList) {
          final data = json.decode(element);
          final home = HomeModel.fromJson(data);
          homes.add(home);
        }
      }
    } catch (error) {
      print('Fetch error: $error');
    }

    return homes;
  }

  void addHome(HomeModel home) {
    fetchHomes().then((homes) {
      homes.add(home);
      setHomes(homes);
    });
  }

  void deleteHome(HomeModel deletedHome) {
    fetchHomes().then((homes) {
      for (var home in homes) {
        if (home.equals(deletedHome)) {
          homes.remove(home);
          break;
        }
      }
      setHomes(homes);
    });
  }

  void toggleHomeStatus(String homeName) {
    fetchHomes().then((homes) {
      for (var home in homes) {
        if (home.name == homeName) {
          home.isLocked = !home.isLocked;
          break;
        }
      }
      setHomes(homes);
    });
  }
}
