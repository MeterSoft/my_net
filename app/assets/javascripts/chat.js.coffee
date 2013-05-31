#$(document).ready ->
#  client.subscribe '/chat', (payload)->
#    time = moment(payload.created_at).format('D/M/YYYY H:mm:ss')
#    $('#chat').append("<li>#{time} : #{payload.message}</li>")
#
#  input = $('#chat_message')
#  button = $('#submit_message')
#  button.click ->
#    button.attr('disabled', 'disabled')
#    button.text('Posting...')
#    publication = client.publish '/chat',
#      message: input.val()
#      created_at: new Date()
#    publication.callback ->
#      input.val('')
#      button.removeAttr('disabled')
#      button.text('Post')
#    publication.errback ->
#      button.removeAttr('disabled')
#      button.text('Try again')
