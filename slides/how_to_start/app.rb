require "sinatra"

get '/', :provides => 'html' do
  haml :index
end
