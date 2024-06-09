import 'package:google_sign_in/google_sign_in.dart';

class GoogleSigninService {
  static final _googleSignIn = GoogleSignIn();

  // 登入
  static Future<GoogleSignInAccount?> login() {
    return _googleSignIn.signIn();
  }

  // 登出
  static Future<GoogleSignInAccount?> logout() {
    return _googleSignIn.disconnect();
  }

}