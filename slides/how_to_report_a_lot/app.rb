require "sinatra"
require "sass"
require "haml"

set :public_folder, Proc.new { File.join(root, "public") }

get '/', :provides => 'html' do
  haml :index
end
