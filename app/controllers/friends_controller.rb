class FriendsController < FacebookController
  before_filter :friend, :only => :show
  before_filter :friends
  helper_method :friend
  respond_to :html, :json
    def index
      respond_with(@friends)
    end

    def show
     @friend_info = friend.info
     @ranked_commenters = friend.ranked_commenters
     @feed = friend.feed_comments.flatten
    end
  
  protected
    def friend
      @friend ||= current_user.friend(params[:id])
    end
    
    def friends
      @friends ||= current_user.friends || []
      @friends = friends.keep_if {|f| f['name'].downcase =~ /#{params['name'].downcase}/} if params['name'].present?
    end
end