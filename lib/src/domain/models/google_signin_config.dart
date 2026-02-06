class GoogleSigninConfig {
  final GoogleSigninOption option;
  final List<String> scopes;
  final String? hostedDomain;
  final String clientId;
  final String serverClientId;
  final bool forceCodeForRefreshToken;
  final String? forceAccountName;

  GoogleSigninConfig({
    required this.option,
    required this.scopes,
    this.hostedDomain,
    required this.clientId,
    required this.serverClientId,
    required this.forceCodeForRefreshToken,
    this.forceAccountName,
  });
}

enum GoogleSigninOption { standard, game }
