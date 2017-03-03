require "sinatra"
require "haml"
require "sass"

get '/', :provides => 'html' do

  headers 'Access-Control-Allow-Origin' => 'http://lab.hakim.se'
  haml :index
end

get "/test", provides: 'html' do
  haml :test
end
