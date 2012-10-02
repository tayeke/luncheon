#models
@Lunch = Backbone.Model.extend
  initialize: (lunch) ->
    @.set 
      time_string: @.timeToLocalString new Date(lunch.start_time) 
      created: false
      attending: false
  timeToLocalString: (t) ->
    hours = t.getHours()
    period = 'AM'
    if hours > 12
      hours = hours - 12
      period = 'PM'
    else if hours is 0 
      hours = 12
    minutes = if t.getMinutes() is 0 then '00' else t.getMinutes()
    now = new Date()
    tomorrow = new Date(now.getFullYear(), now.getMonth() , now.getDate()).getTime() + 84600000
    date = "#{t.getMonth()+1}/#{t.getDate()}"
    offset = 60000 * 6 # 6 minutes before it actually says something is over
    if now.getTime() - offset < t.getTime() < tomorrow
      date = 'today'
    else if tomorrow < t.getTime() < tomorrow + 84600000
      date = 'tomorrow'
    else if t.getTime() < now.getTime() - offset
      date = 'over'
    "#{date} - #{hours}:#{minutes} #{period}"
  checkUser: ->
    if window.user_id is @.get('creator')
      @.set { created: true }

#collections
@LunchCollection = Backbone.Collection.extend
  model: Lunch
  url: '/lunches.json'
  initialize: ->
    #begin listening for changes to models and new models
    stream = new ESHQ 'lunch-channel'
    stream.onmessage = (e) =>
      parsed = JSON.parse(e.data)
      if existing = @.get(parsed.id)
        existing.set parsed
      else
        @.add parsed
    #allow user to interact after fb auth
    $(document).bind 'facebook:connect', =>
      @.trigger 'user_connected'

#views
@LunchView = Backbone.View.extend
  tagName: 'li'
  template: render '/lunches/template'
  events:
    'click .add':    'addUser'
    'click .cancel': 'removeUser'
  initialize: (lunchItem) ->
    @.model.on 'change', @.render, @
  render: ->
    attributes = @.model.toJSON()
    @.$el.html @.template attributes
  addUser: ->
    params = 
      user:
        fb_id: window.user_id
        name: window.user_name
    $.post "/lunches/#{@.model.id}/add", params
  removeUser: ->
    params = 
      user:
        fb_id: window.user_id
    $.post "/lunches/#{@.model.id}/remove", params

@LunchCollectionView = Backbone.View.extend
  tagName: 'ul'
  initialize: ->
    @.collection.on 'reset',          @.addAll, @
    @.collection.on 'add',            @.addNew, @
    @.collection.on 'user_connected', @.resetPostLogin, @
  resetPostLogin: ->
    @.$el.html('')
    @.collection.reset @.collection.models
    new_element = $('<li>').addClass('new')
    $('#lunches > ul').prepend new_element
    $('#new_lunch').appendTo new_element
  addNew: (lunch) ->
    @.addOne lunch, true
  addOne: (lunch, addition = false) ->
    lunchView = new LunchView
      model: lunch
    lunch.checkUser()
    lunchView.render()
    if addition is true
      @.$('.new').after lunchView.$el
    else
      @.$el.prepend lunchView.$el
  addAll: (collection) ->
    collection.forEach @.addOne, @
    # @.$el.isotope
    #   resizable: false
    #   masonry: 
    #     columnWidth: @.$el.width() / @.$('li').width()
    # $(window).smartresize =>
    #   @.$el.isotope
    #     masonry: 
    #       columnWidth: @.$el.width() / @.$('li').width()