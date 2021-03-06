channel = undefined

Router.map ->
  this.route 'dashboard',
    path: '/'
    template: 'dashboard'
    waitOn: -> channel = Meteor.subscribe 'tasks-day', Session.get 'viewDate'
    unload: -> do channel.stop
    data:
      tasks: -> _.sortBy Tasks.find().fetch(), (a, b)-> if a.completed == true then return 1 else return -1


Template.dashboard.events
  'click .check i': (event, template)->
    $i = $(event.target)
    id = $i.closest('tr').data('id')

    if $i.hasClass('fa-check-square-o') then completed = false else completed = true
    Tasks.update { _id: id }, { $set: { completed: completed } }

  'click i.fa-trash-o': (event, template)->
    Tasks.remove { _id: $(event.target).closest('tr').data('id') }

