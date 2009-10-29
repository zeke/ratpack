require 'sinatra/base'

module Sinatra
  module Ratpack

    # Accepts a single filename or an array of filenames (with or without .js extension)
    # Assumes javascripts are in public/javascripts
    #
    #   javascript_include_tag "jquery.min"               # <script charset="utf-8" src="/javascripts/jquery.min.js" type="text/javascript"></script>
    #   javascript_include_tag "jquery.min.js"            # <script charset="utf-8" src="/javascripts/jquery.min.js" type="text/javascript"></script>
    #   javascript_include_tag %w(day night)              # <script charset="utf-8" src="/javascripts/day.js" type="text/javascript"></script>\n<script charset="utf-8" src="/javascripts/night.js" type="text/javascript"></script>
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
    #
    #   stylesheet_link_tag "styles", :media => "print"   # <link charset="utf-8" href="/stylesheets/styles.css" media="print" rel="stylesheet" type="text/css" />
    #   stylesheet_link_tag %w(winter summer)             # <link charset="utf-8" href="/stylesheets/winter.css" media="projection" rel="stylesheet" type="text/css" />\n<link charset="utf-8" href="/stylesheets/summer.css" media="projection" rel="stylesheet" type="text/css" />
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
    #
    #   image_tag "pony.png"                        # <image src="/images/pony.png" />
    #   image_tag "http://foo.com/pony.png"         # <image src="http://foo.com/pony.png" />
    def image_tag(src, options={})
      src = "/images/#{src}" unless src.include? "://" # Add images directory to path if not a full URL
      options[:src] = url_for(src)
      tag(:img, options)
    end
    
    # Works like link_to, but href is optional. If no href supplied, content is used as href
    #
    #   link_to "grub", "/food", :class => "eats"   # <a href="/food" class="eats">grub</a>
    #   link_to "http://foo.com"                    # <a href="http://foo.com">http://foo.com</a>
    #   link_to "home"                              # <a href="/home">home</a>
    def link_to(content,href=nil,options={})
      href ||= content
      options.update :href => url_for(href)
      content_tag :a, content, options
    end
  
    # Just like Rails' content_tag
    #
    #   content_tag :div, "hello", :id => "foo"     # <div id="foo">hello</div>
    def content_tag(name,content,options={})
      "<#{name} #{options.to_html_attrs}>#{content}</#{name}>"
    end
  
    # Just like Rails' tag
    #
    #   tag :br, :class => "foo"                    # <br class="foo" />
    def tag(name,options={})
      "<#{name} #{options.to_html_attrs} />"
    end
    
    # Construct a link to +url_fragment+, which should be given relative to
    # the base of this Sinatra app.  The mode should be either
    # <code>:path_only</code>, which will generate an absolute path within
    # the current domain (the default), or <code>:full</code>, which will
    # include the site name and port number.  (The latter is typically
    # necessary for links in RSS feeds.)  Example usage:
    #
    #   url_for "/"                                 # "/myapp/"
    #   url_for "/foo"                              # "/myapp/foo"
    #   url_for "/foo", :full                       # "http://example.com/myapp/foo"
    #   url_for "http://bar.com"                    # "http://bar.com"
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