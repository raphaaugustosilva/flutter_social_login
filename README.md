# flutter_social_login

Projeto que implementa Social Login utilizando Flutter, com as opções de Login com Google ,com Facebook e com criação de usuário no Firebase (incluindo login e reset de senha)

## Implementando Firebase no Flutter
É necessário criar um projeto no Firebase e habilitar o Authentication dentro dele depois de criado.

- [Tutorial para plugar Firebase no Flutter](https://firebase.google.com/docs/flutter/setup?hl=pt-br#add_flutterfire_plugins)

## Facebook
É necessário ter uma conta de desenvolvedor do Facebook e criar uma aplicação.
Após isso, tem que dentro do Facebook configurar o ambiente para Android e iOS.
- [Plugin flutter_facebook_login](https://pub.dev/packages/flutter_facebook_login)
- [Tutorial completo detalhado](https://www.c-sharpcorner.com/article/facebook-login-in-flutter/)
- [Configurar ambiente do Facebook para Android](https://developers.facebook.com/docs/facebook-login/android)
- [Configurar ambiente do Facebook para iOS](https://developers.facebook.com/docs/facebook-login/ios)
  - Pular "Step 2: Set up Your Development Environment" e "Step 5: Connect Your App Delegate"

## Google
- [Plugin google_sign_in](https://pub.dev/packages/google_sign_in)



OBS: Para iOS, alterar o Info.plist e incluir para funcionar social login de Facebook e Google:
```xml
    <!-- Bloco para funcinar o Facebook Sign-in -->
	<key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>[SEU CFBundleURLSchemes]. Exemplo: fb383401415272755</string>
			</array>
		</dict>
	</array>
	<key>FacebookAppID</key>
	<string>[SEU FacebookAppID]. Exemplo: 383407415872411</string>
	<key>FacebookDisplayName</key>
	<string>[SEU FacebookDisplayName]. Exemplo: Flutter Social Login Teste</string>
	<key>LSApplicationQueriesSchemes</key>
	<array>
		<string>fbapi</string>
		<string>fb-messenger-share-api</string>
		<string>fbauth2</string>
		<string>fbshareextension</string>
	</array>
	<!-- Fim Bloco para funcinar o Facebook Sign-in -->

	<!-- Bloco para funcinar o Google Sign-in -->
	<key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<!-- Copiado da chave REVERSED_CLIENT_ID do arquivo GoogleServices-Info.plist -->
				<string>com.googleusercontent.apps.642841476290-aueiai2uoi4klejaklj3lkj3lk</string>
			</array>
		</dict>
	</array>
	<!-- Fim Bloco para funcinar o Google Sign-in -->
```