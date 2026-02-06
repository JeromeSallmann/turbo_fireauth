class GoogleSigninConfig {
  final GoogleSigninOption option;
  final String? hostedDomain;
  final String clientId;
  final String serverClientId;

  GoogleSigninConfig({
    required this.option,
    this.hostedDomain,
    required this.clientId,
    required this.serverClientId,
  });
}

enum GoogleSigninOption { standard, game }
