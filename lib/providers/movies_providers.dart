import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_peliculas/helpers/debouncer.dart';
import 'package:flutter_application_peliculas/models/search_response.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_peliculas/models/models.dart';

class MoviesProvider extends ChangeNotifier{

  String _apiKey   = 'c4fe60b2c7df1972eb557b4d998997db';
  String _baseUrl  = 'api.themoviedb.org';
  String _language = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];

  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;

  final debouncer = Debouncer(
    duration: Duration(milliseconds: 0),
  );

  final StreamController<List<Movie>> _suggestionStreamController = new StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => this._suggestionStreamController.stream;


  MoviesProvider() {
    print('MoviesProvider inicializado');

    this.getOnDisplayMovies();
    this.getPopularMovies();
  }


  Future <String> _getJsonData(String endpoint, [int page=1]) async{
    final url = Uri.https(this._baseUrl,  endpoint, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page',
    });

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    return response.body;
  }


  getOnDisplayMovies() async {
    final jsonData = await this._getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);

    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();

  }

  getPopularMovies() async {
    _popularPage++;

    

    final jsonData = await this._getJsonData('3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromJson(jsonData);

    popularMovies = [...popularMovies, ...popularResponse.results];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast( int movieId) async{

    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;
    

    final jsonData = await this._getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);

    moviesCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;

  }

  Future<List<Movie>> searchMovie(String query) async{

    final url = Uri.https(this._baseUrl,  '3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'quey': query,
    });

    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);

    return searchResponse.results;
  }

  void getSuggestionsByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      
      final results = await this.searchMovie(value);
      this._suggestionStreamController.add(results);
    };

    final timer = Timer.periodic(Duration(milliseconds: 300), (_) { 
      debouncer.value = searchTerm;
    });

    Future.delayed(Duration(milliseconds: 301)).then((_)=>timer.cancel());

  }


}