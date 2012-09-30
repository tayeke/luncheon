#models
@Lunch = Backbone.Model.extend
  initialize: (lunch) ->

#collections
@LunchCollection = Backbone.Collection.extend
  model: Lunch
  url: '/lunches.json'
  initialize: ->
    #begin listening for changes to models and new models
    stream = new ESHQ 'lunch-channel'
    stream.onmessage = (e) =>
      log e
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
    @.collection.on 'add',   @.addOne, @
  addOne: (lunch) ->
    lunchView = new LunchView
      model: lunch
    lunchView.render()
    @.$el.prepend lunchView.$el
  addAll: (collection) ->
    collection.forEach @.addOne, @