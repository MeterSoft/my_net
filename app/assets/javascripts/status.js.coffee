@Status = ->

Status.update = (id) ->
  client.publish '/update_status',
    user_id: id
    message: 'status'
    created_at: new Date()
