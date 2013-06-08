module ApplicationHelper
  REGEXP_URL = /(\s|^)(((https?|ftp)\:\/\/)?([a-z0-9]{1})((\.[a-z0-9-])|([a-z0-9-]))*[\.:]([a-z0-9]{2,4})(\/[^\s]{0,})?)/i
  URL_POSITION = 2
  JS_NOOP = "javascript:void(false);"

  def convert_link(url)
    url.scan(/^https?:\/\//).any? ? url : "http://#{url}"
  end

  def auto_detected_link(description)
    description.match(REGEXP_URL) do |url|
      description.sub!(url[URL_POSITION], "<a href='#{convert_link(url[URL_POSITION])}' rel='nofollow' target='_blank'>#{url[URL_POSITION]}</a>")
    end
    description.gsub(/\r\n/, "<br>").html_safe
  end
end
