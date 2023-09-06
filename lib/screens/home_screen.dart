import 'package:flutter/material.dart';
import 'package:flutter_application_peliculas/providers/movies_providers.dart';
import 'package:flutter_application_peliculas/search/search_delegate.dart';
import 'package:flutter_application_peliculas/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {

  
  

  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context);

    print(moviesProvider.onDisplayMovies );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peliculas en cines'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => showSearch(context: context, delegate: MovieSearchDelegate()),
            icon: const Icon(Icons.search_outlined),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            CardSwiper( movies: moviesProvider.onDisplayMovies,),

            MovieSlider( 
              movies: moviesProvider.popularMovies,
              title: 'Populares!',
              onNextPage: () => moviesProvider.getPopularMovies(),
            
            ),
          ],
        ),
      )
    );
  }
}