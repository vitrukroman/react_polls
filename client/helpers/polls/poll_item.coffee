POST_HEIGHT = 80
Positions = new Meteor.Collection null


Template.pollItem.helpers
  domain: ->
    a = document.createElement 'a'
    a.href = @url
    a.hostname

  ownPoll: ->
    @userId is do Meteor.userId

  upvotedClass: ->
    userId = Meteor.userId()

    if userId and not _.include @upvoters, userId
      'btn-primary upvotable'
    else
      'disabled'

  attributes: ->
    poll = _.extend {}, Positions.findOne(pollId: @_id), @
    newPosition = poll._rank * POST_HEIGHT
    attributes = {}

    if _.isUndefined poll.position
      attributes.class = 'poll invisible'
    else
      offset = poll.position - newPosition
      attributes.style = "top: " + offset + "px"
      if offset is 0
        attributes.class = "poll animate"

    Meteor.setTimeout ->
      Positions.upsert
        pollId: poll._id
      ,
        $set:
          position: newPosition

    attributes


Template.pollItem.events
  'click .upvotable': (e) ->
    do e.preventDefault

    Meteor.call 'upvote', @_id