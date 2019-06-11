require "sinatra"
require "sinatra/reloader"
require "uri"

def page_content(title)
    File.read("pages/#{title}.txt")
rescue Errno::ENOENT 
    return "no page with that name" 
end

def save_file(title,content)
    File.open("pages/#{title}.txt", "w") do |file|
        file.print(content)
    end
end

get "/" do
    erb :welcome
end

get '/intro' do
  redirect '/intro/new'
end

get "/intro/new" do
    erb :new_intro
end

get "/intro/:name"do 
    @name = params[:name]
    @content = page_content(@name)
    erb :minecraft_intro_template
end

post "/intro/create" do
    save_file(params["name"].strip, params["intro"])
    redirect URI.escape("/intro/#{params["name"].strip}")
end

