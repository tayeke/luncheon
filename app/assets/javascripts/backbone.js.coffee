#models
@Lunch = Backbone.Model.extend
  initialize: (lunch) ->
    @.set 
      time_string: @.timeToLocalString new Date(lunch.start_time) 
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
    if now.getTime() < t.getTime() < tomorrow
      date = 'today'
    else if tomorrow < t.getTime() < tomorrow + 84600000
      date = 'tomorrow'
    "#{date} - #{hours}:#{minutes} #{period}"

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

#views
@LunchView = Backbone.View.extend
  tagName: 'li'
  template: render '/lunches/template'
  initialize: (lunchItem) ->
    @.model.on 'change', @.render, @
  render: ->
    attributes = @.model.toJSON()
    @.$el.html @.template attributes

@LunchCollectionView = Backbone.View.extend
  tagName: 'ul'
  initialize: ->
    @.collection.on 'reset', @.addAll, @
    @.collection.on 'add',   @.addNew, @
  addNew: (lunch) ->
    @.addOne lunch, true
  addOne: (lunch, addition = false) ->
    lunchView = new LunchView
      model: lunch
    lunchView.render()
    if addition is true
      @.$('.new').after lunchView.$el
    else
      @.$el.prepend lunchView.$el
  addAll: (collection) ->
    collection.forEach @.addOne, @
    new_element = $('<li>').addClass('new')
    $('#lunches > ul').prepend new_element
    $('#new_lunch').appendTo new_element
    # @.$el.isotope
    #   resizable: false
    #   masonry: 
    #     columnWidth: @.$el.width() / @.$('li').width()
    # $(window).smartresize =>
    #   @.$el.isotope
    #     masonry: 
    #       columnWidth: @.$el.width() / @.$('li').width()