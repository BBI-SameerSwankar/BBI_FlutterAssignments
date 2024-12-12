abstract class NewsEvent {}

class FetchAllNewsEvent extends NewsEvent {
  final int page;
  final int pageSize;
  final String query;

  
  FetchAllNewsEvent({ this.page=1  ,  this.pageSize=10, this.query = "latest"});
}
