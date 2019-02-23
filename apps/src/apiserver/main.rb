require 'sinatra'
require 'mysql2'
require 'json'

set :bind, '0.0.0.0'

post '/api', provides: :json do
  params = JSON.parse(request.body.read)
  begin
    mysql = Mysql2::Client.new(
      username: params['user'],
      password: params['password'],
      database: 'secret',
      host: ENV['MYSQL_ADDR']
    )
    data = []
    mysql.query('select * from info').each do |row|
      data << row
    end
    return data.to_json
  rescue StandardError => e
    p e.message
    status 400
  end
end
