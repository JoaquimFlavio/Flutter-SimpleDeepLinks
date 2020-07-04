import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException;

StreamSubscription sub;

// Chave global para roteamento sem o context.
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  Future<Null> initUniLinks() async {
    try {
      /// Primeiro tentamos obter o link que inicializou o APP.
      String initialLink = await getInitialLink();
      print("App inicializado por: ${initialLink}");

      /// Agora criamos um stream para receber os link enquanto o APP estiver aberto.
      sub = getUriLinksStream().listen((Uri uri) {
        print("App recebeu: ${uri.toString()}");

        print(uri.pathSegments.toString());
        print(uri.queryParameters.toString());

      }, onError: (err) {
        print(err);
      });

      if(initialLink != null){
        tratarDeepLink(initialLink);
      }
    } on PlatformException {

    }
  }

  begin() async {
    await initUniLinks();
    sub.onData((handleData) => tratarDeepLink(handleData.toString()));
  }

  tratarDeepLink(String handleData){
    Uri uri = Uri.dataFromString(handleData);

    print(uri.pathSegments.toString());
    print(uri.queryParameters.toString());

    switch(uri.pathSegments[3]){
      case "page1":
        navigatorKey.currentState.pushNamed('/page1', arguments: handleData);
      break;
      case "page2":
        navigatorKey.currentState.pushNamed('/page2', arguments: handleData);
      break;
      default:
        navigatorKey.currentState.pushNamed('/notfound', arguments: handleData);
    }
  }

  @override
  Widget build(BuildContext context){
    begin();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      navigatorKey: navigatorKey,
      initialRoute: '/page1',
      routes: {
        '/page1': (context) => Page1(argument: ModalRoute.of(context).settings.arguments,),
        '/page2': (context) => Page2(argument: ModalRoute.of(context).settings.arguments,),
        '/notfound': (context) => NotFoundPage(argument: ModalRoute.of(context).settings.arguments,),
      },
    );
  }
}

class Page1 extends StatelessWidget {
  final argument;

  Page1({this.argument});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page 1"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              this.argument.toString()
            ),
            Text(
              "Bem vindo a pagina 1",
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  final argument;

  Page2({this.argument});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page 2"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
                this.argument.toString()
            ),
            Text(
              "Bem vindo a pagina 2",
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      )
    );
  }
}

class NotFoundPage extends StatelessWidget {
  final argument;

  NotFoundPage({this.argument});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Pagina não encontrada"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                  this.argument.toString()
              ),
              Text(
                "Pagina não encontrada",
                style: Theme.of(context).textTheme.display1,
              ),
            ],
          ),
        )
    );
  }
}
