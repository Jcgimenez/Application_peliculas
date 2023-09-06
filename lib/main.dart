import 'package:flutter/material.dart';
import 'package:flutter_application_peliculas/providers/movies_providers.dart';
import 'package:provider/provider.dart';
import 'screens/screens.dart';


void main() => runApp(AppState());


class AppState extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => MoviesProvider(), lazy: false, )

      ],
      child: MyApp(),
    );
  }
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peliculas',
      initialRoute: 'home',
      routes: {
        'home': ( _ ) => HomeScreen(),
        'details': ( _ ) => DetailsScreen(),
      },
      theme: ThemeData.light().copyWith(
        appBarTheme:const AppBarTheme(
          color: Colors.indigo
        ),
      ),
      
    );
  }
}