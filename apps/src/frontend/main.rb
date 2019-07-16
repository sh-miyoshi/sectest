require 'sinatra'
require 'json'
require 'net/http'
require 'uri'
require 'webrick/https'
require 'logger'

logger = Logger.new(STDOUT)

set :bind, '0.0.0.0'

get '/' do
  @val = nil
  @out_val = nil
  erb :index
end

post '/data' do
  @out_val = nil

  uri = 'http://' + ENV['API_SERVER_URL'] + ':4567/api'
  url = URI.parse(uri)

  req = Net::HTTP::Post.new(url.request_uri)

  logger.info("params: " + params.to_s)

  req['x-request-id'] = params['x-request-id']
  req['x-b3-traceid'] = params['x-b3-traceid']
  req['x-b3-spanid'] = params['x-b3-spanid']
  req['x-b3-parentspanid'] = params['x-b3-parentspanid']
  req['x-b3-sampled'] = params['x-b3-sampled']
  req['x-b3-flags'] = params['x-b3-flags']
  req['x-ot-span-context'] = params['x-ot-span-context']

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

get '/outside' do
  @val = nil
  uri = "http://25.io/toau/audio/sample.txt"
  url = URI.parse(uri)
  @out_val = Net::HTTP.get(url)
  erb :index
end
