class User
  attr_reader :uid, :graph
  
  def initialize(graph, uid)
    @graph = graph
    @uid = uid
  end
  
  def friend(fid)
    @friend ||= User.new(graph, fid)
  end
  
  def feed(batchman=nil)
    @feed ||= Commentable::Feed.new(batchman || graph, uid)
  end
  
  def feed_content
    feed.content
  end
  def ranked_commenters
    commentable_objects = 
    graph.batch do |batchman|
      Commentable::COMMENTABLE_STRATEGY.each do |type|
        Commentable::object(uid, batchman, type)
      end
    end
  end
  
  def ranked_commenters_without_batch
    feed_ranked_commenters = {}
    Commentable::COMMENTABLE_STRATEGY.each do |type|
      feed_ranked_commenters.merge!(Commentable.new(graph, uid, type).ranked_commenters) {|k, old, neuw| {:name => old[:name], :count => (old[:count] + neuw[:count])}}
    end
    feed_ranked_commenters.sort_by {|k,v| v['count']}.sort
  end
  
  def link_commenters
    Commentable.new(graph, uid, 'links').commenters
  end
  
  def display(uid=nil)
    graph.get_object(uid || self.uid)
  end
  
  def friends(args={}, options={})
    data = graph.get_connections(uid, 'friends', args, options)
  end
end
