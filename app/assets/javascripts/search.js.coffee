@Search = ->

Search.start = ->
  $("#group-search-icon").popover
    html: true
    placement: "bottom"
    content: ->
      $("#group-search-popover").html()

  $("body").on "click", "#group-search-icon", ->
    $(this).parents().find("#group_user_search").focus()

  $timeout = undefined
  $("body").on "input", "#group_user_search", (e) ->
    $("#group-result-section-search-users").html ""
    clearTimeout $timeout
    $timeout = setTimeout(->
      if $("#group_user_search").val().length > 1
        $("#group-search-loader").removeClass "hide"
        $.ajax
          url: $('#group-search-popover').data('search-url')
          data: "search=" + $("#group_user_search").val()
          success: ->
            $("#group-search-loader").addClass "hide"

    , 700)