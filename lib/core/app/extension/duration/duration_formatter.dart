import 'package:playly/res/index.dart';

extension MediaQueryExt on Duration {
  String toMMSS() {
    int secInt = (inSeconds % nk60).toInt();
    String secStr = secInt.toString().padLeft(2, '0');
    return "$inMinutes:$secStr";
  }
}
