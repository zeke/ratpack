path = File.expand_path("../lib" + File.dirname(__FILE__))
$:.unshift(path) unless $:.include?(path)

require 'rubygems'
require 'sinatra'
require 'sinatra/ratpack'

get "/url_for" do
  content_type "text/plain"
  <<"EOD"
#{url_for("/")}
#{url_for("/foo")}
#{url_for("/foo", :full)}
EOD
end

get "/image_tag" do
  content_type "text/plain"
  <<"EOD"
#{image_tag("foo.jpg", :alt => "[foo image]")}
#{image_tag("http://example.com/bar.png", :alt => "[bar image]")}
EOD
end

get "/stylesheet_link_tag" do
  content_type "text/plain"
  <<"EOD"
#{stylesheet_link_tag(%w(winter summer), :media => "projection")}
#{stylesheet_link_tag("http://example.com/autumn.css")}
EOD
end

get "/javascript_include_tag" do
  content_type "text/plain"
  <<"EOD"
#{javascript_include_tag "summer.js"}
#{javascript_include_tag "http://example.com/autumn.js"}
#{javascript_include_tag %w(day night)}
EOD
end

get "/link_to_tag" do
  content_type "text/plain"
  <<"EOD"
#{link_to "Tatry Mountains Rescue Team", "/topr"}
#{link_to "no_label.xyz"}
#{link_to "Party", "http://foo.com/party/time"}
#{link_to "Food", "/cheezburger", :title => "food"}
EOD
end
