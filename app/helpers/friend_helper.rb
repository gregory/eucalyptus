module FriendHelper
  
  def friend_picture(uid, format=nil)
    format = %w{small large}.include?(format) ? format : 'square'
    %{https://graph.facebook.com/#{uid}/picture?type=#{format}}
  end
  
  def facebook_object_url(id)
    %{https://www.facebook.com/#{id}}
  end
end