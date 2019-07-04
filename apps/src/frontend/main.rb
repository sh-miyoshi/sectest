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
  uri = 'http://' + ENV['API_SERVER_URL'] + ':4567/api'
  url = URI.parse(uri)

  req = Net::HTTP::Post.new(url.request_uri)
  req.body = {
    'user' => params[:user],
    'password' => params[:password]
  }.to_json
  begin
    res = Net::HTTP.start(url.host, url.port) do |http|
      http.request(req)
    end
    if res.code.to_i >= 200 && res.code.to_i < 300
      @val = JSON.parse(res.body)
    else
      @val = []
      @val.push(res.msg)
      @val.push(res.body)
    end
  rescue
      @val = []
      @val.push("Failed to request API server")
  end

  erb :index
end
