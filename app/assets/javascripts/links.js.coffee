@Link = ->

Link.detected = (obj) ->
  flag = false;
  link = null
  regexp = /(\s|^)(((https?|ftp)\:\/\/)?([a-z0-9]{1})((\.[a-z0-9-])|([a-z0-9-]))*[\.:]([a-z0-9]{2,4})(\/[^\s]{0,})?)/ig;
  url_position = 2
  preview = $(obj).parent();
  link = regexp.exec($(obj).val());
  if link == null
    preview.find('#section_preview_link').addClass('hide');
  else
    if link[url_position].match(/^https?:\/\//ig) == null
      link[url_position] = 'http://' + link[url_position]
    url = $(obj).attr('data-url');
    if !flag and link[url_position] != null
      flag = true
      $.ajax
        url: url
        data:
          url: link[url_position]
        type: "GET"
        dataType: 'json'
        success: (data) ->
          flag = false
          if !data.status
            preview.find('#section_preview_link').addClass('hide');
          else
            preview.find('#section_preview_link').removeClass('hide');
            preview.find('#url').html("<a rel='nofollow' target='_blank' href='" + data.url + "'>" + data.url + "</a>");
            preview.find('#title').html(data.title);
            preview.find('#image').html('<image src=' + data.image_url + ' height=50px></image>');
            preview.find('#description').html(data.description);
  return true;
