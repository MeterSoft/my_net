@HeaderSearch = ->

HeaderSearch.start = ->
  $("#search-icon").popover
    html: true
    placement: "bottom"
    content: ->
      $("#header-search-popover").html()

  $("body").on "click", "#search-icon", ->
    $(this).parents().find("#user_search").focus()

  $timeout = undefined
  $("body").on "input", "#user_search", (e) ->
    $("#result-section-search-users").html ""
    clearTimeout $timeout
    $timeout = setTimeout(->
      if $("#user_search").val().length > 1
        $("#search-loader").removeClass "hide"
        $.ajax
          url: "/users_searches"
          data: "search=" + $("#user_search").val()
          success: ->
            $("#search-loader").addClass "hide"

    , 700)