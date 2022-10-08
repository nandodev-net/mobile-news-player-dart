import 'package:flutter/material.dart';
import 'package:noticias_sin_filtro/entities/news.dart';
import 'package:noticias_sin_filtro/views/custom_indicators/custom_first_page_error_indicator.dart';
import 'package:noticias_sin_filtro/views/custom_indicators/custom_new_page_error_indicator.dart';
import 'package:noticias_sin_filtro/views/custom_indicators/custom_no_items_found_indicator.dart';
import 'package:noticias_sin_filtro/views/list_items/news_list_item.dart';
import 'package:noticias_sin_filtro/services/requests/get_news.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:noticias_sin_filtro/mappers/news_mapper.dart';

// TODO: handle query params
class NewsList extends StatefulWidget {
  const NewsList({
    Key? key,
    required this.port,
    required this.showNewsAppBar,
    this.category,
    this.site
  }) : super(key: key);
  final String port;
  final bool showNewsAppBar;
  final String? category;
  final String? site;

  @override
  _newsListState createState() => _newsListState();
}

class _newsListState extends State<NewsList> {

  List<News> _newsList = [];
  static const _newsPageSize = 20;

  final PagingController<int, News> _pagingController =
  PagingController(firstPageKey: 1, invisibleItemsThreshold: 5);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }


  Future<void> _fetchPage(int pageKey) async {
    try{

       print('Fetching page '+pageKey.toString());
       final NewsRequestMapper newsRequestMapper = await getNews(widget.port, widget.category,widget.site,pageKey,_newsPageSize);
       final List<News> newNews = newsRequestMapper.results;

       print('hello');
       final isLastPage = newsRequestMapper.totalPages == pageKey;
       if (isLastPage) {
         _pagingController.appendLastPage(newNews);
       } else {
         final nextPageKey = pageKey + 1;
         print('Next page '+ nextPageKey.toString());
         _pagingController.appendPage(newNews, nextPageKey);
       }

    } catch (e) {
      print("error in infinite scrolling --> $e");
      _pagingController.error = e;
    }
  }


  @override
  Widget build(BuildContext context) {

    if(widget.port == "") {
      return const  Center(
        child: CircularProgressIndicator(),
      );
    }

    // if port exists
    return Navigator(
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              return
                  RefreshIndicator(
                    onRefresh: () => Future.sync(() => _pagingController.refresh()),
                    child:
                    PagedListView<int?, News>(
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate<News>(
                                      itemBuilder: (context, item, index) =>
                                         NewsListItem(
                                            news: item,
                                            port: widget.port,
                                            showNewsAppBar: widget.showNewsAppBar,
                                          ),
                                        firstPageErrorIndicatorBuilder: (_) => CustomFirstPageErrorIndicator(
                                          onTryAgain: () => _pagingController.refresh(),
                                        ),
                                        newPageErrorIndicatorBuilder: (_) => CustomNewPageErrorIndicator(
                                          onTap: () => _pagingController.retryLastFailedRequest(),
                                        ),
                                        noItemsFoundIndicatorBuilder: (_) => CustomNoItemsFoundIndicator(),
                                      ),
                  )
                );
            }
          );
        }
    );




  }
}
