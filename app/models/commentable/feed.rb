class Commentable::Feed < Commentable
    def comments
      commented_feeds.collect do |f| 
        (f['comments']['data'].count > f['comments']['count']) ? f['comments']['data'] : graph.get_object(f['id'])['comments']['data']
      end
    end
  protected
    def commented_feeds
      @commented_feeds ||= content
        .keep_if {|f| COMMENTABLE_STRATEGY.none? {|k| k == f['type']} }
        .keep_if {|f| f['comments']['count'] > 0}
    end
    
end