require 'nokogiri'
require 'open-uri'

class PreviewLink

  attr_accessor :doc, :link, :meta_data

  def initialize(link)
    @link = link
    begin
      @doc =  Nokogiri::HTML(open(link))
      @meta_data = @doc.xpath("//head//meta")
    rescue
    end
  end

  def link_info
    @doc ? { title: title, description: description, url: @link, image_url: image_url, status: true } : { status: false }
  end

  private

  def title
    title = nil
    @meta_data.each do |meta|
      title = meta['content'] if meta['property'] == 'og:title'
    end
    title = doc.at_xpath("//head//title").text if title.blank?
    title = doc.title if title.blank?
    title
  end

  def description
    description = nil
    @meta_data.each do |meta|
      description = meta['content']  if meta['property'] == 'og:description' || meta['name'] == 'description'
    end
    description
  end

  def image_url
    image_url = nil
    @meta_data.each do |meta|
      image_url = meta['content'] if ['link', 'og:image'].include? meta['property']
    end
    if image_url.blank?
      @doc.xpath("//head//link").each do |meta|
        image_url = meta['href'] if meta['rel'] == 'image_src'
      end
    end
    image_url
  end
end
