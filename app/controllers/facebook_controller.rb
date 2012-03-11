class FacebookController < ApplicationController

  before_filter :facebook_auth
  before_filter :require_login, :except => :login

  helper_method :logged_in?, :current_user
    
    def page
      %{about}.include?(params[:name]) ? (render  params[:name].to_sym) : (redirect_to :root)
    end
    
  protected
    
    def logged_in?
      !!@user
    end

    def current_user
      @user
    end

    def require_login
      unless logged_in?
        redirect_to :new_session
      end
    end

    def facebook_auth
      @oauth = Koala::Facebook::OAuth.new(FACEBOOK_APP_ID, FACEBOOK_SECRET_KEY)
      if fb_user_info = @oauth.get_user_info_from_cookie(request.cookies)
       @user = User.new(fb_user_info['access_token'], fb_user_info['user_id'])
      end
      rescue Errno::ECONNRESET,Errno::ECONNABORTED,Errno::ETIMEDOUT
        flash[notice] = 'A problem occured please ensure you are connected'
        redirect_to :new_session
    end
end
