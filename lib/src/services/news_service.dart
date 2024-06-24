import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newsapp/src/models/category_model.dart';
import 'package:newsapp/src/models/news_models.dart';
import 'package:http/http.dart' as http;

final _URL_NEWS = 'https://newsapi.org/v2';
final _APIKEY = '454a327c0a9f45439e9a8baf88967487';

class NewsService with ChangeNotifier {
  final List<Article> headlines = [];
  String _selectedCategory = 'business';

  bool _isLoading = true;

  final List<Category> categories = [
    Category(FontAwesomeIcons.building, 'business'),
    Category(FontAwesomeIcons.tv, 'entertainment'),
    Category(FontAwesomeIcons.addressCard, 'general'),
    Category(FontAwesomeIcons.headSideVirus, 'health'),
    Category(FontAwesomeIcons.vials, 'science'),
    Category(FontAwesomeIcons.volleyball, 'sports'),
    Category(FontAwesomeIcons.memory, 'technology')
  ];

  Map<String, List<Article>> categoryArticles = {};

  NewsService() {
    getTopHeadlines();

    categories.forEach((item) {
      categoryArticles[item.name] = [];
    });
  }

  bool get isLoading => _isLoading;

  String get selectedCategory => _selectedCategory;
  set selectedCategory(String valor) {
    _selectedCategory = valor;

    _isLoading = true;

    getArticlesByCategory(valor);
    notifyListeners();
  }

  List<Article>? get getArticulosCategoriaSeleccionada =>
      categoryArticles[selectedCategory];

  getTopHeadlines() async {
    final url = '$_URL_NEWS/top-headlines?apiKey=$_APIKEY&country=us';
    final resp = await http.get(Uri.parse(url));

    final newsResponse = newsResponseFromJson(resp.body);

    headlines.addAll(newsResponse.articles ?? []);
    notifyListeners();
  }

  getArticlesByCategory(String category) async {
    if ((categoryArticles[category]?.length ?? 0) > 0) {
      this._isLoading = false;
      notifyListeners();
      return categoryArticles[category];
    }

    final url =
        '$_URL_NEWS/top-headlines?apiKey=$_APIKEY&country=us&category=$category';
    final resp = await http.get(Uri.parse(url));

    final newsResponse = newsResponseFromJson(resp.body);
    categoryArticles[category]!.addAll(newsResponse.articles ?? []);

    _isLoading = false;
    notifyListeners();
  }
}
