import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied()
abstract class Env {

  @EnviedField(varName: 'JNJ_API_URL')
  static const String JNJ_API_URL = _Env.JNJ_API_URL;
}
