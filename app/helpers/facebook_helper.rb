module FacebookHelper
  def facebook_login_button(size='large')
    content_tag("fb:login-button", nil , {
      :scope => 'user_likes, friends_likes',
      :id => "fb_login",
      :autologoutlink => 'true',
      :size => size,
      :onlogin => 'location = "/"'})
  end
  def facebook_picture(uid, format=nil)
    format = %w{small large}.include?(format) ? format : 'square'
    %{https://graph.facebook.com/#{uid}/picture?type=#{format}}
  end
  def facebook_object_url(id)
    %{https://www.facebook.com/#{id}}
  end
end
