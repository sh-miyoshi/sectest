require 'sinatra'
require 'json'
require 'net/http'
require 'uri'
require 'webrick/https'

set :bind, '0.0.0.0'

get '/' do
  @val = nil
  erb :index
end

post '/data' do
  uri = "http://" + ENV['API_SERVER_URL'] + ":4567/api"
  url = URI.parse(uri)

  req = Net::HTTP::Post.new(url.request_uri)
  req.body = {
    "user" => params[:user],
    "password" => params[:password]
  }.to_json
  res = Net::HTTP.start(url.host, url.port) do |http|
    http.request(req)
  end
  if (200 <= res.code.to_i && res.code.to_i < 300) then
    @val = JSON.parse(res.body)
  else
    @val = Array.new
    @val.push("Error")
  end

  erb :index
end
