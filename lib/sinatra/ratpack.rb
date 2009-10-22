require 'sinatra/base'

module Sinatra
  module Ratpack

    # Accepts a single filename or an array of filenames (with or without .js extension)
    # Assumes javascripts are in public/javascripts
    def javscript_include_tag(string_or_array)
      files = string_or_array.is_a?(Array) ? string_or_array : [string_or_array]
      files.map do |file|
        path = "/javascripts/#{ file.gsub(/\.js/i, "") }.js"
        "<script type='text/javascript' src='#{path}'></script>"
      end.join("\n")
    end
  
    # Accepts a single filename or an array of filenames (with or without .css extension)
    # Assumes stylesheets are in public/stylesheets
    def stylesheet_link_tag(string_or_array)
      files = string_or_array.is_a?(Array) ? string_or_array : [string_or_array]
      files.map do |file|
        path = "/stylesheets/#{ file.gsub(/\.css/i, "") }.css"
        "<link rel='stylesheet' type='text/css' media='screen, projection' href='#{path}'>"
      end.join("\n")
    end
        
    # Accepts a full URL, an image filename, or a path underneath /public/images/
    def image_tag(src,options={})
      options[:src] = src.include?("://") ? src : "/images/#{src}"
      tag(:img, options)
    end
    
    # Works like link_to, but href is optional. If no href supplied, content is used as href
    def link_to(content,href=nil,options={})
      href ||= content
      options.update :href => href
      content_tag :a, content, options
    end
  
    # Just like Rails' content_tag
    def content_tag(name,content,options={})
      options = options.map{ |k,v| "#{k}='#{v}'" }.join(" ")
      "<#{name} #{options}>#{content}</#{name}>"
    end
  
    # Just like Rails' tag
    def tag(name,options={})
      options = options.map{ |k,v| "#{k}='#{v}'" }.join(" ")
      "<#{name} #{options} />"
    end

    # Give this helper an array, and get back a string of <li> elements. 
    # The first item gets a class of first and the last, well.. last. 
    # This makes it easier to apply CSS styles to lists, be they ordered or unordered.
    def convert_to_list_items(items)
      items.inject([]) do |all, item|
        css = []
        css << "first" if items.first == item
        css << "last" if items.last == item
        all << content_tag(:li, item, :class => css.join(" "))
      end.join("\n")
    end

  end

  helpers Ratpack
end