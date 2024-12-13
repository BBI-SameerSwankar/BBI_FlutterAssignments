
import 'package:flutter_dotenv/flutter_dotenv.dart';

class APIConstants {
  static const BASEURL = 'https://newsapi.org/v2/everything';
  static int NEWS_PAGE_LIMIT = 5;


  static void setNewsPageLimit(int limit)
  {
    NEWS_PAGE_LIMIT = limit;
  }
}


