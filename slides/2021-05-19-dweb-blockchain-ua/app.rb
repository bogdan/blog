require "sinatra/base"
require "sass"
require "haml"

class MyApp < Sinatra::Base
  set :public_folder, Proc.new { File.join(root, "public") }
  get '/', :provides => 'html' do
    haml :index
  end

  run! if app_file == $0
end
