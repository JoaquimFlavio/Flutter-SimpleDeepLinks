# Flutter Deep Links com UniLink


Por muitas vezes é necessario que possamos acessar e trocar informações com aplicativos por meio de emails, mensagens ou web-sites, devido a praticidade de que um clique envie todas as informações para o APP. Para isso podemos utilizar o recurso de Deep-links para permitir que o app responda a urls que forem executadas dentro do aparelho.

Durante as pesquisas para este artigo, foram constatadas algumas soluções possiveis:

- [flutter_branch_sdk](https://pub.dev/packages/flutter_branch_sdk?fbclid=IwAR10CmFLg7PRC5bbwgbaDb9tv3X_u0ytc2CurjdV2LMaA6318KsPec8C95Q#-readme-tab-)
- [firebase_dnamic_links](https://pub.dev/packages/firebase_dynamic_links)
- [uni_links](https://pub.dev/packages/uni_links)
- Fazer do zero

Dentre as alternativas, as 2 primeiras não se mostraram interessantes quando o interesse é apenas abrir o link no APP, pois será necessário mais um serviço de cloud para gerenciar os links. Entretanto se montram muito interessantes para gerir links que interagem com diversas plataformas de forma sincrona. Nas demais elas cumprem o proposito de permitir que ao executar um link no aparelho o APP seja invocado. No entanto, a utilização de um plugin poupa bastante tempo durante construção de prototipos, por tanto, nesse artigo abordaremos a utilização do plugin [uni_links](https://pub.dev/packages/uni_links).



## Introdução a deep links

Existem dois tipos de links executaveis dentro dos aparelhos celulares:

**Universais**: Links padrões utilizados na propria WEB (https://google.com) e proporcionam uma experienciam mais completa para o APP, permitindo mais funcionalidades como compartilhamento do link em texto plano (por aplicativos de mensagens: watsapp, messager, telegram...) e permitem que caso o APP não esteja instalado, o usuario seja direcionado para a pagina de dowload.

**Customizados**: Aqui teremos links personalizados que somente serão executados no APP ao qual foi projetado. Entretanto não é possivel compartilhamento em texto plano e não será util fora do APP.

A escolha de um ou outro vai depender de qual finalidade terá esta funcionalidade. Como recomendação, caso o intuito seja apenas receber informações de uma pagina web ou email, os links customizados servirão muito bem. Caso tenha muitas operações envolvendo interações e compartilhamento por usuarios a utilização de links universais é mais adequada. 
Neste artigo abordaremos apenas a utilização de links customizados.



## Instalação

Conforme a documentação do [plugin](https://pub.dev/packages/uni_links), é necessario primeiramente, adicionar as permissões das plataformas nativas. Para isso:

### Android

`android/app/src/main/AndroidManifest.xml`

```xml
<manifest ...>
  <application ...>
    <activity ...>
      <!-- Deep Links -->
      <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <!-- Accepts URIs that begin with YOUR_SCHEME://YOUR_HOST -->
        <data
          android:scheme="[YOUR_SCHEME]"
          android:host="[YOUR_HOST]" />
      </intent-filter>
    </activity>
  </application>
</manifest>
```

### IOS

```xml
<?xml ...>
<plist>
<dict>
  <key>CFBundleURLTypes</key>
  <array>
    <dict>
      <key>CFBundleTypeRole</key>
      <string>Editor</string>
      <key>CFBundleURLName</key>
      <string>[ANY_URL_NAME]</string>
      <key>CFBundleURLSchemes</key>
      <array>
        <string>[YOUR_SCHEME]</string>
      </array>
    </dict>
  </array>
</dict>
</plist>
```


Feito isso basta adicionarmos a dependecia do plugin em `pubspec.yaml`:

```yml
uni_links: ^0.4.0
```



## Testes de deep link

Provavelmente estrá executando os testes em um emulador, e para facilitar o trabalho, existe uma forma de simular a execução dos links via terminal. Para isso:

> Comando executados no Mac OS

**Android**

```shell
Users/SEU_USUAIO/Library/Android/sdk/platform-tools/adb shell 'am start -W -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d "YOUR_SCHEME://YOUR_HOST/..."'
```

**IOS**

```shell
/usr/bin/xcrun simctl openurl A8665EAA-A7B3-41C2-8802-2CBC83AD74CA "YOUR_SCHEME://YOUR_HOST/..."
```





###### Referencias e materiais de estudo

[Deep Links and Flutter applications. How to handle them properly](https://medium.com/flutter-community/deep-links-and-flutter-applications-how-to-handle-them-properly-8c9865af9283)

[uni_links](https://pub.dev/packages/uni_links)

[flutter_branch_sdk](https://pub.dev/packages/flutter_branch_sdk?fbclid=IwAR10CmFLg7PRC5bbwgbaDb9tv3X_u0ytc2CurjdV2LMaA6318KsPec8C95Q#-readme-tab-)

[firebase_dnamic_links](https://pub.dev/packages/firebase_dynamic_links)