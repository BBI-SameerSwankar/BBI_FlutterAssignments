abstract class NewsEvent {}

class FetchAllNewsEvent extends NewsEvent {
  final int page;
  final int pageSize;

  
  FetchAllNewsEvent({ this.page=1  ,  this.pageSize=20});
}
