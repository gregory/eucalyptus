class User
  attr_reader :uid, :token
  MY_FRIENDS_ID = 'SELECT uid2 FROM friend WHERE uid1=me()'
  delegate :content, :comments, :to => :feed, :prefix => true
  
    def initialize(oauth_access_token, uid)
      @token = oauth_access_token
      @uid = uid
    end
  
    def friend(fid)
      @friend ||= User.new(token, fid)
    end
  
    def feed(batchman=nil)
      @feed ||= Commentable::Feed.new(batchman || graph, uid)
    end
  
    def ranked_commenters
      global_action(:ranked_commenters)
    end
    
    def commenters
      global_action(:commenters)
    end
  
    def info(uid=nil)
      return api.get_object(uid || self.uid) unless uid == self.uid
      @info ||= api.get_object(uid || self.uid)
    end
  
    def friends(args={}, options={})
      api.fql_query(query_users_where_ids(query_my_friends_ids))
    end
  
  protected
  
    def graph
      @graph ||= Koala::Facebook::GraphAPI.new(token)
    end
    
    def api
      @api ||= Koala::Facebook::API.new(token)
    end
    
    def global_action_with_batch(action)
      raise "InternalError:: Unknown action on commentable object" unless Commentable.new(graph, uid).respond_to? action
      #rank the feed commenters
      commentable_object = Commentable::Feed.new(graph, uid)
      contents = commentable_contents.clone
      commentable_object.content = contents.shift
      feed_ranked_commenters = {}.merge!(commentable_object.send(action))
      
      #rank the commenters for specific types
      contents.each_with_index do |commentable_content, i|
        commentable_object = Commentable.new(graph, uid, Commentable::COMMENTABLE_STRATEGY[i])
        commentable_object.content = commentable_content
        feed_ranked_commenters.merge!(commentable_object.send(action)) {|k, old, neuw| {:name => old[:name], :count => (old[:count] + neuw[:count])}}
      end
      feed_ranked_commenters
    end
    
    def global_action(action)
      raise "InternalError:: Unknown action on commentable object" unless Commentable.new(graph, uid).respond_to? action
      feed_ranked_commenters = {}.merge!(Commentable::Feed.new(graph, uid).send(action))
      Commentable::COMMENTABLE_STRATEGY.each do |type|
        feed_ranked_commenters.merge!(Commentable.new(graph, uid, type).send(action)) {|k, old, neuw| {:name => old[:name], :count => (old[:count] + neuw[:count])}}
      end
    end
    alias_method_chain :global_action, :batch
    
  private
  
begin 'queries'
    def query_friends_ids_of(uid)
        "SELECT uid2 FROM friend WHERE uid1=#{uid}"
    end
    
    def query_my_friends_ids
        query_friends_ids_of('me()')
    end
    
    def query_users_where_ids(ids)
      "SELECT uid, name FROM user WHERE uid IN (#{ids})"
    end
end    

    def commentable_contents
      @commentable_contents ||= graph.batch do |batchman|
        Commentable::object(batchman, uid, 'feed')
        Commentable::COMMENTABLE_STRATEGY.each do |type|
          Commentable::object(batchman, uid, type)
        end
      end
    end
end
