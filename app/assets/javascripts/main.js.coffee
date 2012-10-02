$ ->
  # init
  
  $('select').dropkick()

  lunches = new LunchCollection()
  lunchesView = new LunchCollectionView
    collection: lunches
  lunches.fetch()
  $('#lunches').append lunchesView.$el

  lunchForm = $('#new_lunch')
  lunchForm.submit (e) ->
    e.preventDefault()
    unless not $('#lunch_place').val()
      $.post '/lunches', lunchForm.serialize(), ->
        lunchForm[0].reset()
    false

  $(document).bind 'facebook:connect', ->
    $('.login_btn').hide()
    form = $("#new_lunch")
    form.show()
    $('<input type="hidden" name="lunch[creator]" value="'+window.user_id+'">').appendTo form
    $('<input type="hidden" name="lunch[creator_name]" value="'+window.user_name+'">').appendTo form

  # this is a double check for situations where the facebook library is preloaded
  if window.FB
    fbReady()
  else
    window.fbAsyncInit = fbReady

  $('.login_btn').click ->
    FB.login()

  if is_chrome then $('.chrome').removeClass 'hide'


#facebook authing stuff
fbReady = ->
  FB.init
    appId: fb_app_id
    status: true
    cookie: true
    oauth: true

  FB.Event.subscribe 'auth.authResponseChange', (response) ->
    if response.status == 'connected'
      FB.api '/me', (me) ->
        window.user_id = me.id
        window.user_name = me.name
        $(document).trigger 'facebook:connect'
