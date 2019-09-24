class SocialLoginException implements Exception {
  String codigoErro;
  String mensagemErro;
  SocialLoginException({this.codigoErro, this.mensagemErro});
}