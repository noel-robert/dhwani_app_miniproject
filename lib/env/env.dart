import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'HF_ACCESS_TOKEN')
  static String hfApiKey = _Env.hfApiKey;
}
