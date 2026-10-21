class AuthTokenHolder {
  String? accessToken;
  void Function()? onUnauthorized;

  void notifyUnauthorized() {
    onUnauthorized?.call();
  }
}
