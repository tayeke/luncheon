$ ->
  # init

  lunches = new LunchCollection()
  lunchesView = new LunchCollectionView
    collection: lunches
  lunches.fetch()
  $('#lunches').append lunchesView.$el

  lunchForm = $('#new_lunch')
  lunchForm.submit (e) ->
    e.preventDefault()
    $.post '/lunches', lunchForm.serialize(), ->
      lunchForm[0].reset()
    return false