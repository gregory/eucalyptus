FACEBOOK = {
  global: function() {
    var e = document.createElement('script');
    e.type = 'text/javascript';
    e.src = document.location.protocol + '//connect.facebook.net/en_US/all.js';
    e.async = true;
    document.getElementById('fb-root').appendChild(e);
  }
};
EUCALYPTUS = {
  friends_h: function(name){ return $('input.search-query').data('source')},
  friends_named: function(){
    var friend_list=[];
    EUCALYPTUS.friends_h().map(function(h){
       friend_list.push(h['name'])
    });
    return friend_list;
  },
  friend_with_name: function(name){
    source = EUCALYPTUS.friends_h();
    for (var o in source){
      if (source[o].name == name)
        return source[o];
    }
    return false;
  },
  friends_with_name_like: function(name){
    return EUCALYPTUS.friends_h().filter(function(o){ return o.name.match( new RegExp(name, 'i'))}).slice(0,66)
  }
}
$(document).ready(function(){
  FACEBOOK.global();
   $('.profile-picture').tooltip({
     selector: "a[rel=tooltip]"
   });
   $('input.search-query').typeahead({
     source: EUCALYPTUS.friends_named(),
     onselect: function (obj) {
       window.location = '/friends/' + EUCALYPTUS.friend_with_name(obj)['uid']
     }
   })
   .on('keyup', function(ev){ 
     var val = $('input.search-query').val();
     $('ul.friend_list').children().remove();
     EUCALYPTUS.friends_with_name_like(val).map(function(o){
       $('ul.friend_list').append("<li class='span1'><div class='profile-picture'><a data-original-title='"+ o.name +"' href='/friends/"+o.uid+"' rel='tooltip'><img alt='"+o.name+"' src='https://graph.facebook.com/"+o.uid+"/picture?type=square'/></a></div></li>");
       $('.profile-picture').tooltip({
         selector: "a[rel=tooltip]"
       });
     });
    });
});
