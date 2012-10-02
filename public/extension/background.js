$(function(){
  stream = new ESHQ('lunch-notifications', {auth_url: 'http://lunch.rh-apps.com/eshq/socket'});
  stream.onmessage = function(e) {
    var parsed = JSON.parse(e.data);
    if(parsed.type == 'add'){
      var title = parsed.person.name+' joined a lunch';
      var content = parsed.lunch.place+' - '+timeToLocalString(new Date(parsed.lunch.start_time));
      var notification = webkitNotifications.createNotification('icon.png', title, content);
      notification.show();
    } else if(parsed.type == 'new') {
      var title = 'New lunch by '+parsed.lunch.creator_name;
      var content = parsed.lunch.place+' - '+timeToLocalString(new Date(parsed.lunch.start_time));
      var notification = webkitNotifications.createNotification('icon.png', title, content);
      notification.show();
    }
  }
  timeToLocalString = function(t) {
    var hours = t.getHours();
    var period = 'AM';
    if(hours > 12) {
      hours = hours - 12;
      period = 'PM';
    } else if(hours == 0) {
      hours = 12;
    }
    var minutes = (t.getMinutes() == 0) ? '00' : t.getMinutes();
    var now = new Date();
    var tomorrow = new Date(now.getFullYear(), now.getMonth() , now.getDate()).getTime() + 84600000;
    var date = t.getMonth()+1+'/'+t.getDate();
    var offset = 60000 * 6
    if(now.getTime() - offset < t.getTime() && t.getTime() < tomorrow) {
      date = 'today';
    } else if(tomorrow < t.getTime() && t.getTime() < tomorrow + 84600000) {
      date = 'tomorrow';
    } else if(t.getTime() < now.getTime() - offset) {
      date = 'over';
    }
    return date+' - '+hours+':'+minutes+' '+period;
  }

});
