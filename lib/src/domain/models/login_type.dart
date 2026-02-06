abstract class LoginType {}

class GoogleLogin extends LoginType {}
class FacebookLogin extends LoginType {}
class TwitterLogin extends LoginType {}
class AppleLogin extends LoginType {}
class YahooLogin extends LoginType {}

class EmailLogin extends LoginType {
  final String email;
  final String password;

  EmailLogin(this.email, this.password);
}

class EmailCreate extends LoginType {
  final String email;
  final String password;

  EmailCreate(this.email, this.password);
}