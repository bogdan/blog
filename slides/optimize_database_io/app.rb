require "sinatra"
require "haml"
require "sass"

get '/', :provides => 'html' do

  haml :index
end
