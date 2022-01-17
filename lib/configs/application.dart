import 'package:listar_flutter_pro/models/model.dart';
import 'package:listar_flutter_pro/utils/other.dart';

class Application {
  static const bool debug = false;
  static const String version = '1.1.3';
  static const String domain = 'https://listarapp.com/index.php/wp-json';
  static const String googleAPI = 'AIzaSyAGHlk0PoZ-BdSwUJh_HGSHXWKlARE4Pt8';
  static DeviceModel? device;

  static Future<void> setDevice() async {
    device = await UtilOther.getDeviceInfo();
  }

  static Future<void> setDeviceToken() async {
    device!.token = await UtilOther.getDeviceToken();
  }

  ///Singleton factorynote
  static final Application _instance = Application._internal();

  factory Application() {
    return _instance;
  }

  Application._internal();
}
