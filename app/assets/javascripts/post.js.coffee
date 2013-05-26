@Post = ->

Post.remove = (url) ->
  $popup = $('#delete_post_popup');
  $popup.find('.confirm').attr 'href', url
  $popup.modal 'show'

Post.popover = ->
  $('.comment').popover
    html: true
    placement: "bottom"
    content: ->
      $("#reply_popover_" + $(this).data('id')).html()