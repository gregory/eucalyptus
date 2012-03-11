module FacebookHelper
  def facebook_login_button(size='large')
    content_tag("fb:login-button", nil , {
      :scope => 'user_likes, user_checkins, friends_likes, friends_checkins, friends_status, user_status, email, read_stream',
      :id => "fb_login",
      :autologoutlink => 'true',
      :size => size,
      :onlogin => 'location = "/"'})
  end
end