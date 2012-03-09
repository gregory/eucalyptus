class FriendsController < FacebookController
  before_filter :friend, :only => :show
  before_filter :friends
  helper_method :friend
  respond_to :html, :json
    def index
      respond_with(@friends)
    end

    def show
     @feed = friend.feed_content
      @ranked_commenters = friend.ranked_commenters_without_batch
    end
  
  protected
    def friend
      @friend ||= current_user.friend(params[:id])
    end
    def friends
      return @friends if @friends.present?
      friends = current_user.friends
      friends = friends.keep_if {|f| f['name'].downcase =~ /#{params['name'].downcase}/} if params['name'].present?
      @friends = friends.first(10)
    end
end