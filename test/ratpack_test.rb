require 'sinatra_app'
require 'test/unit'
require 'rack/test'

set :environment, :test

class RatpackTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_url_for
    get '/url_for', {}, 'SCRIPT_NAME' => '/bar'
    assert last_response.ok?
    assert_equal last_response.body,  <<EOD
/bar/
/bar/foo
http://example.org/bar/foo
EOD
  end
    
  def test_javascript_include_tag
    get '/javascript_include_tag', {}, 'SCRIPT_NAME' => '/bar'
    assert last_response.ok?
    assert_equal last_response.body,  <<EOD
<script charset="utf-8" src="/bar/javascripts/summer.js" type="text/javascript"></script>
<script charset="utf-8" src="http://example.com/autumn.js" type="text/javascript"></script>
<script charset="utf-8" src="/bar/javascripts/day.js" type="text/javascript"></script>
<script charset="utf-8" src="/bar/javascripts/night.js" type="text/javascript"></script>
EOD
  end

  def test_stylesheet_link_tag
    get '/stylesheet_link_tag', {}, 'SCRIPT_NAME' => '/bar'
    assert last_response.ok?
    assert_equal last_response.body,  <<EOD
<link charset="utf-8" href="/bar/stylesheets/winter.css" media="projection" rel="stylesheet" type="text/css" />
<link charset="utf-8" href="/bar/stylesheets/summer.css" media="projection" rel="stylesheet" type="text/css" />
<link charset="utf-8" href="http://example.com/autumn.css" media="screen, projection" rel="stylesheet" type="text/css" />
EOD
  end
  
  def test_image_tag
    get '/image_tag', {}, 'SCRIPT_NAME' => '/bar'
    assert last_response.ok?
    assert_equal last_response.body,  <<EOD
<img alt="[foo image]" src="/bar/images/foo.jpg" />
<img alt="[bar image]" src="http://example.com/bar.png" />
EOD
  end
  
  def test_link_to
    get '/link_to_tag', {}, 'SCRIPT_NAME' => '/bar'
    assert last_response.ok?
    assert_equal last_response.body,  <<EOD
<a href="/bar/topr">Tatry Mountains Rescue Team</a>
<a href="/bar/no_label.xyz">no_label.xyz</a>
<a href="http://foo.com/party/time">Party</a>
<a href="/bar/cheezburger" title="food">Food</a>
EOD
  end
  
end
