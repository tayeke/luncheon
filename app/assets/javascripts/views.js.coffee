#items
LunchView = Backbone.View.extend
  tagName: 'li'
  template: -> render '/lunches/template'
  render: ->
    attributes = @.model.toJSON()
    @.$el.html @.template(attributes)

#collections
LunchCollectionView = Backbone.View.extend
  tagName: 'ul'
  url: '/lunches'
  initilize: ->
    @.collection.on 'fetch', @.addAll, @
    @.collection.on 'add',   @.addOne, @
  addOne: (lunch) ->
    lunchView = new LunchView
      model: lunch
    lunchView.render()
    @.$el.append(lunchView.$el)
  allAll: (collection) ->
    collection.forEach @.addOne, @