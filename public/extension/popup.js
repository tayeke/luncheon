$(function(){
  $.get('http://localhost:3000/lunches.json', function(resp){
    alert(resp);
  });
});