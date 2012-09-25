#models
Lunch = Backbone.Model.extend

#collections
LunchCollection = Backbone.Collection.extend
  url: '/lunches.json'
  model: Lunch