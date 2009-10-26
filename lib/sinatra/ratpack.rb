require 'sinatra/base'

module Sinatra
  module Ratpack

    # Accepts a single filename or an array of filenames (with or without .js extension)
    # Assumes javascripts are in public/javascripts
    def javascript_include_tag(string_or_array, *args)
      files = string_or_array.is_a?(Array) ? string_or_array : [string_or_array]
      options = {
        :charset => "utf-8",
        :type => "text/javascript",
      }.merge(args.extract_options!)

      files.map do |file|
        path = "#{ file.gsub(/\.js/i, "") }.js" # Append .js if needed
        path = "/javascripts/#{path}" unless path.include? "://" # Add stylesheets directory to path if not a full URL
        options[:src] = url_for(path)
        content_tag(:script, "", options)
      end.join("\n")
    end
  
    # Accepts a single filename or an array of filenames (with or without .css extension)
    # Assumes stylesheets are in public/stylesheets
    def stylesheet_link_tag(string_or_array, *args)
      files = string_or_array.is_a?(Array) ? string_or_array : [string_or_array]
      options = {
        :charset => "utf-8",
        :media => "screen, projection",
        :rel => "stylesheet",
        :type => "text/css",
      }.merge(args.extract_options!)

      files.map do |file|
        path = "#{ file.gsub(/\.css/i, "") }.css" # Append .css if needed
        path = "/stylesheets/#{path}" unless path.include? "://" # Add stylesheets directory to path if not a full URL
        options[:href] = url_for(path)
        tag(:link, options)        
      end.join("\n")
    end
        
    # Accepts a full URL, an image filename, or a path underneath /public/images/
    def image_tag(src, options={})
      options[:src] = url_for(src)
      tag(:img, options)
    end
    
    # Works like link_to, but href is optional. If no href supplied, content is used as href
    def link_to(content,href=nil,options={})
      href ||= content
      options.update :href => url_for(href)
      content_tag :a, content, options
    end
  
    # Just like Rails' content_tag
    def content_tag(name,content,options={})
      "<#{name} #{options.to_html_attrs}>#{content}</#{name}>"
    end
  
    # Just like Rails' tag
    def tag(name,options={})
      "<#{name} #{options.to_html_attrs} />"
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
    
    # Construct a link to +url_fragment+, which should be given relative to
    # the base of this Sinatra app.  The mode should be either
    # <code>:path_only</code>, which will generate an absolute path within
    # the current domain (the default), or <code>:full</code>, which will
    # include the site name and port number.  (The latter is typically
    # necessary for links in RSS feeds.)  Example usage:
    #
    #   url_for "/"                       # Returns "/myapp/"
    #   url_for "/foo"                    # Returns "/myapp/foo"
    #   url_for "/foo", :full             # Returns "http://example.com/myapp/foo"
    #   url_for "http://bar.com"          # Returns "http://bar.com"
    def url_for url_fragment, mode=:path_only
      return url_fragment if url_fragment.include? "://"
      url_fragment = "/#{url_fragment}" unless url_fragment.starts_with? "/"
      case mode
      when :path_only
        base = request.script_name
      when :full
        scheme = request.scheme
        if (scheme == 'http' && request.port == 80 ||
            scheme == 'https' && request.port == 443)
          port = ""
        else
          port = ":#{request.port}"
        end
        base = "#{scheme}://#{request.host}#{port}#{request.script_name}"
      else
        raise TypeError, "Unknown url_for mode #{mode}"
      end
      "#{base}#{url_fragment}"
    end 

  end

  helpers Ratpack
end

class Array
  def extract_options!
    last.is_a?(::Hash) ? pop : {}
  end
end

class Hash
  def to_html_attrs
    self.map{ |k,v| "#{k}=\"#{v}\"" }.sort.join(" ")
  end
end

class String
 def starts_with?(prefix)
   prefix = prefix.to_s
   self[0, prefix.length] == prefix
 end
end