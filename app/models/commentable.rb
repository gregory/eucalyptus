class Commentable
  LIMIT_FEED = 100
  COMMENTABLE_STRATEGY = %w{links statuses checkins}
  attr_reader :graph, :uid, :type
  attr_accessor :content
    def initialize(graph, uid, type='feed')
      @graph = graph
      @uid = uid
      @type = type
    end
    class<<self
      def object(graph, uid, type, args={}, options={})
        only_comments = COMMENTABLE_STRATEGY.none? {|t| t == type} ? {} : {:fields => 'comments', :limit => LIMIT_FEED}
        graph.get_connections(uid, type.to_s, args.merge(only_comments), options)
      end
    end
    
    def content(obj=nil)
      @content ||= ( obj || object(type))
    end
    
    def comments
      commented_feeds.collect {|f| f['comments']['data']}
    end
  
    def commenters
      comments.flatten.map {|c| c['from']}
    end
    
    def sorted_commenters
      @sorted_commenters ||= commenters.sort_by {|l| l['id']}.flatten.group_by {|l| l['id']}.sort
    end
    
    def ranked_commenters
      sorted_commenters.inject({}) {|accu, i| accu.merge({i.first => {:name => i.last.first['name'], :count => i.last.count}})}
    end
    
  protected
    def commented_feeds
      @commented_feeds ||= content.keep_if {|f| f['comments'].present?}
    end
  private
    def object(type, args={}, options={})
      Commentable::object(graph, uid,type, args, options)
    end
end