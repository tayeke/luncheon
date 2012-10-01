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
    unless not $('#lunch_place').val()
      $.post '/lunches', lunchForm.serialize(), ->
        lunchForm[0].reset()
    false

  $('select').dropkick()