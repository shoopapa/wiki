require "sinatra"
require "sinatra/reloader"
require "uri"

def page_content(title)
    File.read("pages/#{title}.txt")
rescue Errno::ENOENT 
    return nil 
end

def save_file(title, content)
    File.open("pages/#{title}.txt", "w") do |file|
        file.print(content)
    end
end

def edit(source, name, content)
    File.rename("pages/#{source}.txt", name)
    save_file(name, content)
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

get "/intro/:name/edit" do
    @name = params[:name]
    @content = page_content(@name) 
    erb :edit_intro
end

post "/intro/:new/edit" do
    edit(params[:new], params[:name], params[:intro])
    redirect URI.escape("/intro/#{params[:name]}")
end
