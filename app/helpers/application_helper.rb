module ApplicationHelper
  REGEXP_URL = /(\s|^)(((https?|ftp)\:\/\/)?([a-z0-9]{1})((\.[a-z0-9-])|([a-z0-9-]))*[\.:]([a-z0-9]{2,4})(\/[^\s]{0,})?)/i
  URL_POSITION = 1
  JS_NOOP = "javascript:void(false);"

  def convert_link(url)
    url.scan(/^https?:\/\//).any? ? url : "http://#{url}"
  end

  def auto_detected_link(description)
    description.gsub!(/\r\n/, " <br> ")
    description.gsub!(REGEXP_URL) do |url|  
      "<a href='#{convert_link(url)}' rel='nofollow' target='_blank'>#{url}</a>"
    end  
    description.html_safe
  end
end
