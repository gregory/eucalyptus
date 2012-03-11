class SessionsController < ApplicationController
  before_filter :login?
    def new
    end
  protected
    def login?
      @oauth = Koala::Facebook::OAuth.new(FACEBOOK_APP_ID, FACEBOOK_SECRET_KEY)
      redirect_to root_url if @oauth.get_user_info_from_cookie(request.cookies)
    end
end